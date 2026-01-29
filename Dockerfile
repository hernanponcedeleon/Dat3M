# Download base ubuntu image
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GRAALVM_VERSION=21
ARG JAVA_VERSION=17

# Install system dependencies
RUN apt-get update && apt-get install -y \
        git \
        build-essential \
        clang \
        maven \
        sudo \
        wget \
        graphviz \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Install GraalVM
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JAVA_VERSION}.${GRAALVM_VERSION}/graalvm-community-jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz \
    | tar -xz -C /opt

ENV GRAALVM_HOME=/opt/graalvm-community-openjdk-${JAVA_VERSION}.${GRAALVM_VERSION}
ENV JAVA_HOME=$GRAALVM_HOME
ENV PATH=$GRAALVM_HOME/bin:$PATH

# Install native-image
RUN gu install native-image

# Install Dat3M
WORKDIR /home
RUN git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    mvn clean -Pnative install -DskipTests

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output
ENV PATH=$DAT3M_HOME/dartagnan/target/:$PATH
ENV LD_LIBRARY_PATH=$DAT3M_HOME/dartagnan/target/libs/:$LD_LIBRARY_PATH
