#!/bin/bash

CONTAINER_NAME=capstone-idk

IMAGE_NAME=capstoneidk/senior-design-demo
IMAGE_TAG=latest

CONTAINER_ID=`docker ps -aqf "name=^/${CONTAINER_NAME}$"`

if [ -z "${CONTAINER_ID}" ]; then
    echo "Creating new IDK docker container."
    xhost +local:root
    docker run -it \
    --network host \
    --privileged \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${CONTAINER_NAME} \
    ${IMAGE_NAME}:${IMAGE_TAG} \
    bash

else
    echo "Found IDK docker container: ${CONTAINER_ID}."
    xhost +local:${CONTAINER_ID}
    # Check if the container is already running and start if necessary.
    if [ -z `docker ps -qf "name=^/${CONTAINER_NAME}$"` ]; then
        echo "Starting and attaching to ${CONTAINER_NAME} container..."
        docker start ${CONTAINER_ID}
        docker attach ${CONTAINER_ID}
    else
        echo "Found running ${CONTAINER_NAME} container, attaching bash..."
        docker exec -it --env="DISPLAY=$DISPLAY" ${CONTAINER_ID} bash
    fi
fi