$ErrorActionPreference = "Stop"

# visualcpp-build-tools seems to be installed on the background, so we have a while loop after 'choco install'
# to wait for the installation to finish.

choco install visualcpp-build-tools --execution-timeout 18000 `
  --package-parameters "'/IncludeRequired /IncludeRecommended /IncludeOptional'"

while ($true) {
  Start-Sleep -Seconds 10
  Write-Output "Check if VS 2017 installation has finished."

  $allProcesses = Get-Process
  $vsInstallFinished = $true
  foreach ($process in $allProcesses) {
    if ($process.ProcessName -match "^vs_installer.*") {
      $vsInstallFinished = $false
      break
    }
  }
  if ($vsInstallFinished) {
    break
  }
}

Write-Output "VS 2017 installation has finished. Wait for 30 seconds and then continue."
Start-Sleep -Seconds 30
exit
