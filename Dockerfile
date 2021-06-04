ARG BASE_IMAGE=ubuntu:focal

FROM $BASE_IMAGE AS builder

ENV G4_VERSION 10.07.p01

WORKDIR /workspace

ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
ENV DEBIAN_FRONTEND=noninteractive

COPY packages packages

RUN apt-get update && \
apt-get -yq --no-install-recommends install \
cmake \
wget \
g++ \
make \
ninja-build \
pkg-config \
libxerces-c-dev \
libexpat1-dev \
$(cat packages) \
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /workspace/geant4/src && \
    mkdir -p /workspace/geant4/build && \
    mkdir -p /opt/geant4/ && \
    wget --no-check-certificate -O /workspace/geant4.tar.gz http://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.${G4_VERSION}.tar.gz && \
    tar xf /workspace/geant4.tar.gz -C /workspace/geant4/src && \
    cd /workspace/geant4/build && \
    cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
    -DGEANT4_INSTALL_DATA=OFF \
    -DGEANT4_INSTALL_DATADIR=/opt/geant4/data \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_USE_GDML=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_INSTALL_EXAMPLES=OFF \
    ../src/geant4.${G4_VERSION} && \
     ninja install

#######################################################################

FROM $BASE_IMAGE

ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
apt-get -yq --no-install-recommends install \
cmake \
wget \
g++ \
make \
ninja-build \
pkg-config \
libxerces-c-dev \
libexpat1-dev \
$(cat packages) \
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
apt-get -yq --no-install-recommends install \
git \
zip \
unzip \
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* \
&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/geant4/ /opt/geant4/
#COPY --from=builder /workspace/geant4/src/geant4.${G4_VERSION}/examples/ /examples/
#COPY entry-point.sh /opt/entry-point.sh

ENV DISPLAY :0

#ENTRYPOINT ["/opt/entry-point.sh"]
CMD ["/bin/bash"]
