FROM openjdk:8-jre-stretch

COPY ENTRYPOINT.sh .

ADD https://dl.ubnt.com/firmwares/ufv/v3.10.13/unifi-video.Debian9_amd64.v3.10.13.deb unifi-video.deb

RUN apt update -q -y &&\
    apt install -q -y sudo psmisc lsb-release mongodb jsvc &&\
    dpkg -i unifi-video.deb &&\
    rm unifi-video.deb
    
VOLUME /config
EXPOSE 7080/tcp 7443/tcp 6666/tcp 7442/tcp 7445/tcp 7446/tcp 7447
WORKDIR /usr/lib/unifi-video

ENTRYPOINT /ENTRYPOINT.sh
