# Linux cura-build-environment with Python 3.7

This Docker image is based on python:3.7.x-stretch (Debian 9 Stretch). With the
python base image, there is no need to compile Python from scratch, and all
default Python modules are pre-installed. All extra Python modules can be
installed via `pip install`, *****except that sip needs to be compiled and
installed from source**, because `pip install sip` doesn't include the `sip`
compiler, which is needed to build libArcus and libSavitar.

We use Debian 9 Stretch is because we create Cura using AppImage, so all extra
dependencies are packed into a single file. To make the AppImage run on most
Linux distributions, the binaries in the AppImage must be compiled against an
relatively old GLIBC, so they are backwards compatible. Debian 9 Stretch has a
GLIBC version of `2.24-11` and a GCC version of `6.3.0`.

This docker image doesn't need the whole CMake project in the
cura-build-environment repository to build. It uses `pip install` to install
most Python depedencies, except SIP, which is compiled from source so we will
have the sip compiler. Other dependencies such as protobuf, libArcus, and
libSavitar are installed via CMake at the moment.
