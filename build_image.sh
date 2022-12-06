#!/bin/bash

docker build -t gtsam:latest --build-arg timezone=$(cat /etc/timezone) .
