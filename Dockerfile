FROM ghcr.io/alpine-ros/alpine-ros:melodic-ros-core

RUN apk add --no-cache \
  git \
  ros-melodic-catkin

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]