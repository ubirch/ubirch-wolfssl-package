#! /bin/sh
TOOLCHAIN=../ubirch-arm-toolchain/cmake/ubirch-arm-gcc-toolchain.cmake
# do an out-of-source build for all configurations
[ -d build ] && rm -r build
for BUILD_TYPE in Debug Release MinSizeRel RelWithDebInfo
do
  (mkdir -p build/$BUILD_TYPE; cd build/$BUILD_TYPE; \
  cmake ../.. -DCMAKE_TOOLCHAIN_FILE="../../$TOOLCHAIN" -DCMAKE_BUILD_TYPE="$BUILD_TYPE"; \
  make)
done
