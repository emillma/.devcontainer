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
ARG envname=dev
RUN mkdir -p ~/miniconda3 && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh
RUN ~/miniconda3/bin/conda init bash && ~/miniconda3/bin/conda init zsh

RUN ~/miniconda3/bin/conda create -y -n ${envname} -c conda-forge python=3.10
RUN ~/miniconda3/bin/conda install -y -n ${envname} pylint black ipykernel

RUN ~/miniconda3/bin/conda install -y -n ${envname} numpy scipy pandas
RUN ~/miniconda3/bin/conda install -y -n ${envname} numba pybind11

RUN ~/miniconda3/bin/conda install -y -n ${envname} sympy sphinx jinja2

# RUN ~/miniconda3/bin/conda install -y -n ${envname} -c "nvidia/label/cuda-11.8.0" cuda-toolkit
RUN ~/miniconda3/bin/conda install -y -n ${envname} pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch-nightly -c nvidia


RUN ~/miniconda3/bin/conda install -y -n ${envname} matplotlib
RUN ~/miniconda3/bin/conda install -y -n ${envname} -c conda-forge "dash>=2.5" dash-bootstrap-components

RUN apt update && apt -y install nodejs npm
RUN npm install -g plotly.js-dist
RUN npm install -g @types/plotly.js-dist-min

RUN apt install -y libgmp-dev
RUN ~/miniconda3/bin/conda install -y -n ${envname} -c conda-forge gcc cyton argh

# RUN git
# RUN ~/miniconda3/bin/conda activate dev && pip install symforce


# RUN ~/miniconda3/bin/conda install -y -n dev pytest tqdm pyserial
# RUN ~/miniconda3/bin/conda install -y -n dev plotly dash dash_bootstrap_components

# RUN ~/miniconda3/bin/conda install -y -n dev torch torchvision torchaudio
# RUN ~/miniconda3/bin/conda install -y -n dev opencv-python opencv-contrib-python

# RUN ~/miniconda3/bin/conda install -y -n dev pyarmor==6.8.1




# RUN pip3 install plotly dash dash_bootstrap_components
# RUN pip3 install numba torch torchvision
# RUN pip3 install opencv-python opencv-contrib-python

# RUN pip3 install \
#     pyserial \
#     networkx \
#     libcst \
#     tqdm \
#     pyarmor==6.8.1

