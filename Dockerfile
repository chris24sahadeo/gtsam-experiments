FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]
ENV TZ=$timezone
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --allow-downgrades \
  git

WORKDIR "/root"

# GTSAM.
# Install instructions: https://github.com/borglab/gtsam
RUN git clone https://github.com/borglab/gtsam.git

# Build dependencies.
RUN apt-get update && apt-get install -y --allow-downgrades \
  libboost-all-dev \
  cmake \
  build-essential \
  apt-utils

# Build.
WORKDIR "/root/gtsam"
RUN mkdir build && \
  cd build && \
  cmake .. && \
  make -j7 install

# OpenCV with contrib.
RUN apt-get update && apt-get install -y --allow-downgrades \
  unzip \
  wget

ARG CV_VERSION=4.6.0
WORKDIR "/root/opencv"

RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${CV_VERSION}.zip && \
  wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${CV_VERSION}.zip

RUN unzip opencv.zip && \
  unzip opencv_contrib.zip

RUN apt-get update && apt-get install -y --allow-downgrades \
  libgtk2.0-dev \
  pkg-config  

RUN mkdir -p build && \
  cd build && \
  cmake \
    -DWITH_GTK=ON \
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${CV_VERSION}/modules \
    ../opencv-${CV_VERSION} && \
  cmake --build . -j7  --target install

# fmt C++ lib.
WORKDIR "/root"
RUN git clone https://github.com/fmtlib/fmt.git
WORKDIR "/root/fmt"
RUN cmake -S . -B build && \
  cmake --build build -j7 --target install