#!/bin/bash
# Here are some default settings.
# Make sure DOCKER_WORKDIR is created and owned by current user.

# Docker

DOCKER_IMAGE_TAG="imx-yocto"
#DOCKER_WORKDIR="/opt/yocto"
DOCKER_WORKDIR="/home/ccisn/yocto_imx8"
# Yocto

IMX_RELEASE="imx-5.10.72-2.2.0"

# DO IT AGAIN 
git config --global user.name "ccisn"
git config --global user.email "ccisn@hslu.ch"
git config --list

YOCTO_DIR="${DOCKER_WORKDIR}/${IMX_RELEASE}-build"

MACHINE="imx8mnevk"
DISTRO="fsl-imx-xwayland"
IMAGES="imx-image-full"

REMOTE="https://source.codeaurora.org/external/imx/imx-manifest"
BRANCH="imx-linux-hardknott"
MANIFEST=${IMX_RELEASE}".xml"
