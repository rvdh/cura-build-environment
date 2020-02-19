$ErrorActionPreference = "Stop"

$gitRef = Split-Path -Path $env:GIT_REF -Leaf
$tag = "win1809-$gitRef"
$imageBase = "$env:DOCKER_SERVER" + "/" + "$env:DOCKER_IMAGE_NAME"

$extraTag = ""
$imageTag2 = ""
if ($gitRef -eq "master") {
  $extraTag = "$env:DOCKER_IMAGE_LATEST_TAG"
  $imageTag2 = "$imageBase" + ":" + "$extraTag"
}

$imageTag1 = "$imageBase" + ":" + "$tag"
docker build -t "$imageTag1" -f docker/python3.5/windows/Dockerfile .
if ($imageTag2) {
  docker tag "$imageTag1" "$imageTag2"
}

$ErrorActionPreference = "Continue"
docker login -u "$env:DOCKER_USER" -p "$env:DOCKER_PASSWORD" "$env:DOCKER_SERVER"
docker push "$imageTag1"
if ($imageTag2) {
  docker push "$imageTag2"
}
docker logout
