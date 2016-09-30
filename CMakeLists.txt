# CMake package build for the wolfSSL crypto library
cmake_minimum_required(VERSION 3.0.2)
set(CMAKE_TOOLCHAIN_FILE ../ubirch-arm-toolchain/cmake/ubirch-arm-gcc-toolchain.cmake CACHE STRING "ubirch arm toolchain")
set(MCU "MK82F25615" CACHE STRING "MCU type")

project(ubirch-wolfssl C)

# we need the Kinetis SDK 2.0 to compile wolfSSL
require(PACKAGE KinetisSDK MCU ${MCU} VERSION 2.0)

# try to find wolfssl in the parent directory
set(WOLFSSL_GIT ../wolfssl)
set(WOLFSSL_NXP ../ubirch-wolfssl-nxp/middleware/wolfssl_3.9.0)
set(WOLFSSL_UBIRCH ../ubirch-wolfssl)
find_path(_WOLFSSL_ROOT wolfssl NAMES wolfcrypt/aes.h HINTS ${WOLFSSL_ROOT} ${WOLFSSL_GIT} ${WOLFSSL_NXP} ${WOLFSSL_UBIRCH} NO_DEFAULT_PATH)

if (_WOLFSSL_ROOT-NOTFOUND)
  message(FATAL_ERROR "Missing wolfssl directory, set with -DWOLFSSL_ROOT=<dir>!")
endif ()

if (_WOLFSSL_ROOT MATCHES ${WOLFSSL_NXP})
  set(WOLFSSL_DEFINITIONS
    -DWOLFSSL_KEY_GEN
    -DFREESCALE_KSDK_BM
    )
else ()
  set(WOLFSSL_DEFINITIONS
    -DWOLFSSL_KEY_GEN
    -DFREESCALE_KSDK_BM
    -DWOLFSSL_SHA512
    -DHAVE_CURVE25519
    -DHAVE_ED25519
    )
endif ()

# check targets we need
set(KSDK20_KSDK KinetisSDK::${MCU}::ksdk20)
if (TARGET KinetisSDK::${MCU}::mmcau)
  # the NXP port already defines FREESCALE_MMCAU
  if (NOT _WOLFSSL_ROOT MATCHES ${WOLFSSL_NXP})
    set(WOLFSSL_DEFINITIONS ${WOLFSSL_DEFINITIONS} -DFREESCALE_MMCAU)
  endif ()
  set(KSDK20_MMCAU KinetisSDK::${MCU}::mmcau)
endif ()

file(GLOB WOLFSSL_SRCS ${_WOLFSSL_ROOT}/wolfcrypt/src/*.c ${_WOLFSSL_ROOT}/wolfcrypt/src/port/nxp/*.c)
list(REMOVE_ITEM WOLFSSL_SRCS ${_WOLFSSL_ROOT}/wolfcrypt/src/misc.c)

add_library(wolfcrypt STATIC ${WOLFSSL_SRCS})
target_link_libraries(wolfcrypt ${KSDK20_KSDK} ${KSDK20_MMCAU})
target_include_directories(wolfcrypt PUBLIC ${_WOLFSSL_ROOT}/wolfssl/wolfcrypt/port ${_WOLFSSL_ROOT})
target_compile_definitions(wolfcrypt PUBLIC ${WOLFSSL_DEFINITIONS})

provide(PACKAGE wolfSSL MCU ${MCU} VERSION 3.9.0 TARGETS wolfcrypt)
