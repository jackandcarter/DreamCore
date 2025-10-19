add_library(dc_compat
  openssl_compat.cpp)

target_include_directories(dc_compat
  PUBLIC
    ${CMAKE_SOURCE_DIR}/src)

target_link_libraries(dc_compat
  PUBLIC
    OpenSSL::Crypto)
