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

## for latex indent
# RUN PERL_MM_USE_DEFAULT=1 cpan YAML::Tiny File::HomeDir

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
RUN pip install --upgrade pip setuptools

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1 \
    && update-alternatives --config python3

# to fix annoying pip xserver bug (https://github.com/pypa/pip/issues/8485)
RUN printf "%s\n" "alias pip=pip3" "alias pip3='DISPLAY= pip3'" "alias python=python3" > ~/.bash_aliases

# general python stuff
RUN pip install black mypy pylint autopep8 jupyter pytest

# mkl enabled numpy and scipy
RUN pip install -i https://pypi.anaconda.org/intel/simple --extra-index-url https://pypi.org/simple numpy==1.21.4 scipy==1.7.3
RUN pip install pylint black ipykernel

# for symforce
RUN apt install -y libgmp-dev clang-format
RUN pip install jinja2
RUN pip install sympy
RUN pip install install skymarshal Cython argh
RUN pip install matplotlib

RUN mkdir /include && cd /include \
    && git clone https://github.com/pybind/pybind11.git \
    && git clone https://gitlab.com/libeigen/eigen.git \
    && git clone https://github.com/raspberrypi/pico-sdk.git --recurse-submodules

RUN pip install "dash>=2.5" dash-bootstrap-components requests pandas plotly
RUN apt update && apt -y install nodejs npm
RUN npm install -g plotly.js-dist @types/plotly.js-dist-min eslint
RUN pip install "python-socketio[client]" "python-socketio[asyncio_client]"

# RUN pip install meson
# RUN pip install -i https://pypi.anaconda.org/intel/simple numpy

# RUN pip install \
#     scipy matplotlib pyqt5 pandas sympy\
#     pylint autopep8 jupyter \
#     pytest



# ARG envname=dev
# RUN mkdir -p ~/miniconda3 && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
# RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
# RUN rm -rf ~/miniconda3/miniconda.sh
# RUN ~/miniconda3/bin/conda init bash && ~/miniconda3/bin/conda init zsh

# RUN ~/miniconda3/bin/conda create -y -n ${envname} -c conda-forge python=3.10
# RUN ~/miniconda3/bin/conda install -y -n ${envname} pylint black ipykernel

# RUN ~/miniconda3/bin/conda install -y -n ${envname} numpy scipy pandas
# RUN ~/miniconda3/bin/conda install -y -n ${envname} numba pybind11

# RUN ~/miniconda3/bin/conda install -y -n ${envname} sympy sphinx jinja2

# # RUN ~/miniconda3/bin/conda install -y -n ${envname} -c "nvidia/label/cuda-11.8.0" cuda-toolkit
# RUN ~/miniconda3/bin/conda install -y -n ${envname} pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch-nightly -c nvidia


# RUN ~/miniconda3/bin/conda install -y -n ${envname} matplotlib
# RUN ~/miniconda3/bin/conda install -y -n ${envname} -c conda-forge "dash>=2.5" dash-bootstrap-components


# RUN apt install -y libgmp-dev
# RUN ~/miniconda3/bin/conda install -y -n ${envname} -c anaconda cython
# RUN ~/miniconda3/bin/conda install -y -n ${envname} -c conda-forge argh
# RUN ~/miniconda3/envs/${envname}/bin/pip install skymarshal
# # RUN git
# RUN ~/miniconda3/bin/conda activate dev && pip install symforce


# RUN ~/miniconda3/bin/conda install -y -n dev pytest tqdm pyserial
# RUN ~/miniconda3/bin/conda install -y -n dev plotly dash dash_bootstrap_components

# RUN ~/miniconda3/bin/conda install -y -n dev torch torchvision torchaudio
# RUN ~/miniconda3/bin/conda install -y -n dev opencv-python opencv-contrib-python

# RUN ~/miniconda3/bin/conda install -y -n dev pyarmor==6.8.1





