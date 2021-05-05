#Download base image ubuntu 20.04
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:sosy-lab/benchmarking && \
    apt-get install -y git && \
    apt-get install -y lsb-release && \
    apt-get install -y sudo && \
    apt-get install -y wget && \
    apt-get install -y gnupg && \
    apt-get install -y maven && \
    apt-get install -y curl && \
    apt-get install -y build-essential && \
    apt-get install -y libcap-dev && \
    apt-get install -y cmake && \
    apt-get install -y udev && \
    apt-get install --no-install-recommends -y benchexec

# Install SMACK
RUN cd home && \
    git clone https://github.com/smackers/smack.git && \
    cd smack && \
    sed -i 's/TEST_SMACK=1/TEST_SMACK=0/' bin/build.sh && \
    bash bin/build.sh

# Install Dat3M
RUN cd home && \
    git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    chmod 755 Dartagnan-SVCOMP.sh && \
    mvn install:install-file -Dfile=lib/z3-4.8.10.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.8.10 -Dpackaging=jar && \
    mvn clean install -DskipTests

# Clone SVCOMP benchmarks
RUN cd home && \
    git clone https://github.com/sosy-lab/sv-benchmarks.git

ENV DAT3M_HOME=/home/Dat3M
ENV PATH=$DAT3M_HOME/:$PATH
ENV LD_LIBRARY_PATH=$DAT3M_HOME/lib/:$LD_LIBRARY_PATH