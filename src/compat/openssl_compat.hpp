#pragma once

#include <vector>
#include <cstddef>
#include <string>
#include <openssl/opensslv.h>
#include <openssl/evp.h>
#include <openssl/hmac.h>

namespace dc_crypto {
  std::vector<unsigned char> sha1(const unsigned char* data, size_t len);
  std::vector<unsigned char> sha256(const unsigned char* data, size_t len);
  std::vector<unsigned char> md5(const unsigned char* data, size_t len);
  std::vector<unsigned char> hmac_sha256(const unsigned char* key, size_t keylen,
                                         const unsigned char* data, size_t len);
}
