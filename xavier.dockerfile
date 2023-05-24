
# docker build -t devcontainer:latest -f .\.devcontainer\Dockerfile .
FROM nvcr.io/nvidia/l4t-jetpack:r35.3.1
ENV DEBIAN_FRONTEND noninteractive

# install basic stuff
RUN apt update 
RUN apt upgrade -y
RUN apt install -y apt-utils curl git cmake sl sudo net-tools nmap build-essential


# remember to install file
RUN apt install -y file
RUN mkdir /home/arena
COPY files/ArenaSDK_v0.1.49_Linux_ARM64.tar.gz /home/arena/ArenaSDK_Linux.tar.gz
RUN cd /home/arena \
    && tar -xvzf ArenaSDK_Linux.tar.gz \
    && cd ArenaSDK_Linux_ARM64 && sh Arena_SDK_ARM64.conf


# install python stuff
ARG python=python3.11
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y ${python} ${python}-dev ${python}-distutils

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1 \
    && update-alternatives --config python3

# install pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | ${python}

RUN printf "%s\n" "alias pip=pip3" "alias python=python3" > ~/.bash_aliases

RUN pip install --upgrade pip wheel setuptools
RUN pip install black mypy pylint autopep8 jupyter pytest

COPY files/arena_api-2.3.3-py3-none-any.whl /home/arena/arena_api-2.3.3-py3-none-any.whl
RUN pip3 install /home/arena/arena_api-2.3.3-py3-none-any.whl

# deepstream 
RUN apt install -y \
    librdkafka-dev \
    libssl1.1 \
    libgstreamer1.0-0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstreamer-plugins-base1.0-dev \
    libgstrtspserver-1.0-0 \
    libjansson4 \
    libyaml-cpp-dev

COPY files/deepstream-6.2_6.2.0-1_arm64.deb /home/deepstream.deb
RUN dpkg -i /home/deepstream.deb


# cmake
RUN apt remove cmake -y
RUN pip install cmake --upgrade
# for pybind11
RUN mkdir /include && cd /include \
    && git clone https://github.com/pybind/pybind11.git \
    && git clone https://gitlab.com/libeigen/eigen.git 

RUN apt install -y pkg-config libcairo2-dev gir1.2-gst-rtsp-server-1.0
RUN pip install pycairo
RUN apt install -y libgirepository1.0-dev
RUN pip install --ignore-installed PyGObject
RUN pip install pygobject-stubs

RUN pip install cupy-cuda11x -f https://pip.cupy.dev/aarch64


# RUN ln -s /usr/local/cuda/lib64/libcudart.so.10.2 /usr/lib/libcudart.so
# RUN pip install cmake --upgrade
# RUN apt install -y gstreamer1.0-rtsp
# RUN apt install ethtool

RUN pip install numpy scipy numba 
RUN pip install opencv-contrib-python

RUN apt install ethtool ptpd
RUN pip install ifcfg 

RUN pip install spidev Jetson.GPIO pyubx2
RUN pip install websockets

RUN apt install nsight-systems