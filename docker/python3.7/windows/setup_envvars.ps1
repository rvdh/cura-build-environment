# Set up environment variables for the cura-build-environment docker image.
$ErrorActionPreference = "Stop"

# Set Cura build environment variables.
[Environment]::SetEnvironmentVariable("CURA_BUILD_ENV_BUILD_TYPE", "$env:CURA_BUILD_ENV_BUILD_TYPE", [System.EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("CURA_BUILD_ENV_PATH", "$env:CURA_BUILD_ENV_PATH", [System.EnvironmentVariableTarget]::Machine)
