#! /bin/bash
TOOLCHAIN=${TOOLCHAIN:-"../ubirch-arm-toolchain/cmake/ubirch-arm-gcc-toolchain.cmake"}
WOLFSSL_ROOT=${WOLFSSL_ROOT:-"../ubirch-wolfssl"}
MCU=MK82F25615
# do an out-of-source build for all configurations
if [ "$1" == "-a" ]
then BUILDS="Debug Release MinSizeRel RelWithDebInfo"
else BUILDS=MinSizeRel
fi
[ -d "build/$MCU" ] && rm -r "build/$MCU"
for BUILD_TYPE in $BUILDS
do
  (mkdir -p "build/$MCU/$BUILD_TYPE"; cd "build/$MCU/$BUILD_TYPE"; \
  cmake ../../.. -DCMAKE_TOOLCHAIN_FILE="../../../$TOOLCHAIN" -DMCU="$MCU" -DWOLFSSL_ROOT="$WOLFSSL_ROOT" -DCMAKE_BUILD_TYPE="$BUILD_TYPE"; \
  make)
done
