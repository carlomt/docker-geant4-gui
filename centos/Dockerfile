ARG BASE_IMAGE=centos:7

FROM $BASE_IMAGE AS builder

ENV G4_VERSION 10.07.p02

WORKDIR /workspace

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_COLLATE=C
ENV LC_CTYPE=en_US.UTF-8
ENV XDG_RUNTIME_DIR=/workspace

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

COPY packages packages

RUN yum update -q -y \
 && yum install -y epel-release 

RUN yum update -q -y \
 && yum install -y centos-release-scl centos-release-scl-rh \
 && yum install -y $(cat packages) \
 && yum clean all

#COPY qtaccount.ini /root/.local/share/Qt/qtaccount.ini

# RUN \
#   mkdir -p /workspace/qt5
# && \
#   wget --no-check-certificate --quiet -O qt.run http://download.qt.io/official_releases/qt/5.12/5.12.11/qt-opensource-linux-x64-5.12.11.run # &&\

#COPY qt-installer-noninteractive.qs /workspace/qt-installer-noninteractive.qs

#COPY qt-opensource-linux-x64-5.12.11.run /workspace/qt-opensource-linux-x64-5.12.11.run
#RUN chmod +x /workspace/qt-opensource-linux-x64-5.12.11.run

# RUN /workspace/qt-opensource-linux-x64-5.12.11.run --script /workspace/qt-installer-noninteractive.qs -platform minimal

RUN source /opt/rh/devtoolset-9/enable && \
    mkdir -p /workspace/geant4/build && \
    mkdir -p /opt/geant4/ && \
    wget --no-check-certificate --quiet -O /workspace/geant4.tar.gz http://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.${G4_VERSION}.tar.gz && \
    tar xf /workspace/geant4.tar.gz -C /workspace/geant4/ && \
    mv /workspace/geant4/geant4.${G4_VERSION}/ /workspace/geant4/src/  && \
    cd /workspace/geant4/build && \    
    cmake3 -G Ninja -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
    -DGEANT4_INSTALL_DATA=OFF \
    -DGEANT4_INSTALL_DATADIR=/opt/geant4/data \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_USE_GDML=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_INSTALL_EXAMPLES=OFF \
    -DQt53DCore_DIR=/usr/lib64/cmake/Qt53DCore \
    -DQt53DExtras_DIR=/usr/lib64/cmake/Qt53DExtras \
    -DQt53DRender_DIR=/usr/lib64/cmake/Qt53DRender \
    ../src/ && \
     ninja install

RUN source /opt/rh/devtoolset-9/enable && \ 
    cd /workspace && \
    git clone https://github.com/DCMTK/dcmtk.git && \
    cd dcmtk/ && \
    git checkout tags/DCMTK-3.6.6 && \
    mkdir build && \
    cd build && \
    cmake3 -G Ninja -DCMAKE_INSTALL_PREFIX=/opt/dcmtk \
    -DDCMTK_ENABLE_CXX11=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    ../ && \
    ninja install

#######################################################################

FROM $BASE_IMAGE

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_COLLATE=C
ENV LC_CTYPE=en_US.UTF-8
ENV XDG_RUNTIME_DIR=/run/user/1000

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

COPY packages packages

RUN yum update -q -y \
 && yum install -y epel-release 

RUN yum update -q -y \
 && yum install -y centos-release-scl centos-release-scl-rh \
 && yum install -y $(cat packages)

RUN yum install -y openssl mesa-dri-drivers \
 && yum clean all

COPY --from=builder /opt/geant4/ /opt/geant4/
COPY --from=builder /workspace/geant4/src/examples/ /opt/geant4/examples/
COPY --from=builder /opt/dcmtk/ /opt/dcmtk/

RUN mkdir -p /opt/geant4/data && chmod 777 /opt/geant4/data
# RUN chmod 777 /workspace/geant4/build

COPY gMocren4-centos7.4-64bit-20190731.tgz /workspace/gMocren.tgz
RUN tar xzf /workspace/gMocren.tgz -C /workspace/ && \
    mkdir -p /opt/gmocren/bin && \
    cp /workspace/gMocren4/gMocren4 /opt/gmocren/bin/gMocren4 && \
    rm -rf /workspace/gMocren4/ && rm -f /workspace/gMocren.tgz

ENV DISPLAY :0

COPY bash.bashrc /etc/profile.d/custom.sh
RUN chmod +x /etc/profile.d/custom.sh

RUN echo "source /etc/profile.d/custom.sh" >> /etc/profile

RUN mkdir -p /run/user/1000 && \
    chmod 0700 /run/user/1000

ENV QT_X11_NO_MITSHM=1
ENV LIBGL_DEBUG=verbose

# RUN \
#   mkdir -p /workspace/qt5
# && \
#   wget --no-check-certificate --quiet -O qt.run http://download.qt.io/official_releases/qt/5.12/5.12.11/qt-opensource-linux-x64-5.12.11.run # &&\

#COPY qt-installer-noninteractive.qs /workspace/qt-installer-noninteractive.qs

COPY qt-opensource-linux-x64-5.12.11.run /workspace/qt-opensource-linux-x64-5.12.11.run
#RUN chmod +x /workspace/qt-opensource-linux-x64-5.12.11.run

# RUN /workspace/qt-opensource-linux-x64-5.12.11.run --script /workspace/qt-installer-noninteractive.qs -platform minimal

CMD  [ "/usr/bin/bash", "--login"]