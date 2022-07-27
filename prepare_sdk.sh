#!/bin/bash


BUILD_ENV_TAG=azure_kinect_sdk_build_env

SRC_REPO="git@github.com:microsoft/Azure-Kinect-Sensor-SDK.git"

#See:
DEPTH_ENGINE_PACKAGE_URL="https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4/libk4a1.4_1.4.1_amd64.deb"


base_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
repo_dir="${base_dir}/repo"


function download_azure_kinect_sdk_repo()
{
    git clone "${SRC_REPO}" "${repo_dir}"
    pushd "${repo_dir}"
    git submodule init
    git submodule update
    popd
} # tested.

function build_docker_image()
{
    pushd "${repo_dir}/scripts/docker"
    chmod u+x setup-ubuntu.sh
    docker build -t "${BUILD_ENV_TAG}" .
    popd
} # tested.

function build_sdk()
{
    docker run --rm -it -w /root/repo -v ${repo_dir}:/root/repo "${BUILD_ENV_TAG}" /bin/bash -c "
        chown -R root:root . ;
        cmake . ;
        make # -j 4 build faster, but fails some tests.  probably a race condition during testing?
        "
}

function extract_depth_engine()
{
    #inside docker?
    mkdir -p "${tmp_dir}"
    pushd "${tmp_dir}"
    wget "${DEPTH_ENGINE_PACKAGE_URL}"
    ar -x *.deb
    tar -xzf data.tar.gz ./usr/lib/x86_64-linux-gnu/libk4a1.4/libdepthengine.so.2.0
    sudo mv "${tmp_dir}/usr/lib/x86_64-linux-gnu/libk4a1.4/libdepthengine.so.2.0" "${repo_dir}/bin/"
    popd
}

function extract_libsoundio1()
{
    #from within docker image
    #path found using ldd ./k4aviewer
    cp /usr/lib/x86_64-linux-gnu/libsoundio.so.1 .
}

