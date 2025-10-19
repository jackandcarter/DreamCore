# DreamCore

Modernized BFA-core targeting Ubuntu 24.04+ (GCC 13 / Clang 16), Boost ≥1.74, OpenSSL 3.

## Build (Linux)
```bash
sudo apt update && sudo apt install -y build-essential cmake git \
  libmysqlclient-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libncurses-dev \
  libboost-dev libboost-system-dev libboost-filesystem-dev \
  libboost-program-options-dev libboost-thread-dev libboost-iostreams-dev \
  libboost-regex-dev
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
```

CI runs on ubuntu-24.04 for both GCC and Clang.

Contributing
Use C++17 or newer.
Prefer standard <type_traits> and lambdas over legacy Boost MPL/bind.
OpenSSL 3 APIs preferred (keep guarded fallbacks if needed).
One logical change per PR.
