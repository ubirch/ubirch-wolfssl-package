# ubirch [wolfSSL](https://www.wolfssl.com/) package build

This is a [CMake](https://cmake.org) package for the [wolfSSL](https://www.wolfssl.com/) library. It
creates a wolfSSL library target as well that can be found by other CMake projects using `find_package()`.
It requires the [Kinetis SDK](https://github.com/ubirch/ubirch-kinetis-sdk-package) package to be
build beforehand.

## Building

1. Checkout the [ubirch-arm-toolchain](https://github.com/ubirch/ubirch-arm-toolchain)
3. Create a build directory:
    ```
    mkdir build
    cd build
    ```
3. Run cmake (providing the toolchain, and if necessary the wolfSSL dir: `-DWOLFSSL_ROOT=<wolfssl-dir>`):
    ```
    cmake -DCMAKE_TOOLCHAIN_FILE=<toolchain-dir>/cmake/ubirch-arm-toolchain.cmake
    ```
4. Run make
    ```
    make
    ```

> If you want to build all different configuration types (`Debug`, `Release`, `MinSizeRel`, ...)
> you need to create a build directory for every configuration and run `cmake` with an extra
> argument `-DCMAKE_BUILD_TYPE=<build-type>` as well as `make`.

## Contents

- `CMakeLists.txt` - package build file
- `build.sh` - default build file, creating a sub directory `build` and runs `cmake` and `make`

## License

>  __&#9888; Attention__ <br/>
> The wolfSSL library itself is __Copyright &copy; wolfSSL Inc.__, licensed under the
> [GNU General Public License](https://en.wikipedia.org/wiki/GNU_General_Public_License).
> Check the [wolfSSL repository](https://github.com/wolfSSL/wolfssl) for more information.

If not otherwise noted in the individual files, the code in this repository is

__Copyright &copy; 2016 [ubirch](http://ubirch.com) GmbH, Author: Matthias L. Jugel__

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```





