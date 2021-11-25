#!/bin/bash

CONTAINER_NAME=hamilton-container-melodic-virtual

IMAGE_NAME=idk
IMAGE_TAG=melodic

# HOST_DIR=/home/rvl/Workspace/ARIAC/uta_rvl_competition

# CONTAINER_DIR=/root/ariac_ws/src/uta_rvl_competition

CONTAINER_ID=`docker ps -aqf "name=^/${CONTAINER_NAME}$"`

if [ -z "${CONTAINER_ID}" ]; then
    echo "Creating new ROS docker container."
    xhost +local:root
    docker run -it --privileged \
    --gpus all \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --runtime=nvidia \
    --name=${CONTAINER_NAME} \
    ${IMAGE_NAME}:${IMAGE_TAG} \
    bash
else
    echo "Found ROS docker container: ${CONTAINER_ID}."
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
