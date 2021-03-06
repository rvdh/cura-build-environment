#!/bin/sh
# Brew install qt/gcc might return non-zero exit values even though installation was succesfull

for package in cmake gcc protobuf qt; do
    if ! brew list --versions "${package}" 1>/dev/null; then
        brew install "${package}"
        if [ "${package}" == "gcc" ]; then
            brew link --overwrite gcc
        fi
    fi
done

set -eo pipefail
cbe_install_dir=cbe_install_dir

if [ ! -d build ]; then
  mkdir build
fi
cd build

source ../env_osx.sh

if [ ! -e /usr/local/include/X11 ]; then
  sudo ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers/X11 /usr/local/include/X11
fi

for framework in SystemConfiguration CoreFoundation Security; do
  if [ ! -e /usr/local/include/${framework} ]; then
    sudo ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/${framework}.framework/Versions/A/Headers /usr/local/include/${framework}
  fi
done

# Set some environment variables to make sure that the installed tools can be found.
export CPATH=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include
export UNIVERSALSDK='/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk'
export PATH=$cbe_install_dir/bin:$PATH
export PKG_CONFIG_PATH=$cbe_install_dir/lib/pkgconfig:$PKG_CONFIG_PATH
export CLIPPER_PATH="${cbe_install_bin}"

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$cbe_install_dir \
      -DCMAKE_PREFIX_PATH=$cbe_install_dir \
      ..
make
