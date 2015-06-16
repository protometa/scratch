FROM ubuntu:14.04

RUN apt-get update

# install 
RUN wget --no-check-certificate https://download.01.org/gfx/RPM-GPG-KEY-ilg -O - | sudo apt-key add -

CMD glxgears

# run with `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix`