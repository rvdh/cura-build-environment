#!/bin/bash

echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

apt-get update
apt-get -t stretch-backports install -y \
  cmake
apt-get install -y \
  curl wget make git patchelf
apt-get clean -y

# Install AppImage
_appimagetool_path="/usr/local/bin/appimagetool.AppImage"
_apprun_path="/usr/local/bin/AppRun"

curl -o "${_appimagetool_path}" -SL https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage
chmod a+x "${_appimagetool_path}"
curl -o "${_apprun_path}" -SL https://github.com/AppImage/AppImageKit/releases/download/12/AppRun-x86_64
chmod a+x "${_apprun_path}"

# Extra libraries need by Cura
apt-get install -y \
  libopenctm1 \
  libgeos-dev

# Install python packages
python3="/usr/local/bin/python3"

"${python3}" -m pip install numpy==1.18.1
"${python3}" -m pip install scipy==1.4.1
"${python3}" -m pip install shapely --no-binary shapely[vectorized]==1.7.0

"${python3}" -m pip install PyQt5==5.14.1

"${python3}" -m pip install appdirs==1.4.3
"${python3}" -m pip install certifi==2019.11.28
"${python3}" -m pip install cffi==1.13.2
"${python3}" -m pip install chardet==3.0.4
"${python3}" -m pip install cryptography==2.8
"${python3}" -m pip install cx-Freeze==6.1
"${python3}" -m pip install decorator==4.4.1
"${python3}" -m pip install idna==2.8
"${python3}" -m pip install lxml==4.5.0
"${python3}" -m pip install netifaces==0.10.9
"${python3}" -m pip install networkx==2.4
"${python3}" -m pip install numpy-stl==2.10.1
"${python3}" -m pip install packaging==20.1
"${python3}" -m pip install pycollada==0.7.1
"${python3}" -m pip install pycparser==2.19
"${python3}" -m pip install pyparsing==2.4.6
"${python3}" -m pip install pyserial==3.4
"${python3}" -m pip install python-dateutil==2.8.1
"${python3}" -m pip install python-utils==2.3.0
"${python3}" -m pip install requests==2.22.0
"${python3}" -m pip install sentry-sdk==0.14.1
"${python3}" -m pip install six==1.14.0
"${python3}" -m pip install trimesh==3.2.33
"${python3}" -m pip install typing==3.7.4.1
"${python3}" -m pip install twisted==19.10.0
"${python3}" -m pip install urllib3==1.25.8
"${python3}" -m pip install PyYAML==5.3
"${python3}" -m pip install zeroconf==0.24.4

# Install Sip
cd /tmp
wget "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.20/sip-4.19.20.tar.gz"
tar xaf sip-4.19.20.tar.gz
cd sip-4.19.20
"${python3}" ./configure.py -u
make
make install

# Install libSavitar
cd /tmp
git clone "https://github.com/Ultimaker/libSavitar.git"
cd libSavitar
cmake \
  -DCMAKE_INSTALL_PREFIX="/usr/local" \
  -DCMAKE_PREFIX_PATH="/usr/local" \
  -DBUILD_STATIC=OFF -DBUILD_TESTS=OFF .
make
make install

# Install protobuf
cd /tmp
git clone -b "cura/3.9.2" "https://github.com/Ultimaker/protobuf.git"
cd protobuf
cmake \
  -DCMAKE_INSTALL_PREFIX="/usr/local" \
  -Dprotobuf_BUILD_SHARED_LIBS=ON \
  -Dprotobuf_BUILD_TESTS=OFF \
  -Dprotobuf_BUILD_EXAMPLES=OFF \
  -Dprotobuf_WITH_ZLIB=OFF \
  ./cmake
make
make install

# Install libArcus
cd /tmp
git clone "https://github.com/Ultimaker/libArcus.git"
cd libArcus
cmake \
  -DCMAKE_INSTALL_PREFIX="/usr/local" \
  -DCMAKE_PREFIX_PATH="/usr/local" \
  -DBUILD_PYTHON=ON \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_STATIC=OFF \
  .
make
make install

rm -rf /tmp/*
