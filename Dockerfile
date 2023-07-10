#Download base image ubuntu 20.04
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y git && \
    apt-get install -y graphviz && \
    apt-get install -y sudo && \
    apt-get install -y wget && \
    apt-get install -y maven && \
    apt-get install -y cmake && \
    apt-get install -y autoconf && \
    apt-get install -y automake && \
    apt-get install -y graphviz && \
    apt-get install -y curl    

# Install SMACK
RUN cd home && \
    git clone https://github.com/smackers/smack.git && \
    cd smack && \
    env TEST_SMACK=0 INSTALL_Z3=0 INSTALL_CORRAL=0 bin/build.sh

# Install Dat3M
RUN cd home && \
    git clone --branch pldi https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    chmod 755 Dartagnan-SVCOMP.sh && \
    mvn clean install -DskipTests

# Build atomic-replace library
RUN cd home/Dat3M/llvm-passes/atomic-replace/ \
    && mkdir build && cd build                \
    && cmake ..                               \
    && make all install

# symlink for clang
RUN ln -s clang-12 /usr/bin/clang

# Clone CNA-verification repo
RUN cd home && \
    git clone https://github.com/huawei-drc/cna-verification.git && \
    cd /home/cna-verification && \
    make prepared

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output
ENV CFLAGS="-I$DAT3M_HOME/include"
ENV SMACK_FLAGS="-q -t --no-memory-splitting"
ENV ATOMIC_REPLACE_OPTS="-mem2reg -sroa -early-cse -indvars -loop-unroll -simplifycfg -gvn"
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CNA_VERIFICATION_HOME=/home/cna-verification
