# CMake package build for the wolfSSL crypto library
cmake_minimum_required(VERSION 3.0.2)

# we need the Kinetis SDK 2.0 to compile wolfSSL
find_package(KinetisSDK 2.0 REQUIRED)
if (NOT TARGET ksdk20)
    message(FATAL_ERROR "Could not find Kinetis SDK 2.0, please build first!")
endif ()
message(STATUS "Kinetis SDK: ${KinetisSDK_DIR}")

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
    set(WOLFSSL_DEFINITIONS "${WOLFSSL_DEFINITIONS} -DFREESCALE_MMCAU")
    set(WOLFSSL_TARGET_MMCAU mmcau)
endif ()


file(GLOB WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/*.c)
list(REMOVE_ITEM WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/misc.c)

add_library(wolfcrypt STATIC ${WOLFSSL_SRCS})
target_link_libraries(wolfcrypt ksdk20 ${WOLFSSL_TARGET_MMCAU})
target_include_directories(wolfcrypt PUBLIC ${WOLFSSL_ROOT})
target_compile_definitions(wolfcrypt PUBLIC ${WOLFSSL_DEFINITIONS})

set(wolfSSL_VERSION 3.9.0)

# export the target ksdk20 from within the build tree, creating a config file
export(TARGETS ${KSDK_TARGETS} FILE wolfSSLConfig.cmake)

# create a config version file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/wolfSSLConfigVersion.cmake"
        VERSION ${wolfSSL_VERSION}
        COMPATIBILITY AnyNewerVersion
)

# register this target in the cmake registry
export(PACKAGE wolfSSL)
