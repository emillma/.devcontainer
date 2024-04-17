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

# js
RUN apt install wget
RUN apt update && apt install -y nodejs npm
RUN npm install -g n && n stable

# python
ARG python=python3.10
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update && apt install -y ${python} ${python}-distutils ${python}-dev python3-pip
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1
RUN update-alternatives --config python3
RUN printf "%s\n" "alias pip=pip3" "alias pip3='DISPLAY= pip3'" "alias python=python3" > ~/.bash_aliases
RUN pip install --upgrade pip setuptools

WORKDIR /root/arena
RUN apt install -y file build-essential sudo
COPY files/ArenaSDK_v0.1.49_Linux_ARM64.tar.gz ArenaSDK_Linux_ARM64.tar.gz
COPY files/arena_api-2.3.3-py3-none-any.zip arena_api.zip
RUN tar -xzf ArenaSDK_Linux_ARM64.tar.gz 
RUN cd ArenaSDK_Linux_ARM64 && sh Arena_SDK_ARM64.conf
RUN apt install -y unzip && unzip -a arena_api.zip -d arena_api
RUN pip install --no-deps /root/arena/arena_api/arena_api-2.3.3-py3-none-any.whl

# python packages
WORKDIR /root
RUN pip install black mypy ipykernel jupyter
RUN pip install numpy scipy

RUN apt install -y libopenblas-dev libopenmpi3 libpng-dev libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
RUN pip install ninja
RUN pip install https://developer.download.nvidia.com/compute/redist/jp/v60dp/pytorch/torch-2.2.0a0+6a974be.nv23.11-cp310-cp310-linux_aarch64.whl
ENV LD_LIBRARY_PATH=/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH 

RUN git clone --branch release/0.17 https://github.com/pytorch/vision /root/vision
WORKDIR /root/vision
RUN PYTORCH_VERSION=2.2.0 BUILD_VERSION=0.17.0 FORCE_CUDA=1 python3 setup.py install


RUN apt install -y net-tools ethtool ptpd
RUN pip install aiofiles ifcfg jetson-stats
RUN pip install websockets plotly
RUN pip install pyubx2
RUN pip install pyserial

RUN pip install atomicwrites git+https://github.com/commaai/laika.git

RUN apt install -y libgmp-dev 
RUN pip install git+https://github.com/symforce-org/symforce.git
# WORKDIR /root/geni
# RUN wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.3/ImpactAcquire-ARM64_gnu-3.0.3.tgz
# RUN wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.3/install_ImpactAcquire.sh
# RUN chmod +x install_ImpactAcquire.sh 

# to do this run; cp /lib/modules/5.15.122-tegra ./files
# VOLUME files/5.15.122-tegra /lib/modules/5.15.122-tegra
# RUN --mount=type=bind,target=/lib/modules/5.15.122-tegra,source=/lib/modules/5.15.122-tegra \
# NPROC=$(nproc) sudo ./install_ImpactAcquire.sh --unattended
# RUN mkdir /root/geni/build
# RUN NPROC=$(nproc) ./install_ImpactAcquire.sh --unattended -a=gev -e=u3v,pcie,usb2,vdev --path /root/geni/build


# gitconfig
RUN git config --global core.fileMode false
RUN git config --global core.autocrlf input
RUN git config --global --add safe.directory "*"
RUN git config --global user.email "emil.martens@gmail.com"
RUN git config --global user.name "Emil Martens"

# remote display
WORKDIR /root

RUN echo "export DISPLAY=host.docker.internal:0.0" >> .bashrc
RUN echo "export LIBGL_ALWAYS_INDIRECT=1" >> .bashrc
