#!/bin/bash

xhost +local:docker # For gui.

docker run \
  -it \
  --rm \
  --name gtsam \
  --net=host \
  --privileged \
  -v $(pwd):/root/gtsam-experiments \
  -w /root/gtsam-experiments \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --env=DISPLAY \
  --env=QT_X11_NO_MITSHM=1 \
  gtsam