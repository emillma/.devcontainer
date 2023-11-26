FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel


# NOTE:
# Building the libraries for this repository requires cuda *DURING BUILD PHASE*, therefore:
# - The default-runtime for container should be set to "nvidia" in the deamon.json file. See this: https://github.com/NVIDIA/nvidia-docker/issues/1033
# - For the above to work, the nvidia-container-runtime should be installed in your host. Tested with version 1.14.0-rc.2
# - Make sure NVIDIA's drivers are updated in the host machine. Tested with 525.125.06

ENV DEBIAN_FRONTEND=noninteractive

# Update and install tzdata separately
# RUN apt update && apt install -y tzdata

# Install necessary packages
# RUN apt install -y git && \
# apt install -y libglew-dev libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev libglfw3-dev libavdevice-dev libavcodec-dev libeigen3-dev libxxf86vm-dev libembree-dev && \
# apt clean && apt install wget && rm -rf /var/lib/apt/lists/*


# RUN apt install -y cmake pkg-config mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev libglew-dev libglfw3-dev libglm-dev libao-dev libmpg123-dev

# RUN conda env create --file environment.yml && conda init bash && exec bash && conda activate gaussian_splatting

WORKDIR /include
RUN apt clean && apt update
RUN apt install -y build-essential 
RUN apt install -y cmake 
RUN apt install -y freeglut3-dev 
RUN apt install -y git 
RUN apt install -y curl 
RUN apt install -y wget 
RUN apt install -y libao-dev 
RUN apt install -y libassimp-dev 
RUN apt install -y libavcodec-dev 
RUN apt install -y libavdevice-dev 
RUN apt install -y libboost-all-dev 
RUN apt install -y libboost-filesystem-dev 
RUN apt install -y libboost-graph-dev 
RUN apt install -y libboost-program-options-dev 
RUN apt install -y libboost-system-dev 
RUN apt install -y libceres-dev 
RUN apt install -y libcgal-dev 
RUN apt install -y libeigen3-dev 
RUN apt install -y libembree-dev 
RUN apt install -y libflann-dev 
RUN apt install -y libfreeimage-dev 
RUN apt install -y libglew-dev 
RUN apt install -y libglfw3-dev 
RUN apt install -y libglm-dev 
RUN apt install -y libglu1-mesa-dev 
RUN apt install -y libgoogle-glog-dev 
RUN apt install -y libgtest-dev 
RUN apt install -y libgtk-3-dev 
RUN apt install -y libmetis-dev 
RUN apt install -y libmpg123-dev 
RUN apt install -y libopencv-dev 
RUN apt install -y libqt5opengl5-dev 
RUN apt install -y libsqlite3-dev 
RUN apt install -y libxxf86vm-dev 
RUN apt install -y mesa-common-dev 
RUN apt install -y iproute2 
RUN apt install -y mesa-utils 
RUN apt install -y ninja-build 
RUN apt install -y pkg-config
RUN apt install -y python3-dev 
RUN apt install -y qtbase5-dev 
RUN apt install -y tzdata


RUN apt install -y nodejs 
RUN apt install -y npm
RUN npm install -g n && n stable

RUN git config --global core.fileMode false
RUN git config --global core.autocrlf true
RUN git config --global user.email "emil.martens@gmail.com"
RUN git config --global user.name "Emil Martens"

WORKDIR /root
RUN echo "export DISPLAY=host.docker.internal:0.0" >> .bashrc
RUN echo "export LIBGL_ALWAYS_INDIRECT=1" >> .bashrc