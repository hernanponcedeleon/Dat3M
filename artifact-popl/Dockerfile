FROM genmc/genmc

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        git \
        build-essential \
        maven \
        sudo \
        wget

RUN cd /home && \
    git clone --branch artifact https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    mvn clean install -DskipTests

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output

RUN cd /home && \
    git clone --depth 1 --branch "v4.2.1" https://github.com/open-s4c/libvsync.git

ENV LIBVSYNC_HOME=/home/libvsync

RUN cd /home/libvsync && \
    git apply $DAT3M_HOME/libvsync.patch

ENV PATH="/root/genmc/RelWithDebInfo:${PATH}"