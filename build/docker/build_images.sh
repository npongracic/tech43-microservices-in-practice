#!/usr/bin/env bash
export CURRENT_VERSION="1.0.9"
export CONTAINER_REGISTRY="localhost:5000"
export CONTAINER_IMAGE_GROUP_SERVICE="service"
export CONTAINER_IMAGE_GROUP_WEB="web"

# Build dotnet docker images (services)
ls ../../src/services | grep -v "^Dockerfile" | grep -v ".sln" |  \
while read app
do
    echo "Building docker image for: $app"
    docker build --build-arg="APP_NAME=$app" -t "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_SERVICE/$app:$CURRENT_VERSION" --file ../../src/services/Dockerfile ../../src/services/$app
    docker image tag "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_SERVICE/$app:$CURRENT_VERSION" "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_SERVICE/$app:latest"

    echo "Built docker image: $CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_SERVICE/$app:$CURRENT_VERSION"
    echo "Tagged docker image: $CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_SERVICE/$app:latest"
done

pushd ../../src/web
# Build web docker images (web apps)
npx nx run-many -t build --parallel=3
npx nx show projects --exclude *-e2e ng-* | \
while read app
do
    docker build --build-arg="APP_NAME=$app" -t "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_WEB/$app:$CURRENT_VERSION" --file ./Dockerfile .   
    echo "Built docker image: $CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_WEB/$app:$CURRENT_VERSION"

    docker image tag "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_WEB/$app:$CURRENT_VERSION" "$CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_WEB/$app:latest"
    echo "Tagged docker image: $CONTAINER_REGISTRY/$CONTAINER_IMAGE_GROUP_WEB/$app:latest"
done

popd