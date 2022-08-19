FROM ubuntu:20.04

# Update system and add the packages required for Yocto builds.
# Use DEBIAN_FRONTEND=noninteractive, to avoid image build hang waiting
# for a default confirmation [Y/n] at some configurations.

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y gawk wget git-core diffstat unzip texinfo \
    gcc-multilib build-essential chrpath socat cpio python python3 \
    python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    libsdl1.2-dev xterm tar locales net-tools rsync sudo vim curl

# Set up locales
RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Yocto needs 'source' command for setting up the build environment, so replace
# the 'sh' alias to 'bash' instead of 'dash'.
RUN rm /bin/sh && ln -s bash /bin/sh

# Install repo
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/repo

# Add your user to sudoers to be able to install other packages in the container.

ARG USER=ccisn
ARG UID=1001
ARG GID=1001
ARG PW=ccisn
ARG USER
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# Set the arguments for host_id and user_id to be able to save the build artifacts
# outside the container, on host directories, as docker volumes.
RUN groupadd -g $GID nxp && \
    useradd -g $GID -m -s /bin/bash -u $UID $USER

# Yocto builds should run as a normal user.
# USER $USER
USER ${UID}:${GID}
# Add user git info
RUN git config --global user.name "ccisn"
RUN git config --global user.email "ccisn@hslu.ch"
RUN git config --list

RUN mkdir /home/ccisn/yocto_imx8

COPY . /imx-docker
RUN cd imx-docker/ && sudo ln -sf imx-5.10.72-2.2.0/env.sh env.sh

# docker run --rm -ti -v  /var/run/docker.sock:/var/run/docker.sock dockers:imx 

ARG DOCKER_WORKDIR
WORKDIR ${DOCKER_WORKDIR}
