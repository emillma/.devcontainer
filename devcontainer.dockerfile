FROM nvidia/cuda:12.2.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root
RUN apt clean && apt update
RUN apt install -y  build-essential cmake git

# pico
RUN apt install -y gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib

# Latex (from https://github.com/blang/latex-docker/blob/master/Dockerfile.ubuntu)
RUN apt install -y locales && locale-gen en_US.UTF-8 && update-locale
RUN apt update && apt install -y git build-essential wget libfontconfig1
RUN apt update && apt install -y \
    texlive-full \
    python3-pygments gnuplot
RUN apt install fonts-firacode

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
RUN pip install black mypy ipykernel jupyter
RUN pip install numpy scipy
RUN pip install websockets sympy symforce
RUN pip install torch torchvision torchaudio
RUN pip install plotly

# js
RUN apt install wget
RUN apt install -y nodejs npm
RUN npm install -g n && n stable

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

