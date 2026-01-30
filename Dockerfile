# Download base ubuntu image
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG JAVA_VERSION=21
ARG TARGETARCH

# Install system dependencies
RUN apt-get update && apt-get install -y \
        git \
        zlib1g-dev \
        build-essential \
        clang \
        maven \
        sudo \
        wget \
        graphviz \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Install GraalVM
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64)  GRAAL_ARCH="linux-x64" ;; \
      arm64)  GRAAL_ARCH="linux-aarch64" ;; \
      *)      echo "Unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac; \
    mkdir -p /home/graalvm-jdk-${JAVA_VERSION}; \
    curl -fsSL \
      https://download.oracle.com/graalvm/${JAVA_VERSION}/latest/graalvm-jdk-${JAVA_VERSION}_${GRAAL_ARCH}_bin.tar.gz \
    | tar -xz --strip-components=1 -C /home/graalvm-jdk-${JAVA_VERSION}

ENV GRAALVM_HOME=/home/graalvm-jdk-${JAVA_VERSION}
ENV JAVA_HOME=$GRAALVM_HOME
ENV PATH=$GRAALVM_HOME/bin:$PATH

# Install Dat3M
WORKDIR /home
RUN git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    mvn clean -Pnative install -DskipTests

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output
ENV PATH=$DAT3M_HOME/dartagnan/target/:$PATH
ENV LD_LIBRARY_PATH=$DAT3M_HOME/dartagnan/target/libs/
