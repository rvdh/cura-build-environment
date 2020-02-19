@echo OFF

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

mkdir C:\tmp
cd C:\tmp

REM ---
REM --- Build Sip
REM ---
powershell -Command "iwr -Uri https://www.riverbankcomputing.com/static/Downloads/sip/4.19.21/sip-4.19.21.zip -OutFile sip-4.19.21.zip"
powershell -Command "Expand-Archive -Path sip-4.19.21.zip -DestinationPath ./"
cd sip-4.19.21
python configure.py
nmake
nmake install
cd C:\tmp
REM -- rmdir /s/q sip-4.19.12
REM --del sip-4.19.12.zip


REM ---
REM --- Build libSavitar
REM ---
git clone -b master --depth=1 https://github.com/Ultimaker/libSavitar.git
cd libSavitar
mkdir tmp-build
cd tmp-build
cmake ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=C:\cura-build-environment ^
  -DBUILD_PYTHON=ON ^
  -DBUILD_STATIC=ON ^
  -DBUILD_TESTS=OFF ^
  -G "NMake Makefiles" ^
  ..
nmake
nmake install
cd C:\tmp


REM ---
REM --- Build protobuf
REM ---
git clone -b cura/3.9.2 --depth=1 https://github.com/Ultimaker/protobuf.git
cd protobuf
mkdir tmp-build
cd tmp-build
cmake ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=C:\cura-build-environment ^
  -Dprotobuf_BUILD_SHARED_LIBS=OFF ^
  -Dprotobuf_BUILD_EXAMPLES=OFF ^
  -Dprotobuf_BUILD_TESTS=OFF ^
  -Dprotobuf_WITH_ZLIB=OFF ^
  -G "NMake Makefiles" ^
  ../cmake
nmake
nmake install
cd C:\tmp


REM ---
REM --- Build libArcus
REM ---
git clone -b WIP_py3.7 --depth=1 https://github.com/Ultimaker/libArcus.git
cd libArcus
mkdir tmp-build
cd tmp-build
cmake ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=C:\cura-build-environment ^
  -DCMAKE_PREFIX_PATH=C:\cura-build-environment ^
  -DBUILD_STATIC=ON ^
  -DMSVC_STATIC_RUNTIME=ON ^
  -DBUILD_EXAMPLES=OFF ^
  -DBUILD_PYTHON=ON ^
  -G "NMake Makefiles" ^
  ..
nmake
nmake install
cd C:\tmp


REM --- Clean up
cd C:\
rmdir /s/q C:\tmp
