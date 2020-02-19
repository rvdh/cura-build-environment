FROM docker.pkg.github.com/ultimaker/cura-build-environment:python3.7-base-win1809-latest

ADD . C:/src

# Install Python packages
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    C:\\src\\install_python_packages.ps1

# Set up environment variables.
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    C:\\src\\setup_envvars.ps1

# TODO: Install sip, protobuf, libArcus, libSavitar
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    cmd /c C:\\src\\build_vs2017.cmd

# Cleanup
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    Remove-Item -Recurse -Force C:\\src
