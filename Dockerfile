# Download base ubuntu image
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y \
        git \
        build-essential \
        clang \
        maven \
        sudo \
        wget \
        graphviz \
        openjdk-17-jdk \
        openjdk-17-jre

# Install Dat3M
RUN cd home && \
    git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    mvn clean install -DskipTests

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output