FROM gcc:8.1

LABEL \
  gcc.version=7.3.1 \
  gcc.release=2018-q2 \
  softdevice.version=6.0.0 \
  nrf5sdk.version=15.0.0

RUN apt-get update && apt-get install -y \
  unzip \
  vim \
  python \
  python-pip \
  && apt-get purge

WORKDIR /usr/local
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 | tar -xjf -

# https://www.nordicsemi.com/eng/Products/S132-SoftDevice
WORKDIR /usr/share/S132-SoftDevice
RUN wget -qO S132-SoftDevice.zip https://www.nordicsemi.com/eng/nordic/download_resource/67248/3/8320952/141008 && \
  unzip S132-SoftDevice.zip && \
  rm S132-SoftDevice.zip

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK
WORKDIR /usr/share/nRF5-SDK
RUN wget -qO nRF5-SDK.zip https://www.nordicsemi.com/eng/nordic/download_resource/59011/71/77279059/116085 && \
  unzip nRF5-SDK.zip && \
  rm nRF5-SDK.zip

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK-for-HomeKit
# The nRF5 SDK for HomeKit is available to MFI licensees only

# Setting up the development kit for nRF52832
# https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.nrf52%2Fdita%2Fnrf52%2Fdevelopment%2Fsetting_up_new.html

# https://gustavovelascoh.wordpress.com/2017/01/23/starting-development-with-nordic-nrf5x-and-gcc-on-linux/
ENV \
  PATH="/usr/local/gcc-arm-none-eabi-7-2018-q2-update/bin/:${PATH}" \
  SDK_ROOT="/usr/share/nRF5-SDK/nRF5_SDK_15.0.0_a53641a" \
  S132_ROOT="/usr/share/S132-SoftDevice/" \
  S132_IMAGE="/usr/share/S132-SoftDevice/s132_nrf52_6.0.0_softdevice.hex"

COPY Makefile.posix /usr/share/nRF5-SDK/nRF5_SDK_15.0.0_a53641a/components/toolchain/gcc/Makefile.posix

# Include nrfutil
RUN pip install nrfutil

# Include the Nordic Command Line Tools
# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF52832/nRF5x-Command-Line-Tools-Linux64
WORKDIR /usr/local/nRF5x
RUN wget -qO- https://www.nordicsemi.com/eng/nordic/download_resource/51388/29/43703846/94917 | tar -xf -

ENV PATH="${PATH}:/usr/local/nRF5x/nrfjprog:/usr/local/nRF5x/mergehex"

WORKDIR /build
