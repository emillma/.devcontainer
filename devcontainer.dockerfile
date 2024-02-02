FROM nvcr.io/nvidia/l4t-jetpack:r36.2.0
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_ROOT_USER_ACTION=ignore

WORKDIR /root
RUN apt clean && apt update
RUN apt install -y apt-utils build-essential cmake git

# pico
RUN apt install -y gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib

# c++ libraries
WORKDIR /include
RUN git clone https://github.com/pybind/pybind11.git
RUN git clone https://gitlab.com/libeigen/eigen.git
RUN git clone https://github.com/raspberrypi/pico-sdk.git --recurse-submodules

# python
ARG python=python3.11
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update && apt install -y ${python} ${python}-distutils ${python}-dev python3-pip
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1
RUN update-alternatives --config python3

RUN printf "%s\n" "alias pip=pip3" "alias pip3='DISPLAY= pip3'" "alias python=python3" > ~/.bash_aliases

RUN pip install --upgrade pip setuptools

# WORKDIR /root/arena
# RUN apt install -y file build-essential sudo
# COPY files/ArenaSDK_v0.1.49_Linux_ARM64.tar.gz ArenaSDK_Linux_ARM64.tar.gz
# COPY files/arena_api-2.3.3-py3-none-any.zip arena_api.zip
# RUN tar -xzf ArenaSDK_Linux_ARM64.tar.gz 
# RUN cd ArenaSDK_Linux_ARM64 && sh Arena_SDK_ARM64.conf
# RUN apt install -y unzip && unzip -a arena_api.zip -d arena_api
# RUN pip install --no-deps /root/arena/arena_api/arena_api-2.3.3-py3-none-any.whl

WORKDIR /root/geni
RUN wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.3/ImpactAcquire-ARM64_gnu-3.0.3.tgz
RUN wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.3/install_ImpactAcquire.sh
RUN chmod +x install_ImpactAcquire.sh 
# to do this run; cp /lib/modules/5.15.122-tegra ./files
# VOLUME files/5.15.122-tegra /lib/modules/5.15.122-tegra
# RUN --mount=type=bind,target=/lib/modules/5.15.122-tegra,source=/lib/modules/5.15.122-tegra \
# NPROC=$(nproc) sudo ./install_ImpactAcquire.sh --unattended
RUN mkdir /root/geni/build
RUN NPROC=$(nproc) ./install_ImpactAcquire.sh --unattended -a=gev -e=u3v,pcie,usb2,vdev --path /root/geni/build
# js
RUN apt install wget
RUN apt install -y nodejs npm
RUN npm install -g n && n stable

RUN pip install black mypy ipykernel jupyter
RUN pip install numpy scipy
RUN pip install websockets
RUN pip install torch torchvision torchaudio
RUN pip install plotly

RUN apt install -y net-tools ethtool
RUN pip install aiofiles ifcfg jetson-stats
RUN pip install pillow
RUN pip install harvesters

# gitconfig
RUN git config --global core.fileMode false
RUN git config --global core.autocrlf true
RUN git config --global --add safe.directory "*"
RUN git config --global user.email "emil.martens@gmail.com"
RUN git config --global user.name "Emil Martens"

# remote display
WORKDIR /root

RUN echo "export DISPLAY=host.docker.internal:0.0" >> .bashrc
RUN echo "export LIBGL_ALWAYS_INDIRECT=1" >> .bashrc
