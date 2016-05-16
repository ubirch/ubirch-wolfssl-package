# CMake package build for the wolfSSL crypto library
set(wolfSSL_VERSION 3.9.0)

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
    set(WOLFSSL_DEFINITIONS ${WOLFSSL_DEFINITIONS} -DFREESCALE_MMCAU)
    set(WOLFSSL_TARGET_MMCAU mmcau)
endif ()

file(GLOB WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/*.c)
list(REMOVE_ITEM WOLFSSL_SRCS ${WOLFSSL_ROOT}/wolfcrypt/src/misc.c)

add_library(wolfcrypt STATIC ${WOLFSSL_SRCS})
target_link_libraries(wolfcrypt ksdk20 ${WOLFSSL_TARGET_MMCAU})
target_include_directories(wolfcrypt PUBLIC ${WOLFSSL_ROOT})
target_compile_definitions(wolfcrypt PUBLIC ${WOLFSSL_DEFINITIONS})

include(CMakePackageConfigHelpers)

# export the target wolcrypt from within the build tree, creating a config file
# for the MinSizeRel build type, also write a generic config file
if (CMAKE_BUILD_TYPE MATCHES MinSizeRel)
    export(TARGETS ${KSDK_TARGETS} FILE wolfSSLConfig.cmake)
    write_basic_package_version_file(
            "${CMAKE_CURRENT_BINARY_DIR}/wolfSSLConfigVersion.cmake"
            VERSION ${wolfSSL_VERSION}
            COMPATIBILITY AnyNewerVersion
    )
endif ()

export(TARGETS wolfcrypt FILE wolfSSL${CMAKE_BUILD_TYPE}Config.cmake)
write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/wolfSSL${CMAKE_BUILD_TYPE}ConfigVersion.cmake"
        VERSION ${wolfSSL_VERSION}
        COMPATIBILITY AnyNewerVersion
)

# register this target in the cmake registry
export(PACKAGE wolfSSL)
