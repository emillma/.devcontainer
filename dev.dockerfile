# docker build -t devcontainer:latest -f .\.devcontainer\Dockerfile .
FROM ubuntu:jammy-20221003
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y

# basic tools
RUN apt install -y \
    apt-utils wget curl git sudo net-tools iputils-ping nmap file usbutils minicom cmake

# miktex (https://hub.docker.com/r/miktex/miktex/tags)
RUN apt install -y locales && locale-gen ru_RU.UTF-8 && update-locale 
RUN apt install -y apt-transport-https  ca-certificates  dirmngr  ghostscript  gnupg  gosu  make  perl
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889
RUN apt install -y lsb-release
RUN echo "deb http://miktex.org/download/ubuntu $(lsb_release -c --short) universe" | tee /etc/apt/sources.list.d/miktex.list
RUN apt update && apt install -y miktex 
RUN miktexsetup finish \
    && initexmf --admin --set-config-value=[MPM]AutoInstall=1  \
    && mpm --admin --update-db  \
    && mpm --admin --install amsfonts --install biber-linux-x86_64 \
    && initexmf --admin --update-fndb

## for latex indent
RUN PERL_MM_USE_DEFAULT=1 cpan YAML::Tiny File::HomeDir
RUN apt install fonts-firacode

# to fix annoying pip xserver bug (https://github.com/pypa/pip/issues/8485)
RUN printf "%s\n" 'alias pip3="DISPLAY= pip3"' "alias python=python3" > ~/.bash_aliases

# pico stuff
RUN apt install -y gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib iputils-ping
RUN apt install -y automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev  pkg-config minicom
RUN cd ~ && git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --depth=1 --no-single-branch
RUN cd ~/openocd && ./bootstrap && ./configure --enable-picoprobe && make -j4
RUN apt install -y gdb-multiarch

# install python stuff
ARG python=python3.10
RUN apt install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update && apt install -y ${python} ${python}-distutils python3-pip 

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/${python} 1 \
    && update-alternatives --config python3


# to fix annoying pip xserver bug (https://github.com/pypa/pip/issues/8485)
RUN printf "%s\n" "alias pip3='DISPLAY= pip3'" "alias python=python3" > ~/.bash_aliases

# install packages
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | ${python}
RUN pip3 install \
    numpy scipy matplotlib pyqt5 pandas sympy\
    pylint autopep8 jupyter \
    pytest 

RUN pip3 install plotly dash dash_bootstrap_components
RUN pip3 install numba torch torchvision
RUN pip3 install opencv-python opencv-contrib-python

RUN pip3 install \
    pyserial \
    networkx \
    libcst \
    tqdm



# for grammarly in vscode
# RUN curl -s https://deb.nodesource.com/setup_18.x | sudo bash
# RUN sudo apt install nodejs && npm install -g typescript pnpm sandboxed-module  

