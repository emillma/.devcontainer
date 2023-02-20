
# docker build -t devcontainer:latest -f .\.devcontainer\Dockerfile .
FROM nvcr.io/nvidia/l4t-base:r32.6.1
ENV DEBIAN_FRONTEND noninteractive

# install basic stuff
RUN apt update && apt -y upgrade \
    && apt install -y apt-utils curl git cmake sl sudo net-tools nmap build-essential

# remember to install file
RUN apt install file
RUN mkdir /home/arena
COPY files/ArenaSDK_v0.1.49_Linux_ARM64.tar.gz /home/arena/ArenaSDK_Linux.tar.gz
RUN cd /home/arena \
    && tar -xvzf ArenaSDK_Linux.tar.gz \
    && cd ArenaSDK_Linux_ARM64 && sh Arena_SDK_ARM64.conf

# install python stuff
ARG python=python3.11
RUN apt install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y ${python} ${python}-dev ${python}-distutils

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1 \
    && update-alternatives --config python3

# install pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | ${python}

RUN pip install --upgrade pip wheel setuptools

RUN pip install black mypy pylint autopep8 jupyter pytest
RUN pip install numpy 
RUN pip install opencv-contrib-python

RUN pip install ifcfg 
RUN apt install ethtool ptpd

RUN pip install spidev Jetson.GPIO pyubx2

COPY files/arena_api-2.3.3-py3-none-any.whl /home/arena/arena_api-2.3.3-py3-none-any.whl
RUN pip3 install ./home/arena/arena_api-2.3.3-py3-none-any.whl


