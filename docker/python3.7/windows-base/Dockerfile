FROM python:3.7.6-windowsservercore-1809

ADD . C:/src

# Install chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    Invoke-WebRequest -Uri 'https://chocolatey.org/install.ps1' -OutFile C:\\install.ps1; \
    C:\\install.ps1; \
    Remove-Item -Force C:\\install.ps1

# Enable global confirmation
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    choco feature enable -n=allowGlobalConfirmation

# Install visual studio
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    C:\\src\\install_vsbuildtools2017.ps1

# Install other build tools
#  - perl, svn, and nasm are needed by OpenSSL for Python
#  - MinGW64 8.1.0 posix seh.
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    choco install -y 7zip; \
    choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'; \
    choco install -y git --params '/GitOnlyOnPath /NoAutoCrlf /SChannel'; \
    choco install -y nsis; \
    choco install -y strawberryperl; \
    choco install -y tortoisesvn; \
    choco install -y nasm; \
    choco install -y mingw; \
    choco install -y doxygen.install; \
    choco install -y poedit

# Get WiX Toolset
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    C:\\src\\install_wixtoolset.ps1

# Set up environment variables.
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    C:\\src\\setup_envvars.ps1

# Cleanup
RUN powershell -NoLogo -ExecutionPolicy Bypass -Command \
    Remove-Item -Recurse -Force C:\\src
