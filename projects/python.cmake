set(python_patch_command "")
set(python_configure_command ./configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-shared --enable-ipv6 --with-threads --without-pymalloc )
set(python_build_command make)
set(python_install_command make install)

if(BUILD_OS_OSX)
    # See http://bugs.python.org/issue21381
    # The interpreter crashes when MACOSX_DEPLOYMENT_TARGET=10.7 due to the increased stack size.
    set(python_patch_command sed -i".bak" "9271,9271d" <SOURCE_DIR>/configure)
    if(CMAKE_OSX_SYSROOT)
        set(python_configure_command ${python_configure_command} )
    else()
        set(python_configure_command ${python_configure_command} )
    endif()
endif()

if(BUILD_OS_LINUX)
    # CURA-6739: See Python issue #9998
    # For CTM file loading with trimesh. Trimesh uses ctypes.util.find_library() to find libopenctm.so, but it doesn't
    # respect LD_LIBRARY_PATH in Python 3.5.7, This patch is backported from Python 3.6 and 3.7.
    set(python_patch_command patch Lib/ctypes/util.py ${CMAKE_SOURCE_DIR}/projects/python_ctypes_util.patch)
    # Set a proper RPATH so everything depending on Python does not need LD_LIBRARY_PATH
    set(python_configure_command LDFLAGS=-Wl,-rpath=${CMAKE_INSTALL_PREFIX}/lib ${python_configure_command})
endif()

if(BUILD_OS_WINDOWS)
    # Otherwise Python will not be able to get external dependencies.
    find_package(Subversion REQUIRED)

    set(python_configure_command )

    # Use the Windows Batch script to pass an argument "/p:PlatformToolset=v140". The argument must have double quotes
    # around it, otherwise it will be evaluated as "/p:PlatformToolset v140" in Windows Batch. Passing this argument
    # in CMake via a command seems to always result in "/p:PlatformToolset v140".
    if(BUILD_OS_WIN32)
        set(python_build_command cmd /c "${CMAKE_SOURCE_DIR}/projects/build_python_windows.bat" "<SOURCE_DIR>/PCbuild/build.bat" --no-tkinter -c Release -e -M -p Win32)
        set(python_install_command cmd /c "${CMAKE_SOURCE_DIR}/projects/install_python_windows.bat win32 <SOURCE_DIR> ${CMAKE_INSTALL_PREFIX}")
    else()
        set(python_build_command cmd /c "${CMAKE_SOURCE_DIR}/projects/build_python_windows.bat" "<SOURCE_DIR>/PCbuild/build.bat" --no-tkinter -c Release -e -M -p x64)
        set(python_install_command cmd /c "${CMAKE_SOURCE_DIR}/projects/install_python_windows.bat amd64 <SOURCE_DIR> ${CMAKE_INSTALL_PREFIX}")
    endif()
endif()

ExternalProject_Add(Python
    URL https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz
    URL_MD5 429ae95d24227f8fa1560684fad6fca7
    PATCH_COMMAND ${python_patch_command}
    CONFIGURE_COMMAND "${python_configure_command}"
    BUILD_COMMAND ${python_build_command}
    INSTALL_COMMAND ${python_install_command}
    BUILD_IN_SOURCE 1
)

# Only build geos on Linux
# cryptography requires cffi, which requires libffi
if(BUILD_OS_LINUX)
    SetProjectDependencies(TARGET Python DEPENDS OpenBLAS Geos OpenSSL bzip2-static bzip2-shared xz zlib sqlite3 libffi)
elseif(BUILD_OS_OSX)
    SetProjectDependencies(TARGET Python DEPENDS OpenBLAS Geos OpenSSL xz zlib sqlite3 libffi)
else()
    SetProjectDependencies(TARGET Python DEPENDS OpenBLAS)
endif()

# Make sure pip and setuptools are installed into our new Python
ExternalProject_Add_Step(Python ensurepip
    COMMAND ${Python3_EXECUTABLE} -m ensurepip
    DEPENDEES install
)

ExternalProject_Add_Step(Python upgrade_packages
    COMMAND ${Python3_EXECUTABLE} -m pip install pip==20.3.3
    COMMAND ${Python3_EXECUTABLE} -m pip install setuptools==51.0.0
    COMMAND ${Python3_EXECUTABLE} -m pip install pytest==6.2.1
    COMMAND ${Python3_EXECUTABLE} -m pip install pytest-benchmark==3.2.3
    COMMAND ${Python3_EXECUTABLE} -m pip install pytest-cov==2.10.1
    COMMAND ${Python3_EXECUTABLE} -m pip install mypy==0.790
    DEPENDEES ensurepip
)
