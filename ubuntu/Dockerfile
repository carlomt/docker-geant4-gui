ARG BASE_IMAGE=ubuntu:focal

FROM $BASE_IMAGE AS builder

ENV G4_VERSION 10.07.p02

WORKDIR /workspace

ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -yq --no-install-recommends install \ 
    gnupg2 \
    software-properties-common
    
COPY packages packages
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get -yq --no-install-recommends install \
    $(cat packages) && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /workspace/geant4/build && \
    mkdir -p /opt/geant4/ && \
    wget --quiet --no-check-certificate -O /workspace/geant4.tar.gz \
    http://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.${G4_VERSION}.tar.gz && \
    tar xf /workspace/geant4.tar.gz -C /workspace/geant4/ && \
    mv /workspace/geant4/geant4.${G4_VERSION}/ /workspace/geant4/src/ && \
    cd /workspace/geant4/build && \
    cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
    -DGEANT4_INSTALL_DATA=OFF \
    -DGEANT4_INSTALL_DATADIR=/opt/geant4/data \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_USE_GDML=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_INSTALL_EXAMPLES=OFF \
    ../src/ && \
     ninja install
    
#######################################################################

FROM $BASE_IMAGE

ENV LANG=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -yq --no-install-recommends install \ 
    gnupg2 \
    software-properties-common    

COPY packages packages
RUN export DEBIAN_FRONTEND=noninteractive && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    add-apt-repository ppa:git-core/ppa && \    
    apt-get update && \
    apt-get -yq --no-install-recommends install \    
    $(cat packages) \
    cmake-curses-gui \
    git \
    zip \
    unzip \
    curl \
    openssl \
    less \
    emacs-nox \
    grep \
    sed \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --branch stable https://github.com/nojhan/liquidprompt.git /opt/liquidprompt

COPY --from=builder /opt/geant4/ /opt/geant4/
COPY --from=builder /workspace/geant4/src/examples/ /opt/geant4/examples/

RUN mkdir -p /opt/geant4/data && chmod 777 /opt/geant4/data

ENV DISPLAY :0

COPY bash.bashrc /etc/profile.d/custom.sh
# RUN echo "source /etc/profile.d/custom.sh" >> /etc/profile

ENTRYPOINT  ["/usr/bin/bash", "-l"]
