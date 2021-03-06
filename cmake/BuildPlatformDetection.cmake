set(BUILD_OS_OSX OFF)
set(BUILD_OS_LINUX OFF)
set(BUILD_OS_WINDOWS OFF)
set(BUILD_OS_WIN32 OFF)
set(BUILD_OS_WIN64 OFF)

if(APPLE)
    set(BUILD_OS_OSX ON)
    message(STATUS "Building for OSX")
elseif(WIN32)
    set(BUILD_OS_WINDOWS ON)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(BUILD_OS_WIN64 ON)
        message(STATUS "Building for 64-bit Windows")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(BUILD_OS_WIN32 ON)
        message(STATUS "Building for 32-bit Windows")
    else()
        message(FATAL_ERROR "Could not determine platform architecture!")
    endif()
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(BUILD_OS_LINUX ON)
    message(STATUS "Building for Linux")
endif()
