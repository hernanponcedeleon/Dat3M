#Download base image ubuntu 21.04
FROM ubuntu:21.04

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt -y update && \
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
    apt-get install -y graphviz && \
    apt-get install -y autoconf && \
    apt-get install -y automake && \
    apt-get install -y clang && \
    apt-get install -y libclang-dev && \
    apt-get install -y llvm && \
    apt-get install -y llvm-dev && \
    apt-get install -y libffi-dev && \
    apt-get install -y zlib1g-dev && \
    apt-get install -y libc6 && \
    apt-get install -y libc6-dev && \
    apt-get install -y libstdc++6 && \
    apt-get install -y python3 && \
    apt-get install -y opam && \
    apt-get install -y libboost-test-dev && \
    apt-get install -y libboost-system-dev && \
    apt-get install -y pkg-config && \
    apt-get install -y python3-pip && \
    apt-get install -y libedit-dev

# Install dependencies for plot
RUN pip3 install matplotlib pandas

# Install Dat3M
RUN cd home && \
    git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    git checkout 4e7e8d3 && \
    mvn clean install -DskipTests

# Install GenMC
RUN cd home && \
    git clone https://github.com/MPI-SWS/genmc.git && \
    cd genmc && \
    autoreconf --install && \
    ./configure && \
    make && \
    make install

# Install Nidhugg
RUN cd home && \
    git clone https://github.com/nidhugg/nidhugg.git && \
    cd nidhugg && \
    autoreconf --install && \
    ./configure && \
    make && \
    make install

# Install Herd
RUN opam init --disable-sandboxing && \
    eval $(opam env) && \
    opam install -y herdtools7 && \
    cp ~/.opam/default/bin/herd7 /usr/local/bin/ 

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output