# docker build -t devcontainer:latest -f .\.devcontainer\Dockerfile .
# FROM ubuntu:jammy-20221003

FROM nvidia/cuda:11.7.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y

# basic tools
RUN apt install -y \
    apt-utils wget curl git sudo net-tools iputils-ping nmap file usbutils minicom cmake

# Latex (from https://github.com/blang/latex-docker/blob/master/Dockerfile.ubuntu)
RUN apt install -y locales && locale-gen en_US.UTF-8 && update-locale
RUN apt update && apt install -qy git build-essential wget libfontconfig1
RUN apt update -q && apt install -qy \
    texlive-full \
    python3-pygments gnuplot
RUN apt install fonts-firacode

# pico stuff
RUN apt install -y gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib iputils-ping

RUN apt install -y automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev  pkg-config minicom
RUN cd ~ && git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --depth=1 --no-single-branch
RUN cd ~/openocd && ./bootstrap && ./configure --enable-picoprobe && make -j4
RUN apt install -y gdb-multiarch

# install python stuff
ARG python=python3.10
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update && apt install -y ${python} ${python}-distutils ${python}-dev python3-pip

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1 \
    && update-alternatives --config python3

# to fix annoying pip xserver bug (https://github.com/pypa/pip/issues/8485)
RUN printf "%s\n" "alias pip=pip3" "alias pip3='DISPLAY= pip3'" "alias python=python3" > ~/.bash_aliases

# general python stuff
RUN pip install black mypy pylint autopep8 jupyter pytest

# mkl enabled numpy and scipy
RUN pip install -i https://pypi.anaconda.org/intel/simple --extra-index-url https://pypi.org/simple numpy==1.21.4 scipy==1.7.3

# for symforce
RUN apt install -y libgmp-dev clang-format
RUN pip install jinja2 
RUN pip install sympy
RUN pip install install skymarshal Cython argh
RUN pip install matplotlib
RUN mkdir /include -p && cd /include && git clone https://github.com/pybind/pybind11.git && git clone https://gitlab.com/libeigen/eigen.git

# for gpgui
RUN mkdir /workspaces -p && cd /workspaces \
    && git clone -b flask-request-patch https://github.com/vlabakje/async-dash.git \
    && cd async-dash && pip install -e .
RUN pip install dash dash-bootstrap-components dash-mantine-components plotly dash-extensions requests pandas 'quart>=0.18' websockets




