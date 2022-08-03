
# Scripts to build Azure Kinect SDK on Ubuntu #
This script simply builds the Azure Kinect SDK inside an Ubuntu container and makes necessary exposes necessary files for use in the host system

## Usage ##
1. clone this repo
2. run the script:
```./prepare_sdk.sh```
 - This will:
    1. download the source repositories (Azure kinect sdk and dependencies)
    2. create a docker image.
    3. use the docker image to build the SDK (and extract libsoundio1.so from the docker image)
    4. extract the depth engine '.so' from a .deb
 - Output will be under this repository: repo/bin
 - You may be able to:
    ```
    cd repo
    sudo make install
    ```

## Works on ##
This has been tested on Ubuntu 22.04 and has partial success (k4aviewer runs, but no audio).  Further testing useful.


## Dependencies ##
These are required in the host environment to run the `prepare_sdk.sh` script, but there may be more.
- docker
  `apt install -y docker`
- Git
  `apt install -y git`
- wget
  `apt install -y wget`


# Temporary solution! #
The best solution would be to modify the docker image to use ubuntu 22.04 (or whatever latest build environment) then attempt compilation and fix all issues that come up.

## Progress ##
Initial tests have confirmed that updating to 22.04 is more complex than changing the docker base image for the build environment to 22.04 and updating the dependency repositories to 'latest'.
Without updating dependencies, there are various issues around openSSL versions (the current codebase uses specific versions of dependencies that compile against openSSL pre 1.1.0)
With the updates, there are various dependencies not found issues (i.e. some kind of CMake config issue).
Both of these may well be masking further issues!
Consequently it's probably not a major code writing issue, more an issue of threading a needle (attempt a fix, did it work? ... try again, and again ... and again!) 
