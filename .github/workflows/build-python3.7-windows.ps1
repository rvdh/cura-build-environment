$ErrorActionPreference = "Stop"

$imageBase = "$env:DOCKER_SERVER" + "/" + "$env:DOCKER_IMAGE_NAME"

$tagPrefix = "python3.7-win1809"

$gitRef = Split-Path -Path $env:GIT_REF -Leaf
$tag = "${tagPrefix}-${gitRef}"
$extraTag = ""
$imageTag2 = ""
if ($gitRef -eq "master") {
  $extraTag = "${tagPrefix}-latest"
  $imageTag2 = "$imageBase" + ":" + "$extraTag"
}

$imageTag1 = "$imageBase" + ":" + "$tag"
docker build -t "$imageTag1" -f docker\python3.7\windows\Dockerfile docker\python3.7\windows\
if ($extraTag) {
  docker tag "$imageTag1" "$extraTag"
}

$ErrorActionPreference = "Continue"
docker login -u "$env:DOCKER_USER" -p "$env:DOCKER_PASSWORD" "$env:DOCKER_SERVER"
docker push "$imageTag1"
if ($imageTag2) {
  docker push "$imageTag2"
}
docker logout
