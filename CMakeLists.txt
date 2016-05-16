# CMake package build for the wolfSSL crypto library
cmake_minimum_required(VERSION 3.0.2)

# we need the Kinetis SDK 2.0 to compile wolfSSL
require(PACKAGE KinetisSDK VERSION 2.0)

# try to find wolfssl in the parent directory
find_path(WOLFSSL_ROOT wolfssl NAMES wolfcrypt/src/aes.h HINTS ../wolfssl)
message(STATUS "wolfSSL directory: ${WOLFSSL_ROOT}")
if (WOLFSSL_ROOT-NOTFOUND)
    message(FATAL_ERROR "Missing wolfssl directory, set with -DWOLFSSL_ROOT=<dir>!")
endif ()

set(WOLFSSL_DEFINITIONS
        -DWOLFSSL_KEY_GEN
        -DFREESCALE_KSDK_BM
        -DWOLFSSL_SHA512
        -DHAVE_CURVE25519
        -DHAVE_ED25519
        )

if (TARGET mmcau)
    set(WOLFSSL_DEFINITIONS ${WOLFSSL_DEFINITIONS} -DFREESCALE_MMCAU)
    set(WOLFSSL_TARGET_MMCAU mmcau)
endif ()

file(GLOB WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/*.c)
list(REMOVE_ITEM WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/misc.c)

add_library(wolfcrypt STATIC ${WOLFSSL_SRCS})
target_link_libraries(wolfcrypt ksdk20 ${WOLFSSL_TARGET_MMCAU})
target_include_directories(wolfcrypt PUBLIC ${WOLFSSL_ROOT})
target_compile_definitions(wolfcrypt PUBLIC ${WOLFSSL_DEFINITIONS})

provide(PACKAGE wolfSSL VERSION 3.9.0 TARGETS wolfcrypt)
