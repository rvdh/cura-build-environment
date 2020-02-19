# TODOs

This pages explains what needs to be done for the Python 3.7-based images.

## Windows

The current Python 3.7-base Windows image has all the toolchains and libraries installed, except:

 - `libopenctm`, which should be compiled and installed in the image. In the `cura-build` repository, for the packaging
   part, `libopenctm.dll` should be included into the package.
 - The image currently uses the CuraEngine artifact from CloudSmith
   https://cloudsmith.io/~ultimaker/repos/cura-public/packages/detail/cura-curaengine-mingw-w64_450-1zip-2/,
   which is cross compiled with MinGW 64 in a debian docker container for the `CuraEngine` master branch. To make this
   fully work, we will need a complete pipeline/workflow for creating those packages for release tags and candidate
   branches, which can be a lot of work. An "easier" approach can be to compile CuraEngine during packaging in
   `cura-build` as what we do right now. To do this, protobuf and libArcus need to be compiled and installed in the
   Python 3.7-based Windows image with MinGW 64.
