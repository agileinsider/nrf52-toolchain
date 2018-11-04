# Build Toolchain for Nordic nRF52 development

This docker file is a simple toolchain for compiling code for the Nordic nRF52 devices.

It incorporates the following

* Embedded GCC 7.3.1 - Q2 2018 Release
* Nordic S132 Soft Device - v6.1.0
* Nordic S140 Soft Device - v6.1.0
* Nordic nRF5 SDK 15.2.0
* Nordic Command Line Utilities

It exposes some environment variables making it easy to compile your code which references the SDK

## Usage

```
docker build -t nrf .
docker run -v /path/to/source:/build -it nrf /bin/bash
```

Inside the container, you can then
```
cd path/to/Makefile
make SDK_ROOT=$SDK_ROOT
```
