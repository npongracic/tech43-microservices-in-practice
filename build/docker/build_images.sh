#!/usr/bin/env bash
export CURRENT_VERSION="1.0.0"
export CONTAINER_REGISTRY="localhost:5000"
export CONTAINER_IMAGE_GROUP="apps"

# Build dotnet docker images (services)
ls ../../src/services | grep -v "^Dockerfile" | grep -v ".sln" |  \
while read app
do
    echo "Building docker image for: $app"
    docker build --build-arg="APP_NAME=$app" -t "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP/$app:$CURRENT_VERSION" --file ../../src/services/Dockerfile ../../src/services/$app
    docker image tag "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP/$app:$CURRENT_VERSION" "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP/$app:latest"
done

# Build web docker images (web apps)