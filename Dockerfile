FROM debian:wheezy
RUN apt-get update && \
    apt-get install -y git g++ uuid-dev make wget libtool openjdk-6-jdk pkg-config autoconf automake unzip dpkg-dev fakeroot debhelper
WORKDIR /app
