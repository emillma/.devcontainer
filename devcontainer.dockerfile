
# docker build -t devcontainer:latest -f .\.devcontainer\Dockerfile .
FROM nvcr.io/nvidia/l4t-jetpack:r36.2.0
ENV DEBIAN_FRONTEND noninteractive
ENV PIP_ROOT_USER_ACTION=ignore

RUN apt update 
RUN apt install -y git

WORKDIR /root/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
RUN bash /root/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf /root/miniconda3/miniconda.sh
RUN /root/miniconda3/bin/conda init bash
RUN /root/miniconda3/bin/conda init zsh
ENV PATH /root/miniconda3/bin:$PATH

WORKDIR /root/arena
RUN apt install -y file build-essential
COPY files/ArenaSDK_v0.1.49_Linux_ARM64.tar.gz ArenaSDK_Linux_ARM64.tar.gz
COPY files/arena_api-2.3.3-py3-none-any.zip arena_api.zip
RUN tar -xzf ArenaSDK_Linux_ARM64.tar.gz 
RUN cd ArenaSDK_Linux_ARM64 && sh Arena_SDK_ARM64.conf
RUN apt install -y unzip && unzip -a arena_api.zip -d arena_api
RUN pip install --no-deps arena_api/arena_api-2.3.3-py3-none-any.whl

# js
RUN apt install -y nodejs npm
RUN npm install -g n && n stable

RUN apt install -y net-tools ethtool ptpd usbutils screen
RUN pip install --no-deps jetson-stats ifcfg

RUN conda install numpy
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN conda install -y websockets jinja2 aiofiles pyserial
# gitconfig
RUN git config --global core.fileMode false
RUN git config --global core.autocrlf true
RUN git config --global user.email "emil.martens@gmail.com"
RUN git config --global user.name "Emil Martens"

# # deepstream 
# RUN apt install -y \
#     librdkafka-dev \
#     libssl1.1 \
#     libgstreamer1.0-0 \
#     gstreamer1.0-tools \
#     gstreamer1.0-plugins-good \
#     gstreamer1.0-plugins-bad \
#     gstreamer1.0-plugins-ugly \
#     gstreamer1.0-libav \
#     libgstreamer-plugins-base1.0-dev \
#     libgstrtspserver-1.0-0 \
#     libjansson4 \
#     libyaml-cpp-dev

# COPY files/deepstream-6.2_6.2.0-1_arm64.deb /home/deepstream.deb
# RUN dpkg -i /home/deepstream.deb


# # cmake
# RUN apt remove cmake -y
# RUN pip install cmake --upgrade
# # for pybind11
# RUN mkdir /include && cd /include \
#     && git clone https://github.com/pybind/pybind11.git \
#     && git clone https://gitlab.com/libeigen/eigen.git 

# RUN apt install -y pkg-config libcairo2-dev gir1.2-gst-rtsp-server-1.0
# RUN pip install pycairo
# RUN apt install -y libgirepository1.0-dev
# RUN pip install --ignore-installed PyGObject
# RUN pip install pygobject-stubs

# RUN pip install cupy-cuda11x -f https://pip.cupy.dev/aarch64


# # RUN ln -s /usr/local/cuda/lib64/libcudart.so.10.2 /usr/lib/libcudart.so
# # RUN pip install cmake --upgrade
# # RUN apt install -y gstreamer1.0-rtsp
# # RUN apt install ethtool

# RUN pip install numpy scipy numba 
# RUN pip install opencv-contrib-python

# RUN apt install ethtool ptpd
# RUN pip install ifcfg 

# RUN pip install spidev Jetson.GPIO pyubx2

# # RUN apt install -y nsight-systems

# # server stuff
# RUN cd /tmp \
#     && git clone -b flask-request-patch https://github.com/vlabakje/async-dash.git \
#     && cd async-dash && pip install . \
#     && cd /tmp && rm -rf async-dash

# RUN pip install "dash>=2.5" "quart>=0.18.3" 
# RUN pip install dash-bootstrap-components dash_mantine_components dash-player
# RUN SETUPTOOLS_USE_DISTUTILS=stdlib pip install dash-extensions
# RUN pip install requests pandas plotly websockets jinja2 aiohttp aiofiles pillow dash-iconify
# RUN pip install jetson-stats
