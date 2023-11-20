FROM alpine:3.17

RUN apk add --no-cache \
  git \
  py3-pip 

RUN python3 -m pip install -U bloom catkin_pkg

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]