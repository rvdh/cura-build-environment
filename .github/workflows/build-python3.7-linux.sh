#!/bin/bash

set -e

TAG_PREFIX="python3.7-debian"

GIT_REF="$(basename "${GIT_REF}")"
TAG="${TAG_PREFIX}-${GIT_REF}"

# Only tag as the latest for master
if [ "${GIT_REF}" = "master" ]; then
  EXTRA_TAG="${TAG_PREFIX}-latest"
fi

# Build the image
docker build -t "${DOCKER_IMAGE_NAME}:${TAG}" -f docker/python3.7/linux/Dockerfile docker/python3.7/linux/
if [ -n "${EXTRA_TAG}" ]; then
  docker tag "${DOCKER_IMAGE_NAME}:${TAG}" "${DOCKER_IMAGE_NAME}:${EXTRA_TAG}"
fi

# Docker login and push image
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USER}" --password-stdin "${DOCKER_SERVER}"
docker push "${DOCKER_SERVER}/${DOCKER_IMAGE_NAME}:${TAG}"
if [ -n "${EXTRA_TAG}" ]; then
  docker push "${DOCKER_IMAGE_NAME}:${EXTRA_TAG}"
fi
docker logout
