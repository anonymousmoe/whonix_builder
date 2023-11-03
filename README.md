# whonix_builder
 Utilizes a debian:bookworm Docker Container that automatically verifies and builds Whonix images, incorporating the official derivative-maker build script, while including environment variables to customize every available build option and log files of the entire build process.
 
## Usage

### Building Docker Image
* Cloning whonix_builder repo:
```
git clone https://github.com/anonymousmoe/whonix_builder -b main
```
* Enter whonix_builder directory:
```
cd $PWD/whonix_builder
```
* Start Docker Image creation:
```
docker build .
```
### Run Docker Container without ENV variables:
The Dockerfile already contains default values for all environment variables which will be included in the image.
If you execute `docker run` without assigning new values, the defaults will apply.
```
docker run --name whonix_builder -it --privileged \
	--volume <HOST_DIR>:/home/user <IMAGE_ID> 
```
### Run Docker Container with ENV variables:
```
docker run --name whonix_builder -it --privileged \
	--env 'WHONIX_TAG=17.0.5.9-developers-only' \
	--env 'TBB_VERSION=13.0.1' \
	--env 'FLAVOR_GW=whonix-gateway-cli' \
	--env 'FLAVOR_WS=whonix-workstation-cli' \
	--env 'TARGET=raw' \
	--env 'ARCH=amd64' \
	--env 'REPO=true' \
	--volume <HOST_DIR>:/home/user <IMAGE_ID> 
```
### Environment Variables
* WHONIX_TAG = Any available git tag on the [official derivative-maker repository](https://github.com/Whonix/derivative-maker/tags)
* TBB_VERSION = Latest Tor Browser version indicated in [downloads.json]( https://aus1.torproject.org/torbrowser/update_3/release/downloads.json)
* FLAVOR_GW = derivative-maker --flavor option for the gateway image | `whonix-gateway-xfce` `whonix-gateway-cli`
* FLAVOR_WS = derivative-maker --flavor option for the workstation image | `whonix-workstation-xfce` `whonix-workstation-cli`
* TARGET = derivative-maker --target option | `raw` `qcow2` `virtualbox` `utm`
* ARCH = derivative-maker --target arch | `amd64` `arm64` `i386`
* REPO = derivative-maker --target repo | `true` `false`

### Volume
The container's home directory is mounted as a volume which can be bound to any location of your choosing.
Example: `--volume /home/user/shared:/home/user` would bind a folder named shared in the host's home directory
to the container's home directory, which is where all build files will be located.

## Useful Links
* https://www.whonix.org/wiki/Dev/Build_Documentation/VM
* https://www.whonix.org/wiki/Dev/Source_Code_Intro

## Special Thanks
* [Whonix Team](https://www.whonix.org/)
* [@Patrick - Whonix Forums](https://forums.whonix.org/)
* [@adrelanos - Whonix Github](https://github.com/Whonix/derivative-maker)
