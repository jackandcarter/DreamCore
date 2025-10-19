#include "compat/openssl_compat.hpp"

#include <stdexcept>

namespace {
  std::vector<unsigned char> do_digest(const EVP_MD* md,
                                       const unsigned char* data, size_t len) {
    std::vector<unsigned char> out(EVP_MAX_MD_SIZE);
    unsigned int outlen = 0;
    EVP_MD_CTX* ctx = EVP_MD_CTX_new();
    if (!ctx) throw std::runtime_error("EVP_MD_CTX_new failed");
    if (EVP_DigestInit_ex(ctx, md, nullptr) != 1 ||
        EVP_DigestUpdate(ctx, data, len) != 1 ||
        EVP_DigestFinal_ex(ctx, out.data(), &outlen) != 1) {
      EVP_MD_CTX_free(ctx);
      throw std::runtime_error("EVP digest failed");
    }
    EVP_MD_CTX_free(ctx);
    out.resize(outlen);
    return out;
  }
}

namespace dc_crypto {
  std::vector<unsigned char> sha1(const unsigned char* d, size_t n)   { return do_digest(EVP_sha1(),   d, n); }
  std::vector<unsigned char> sha256(const unsigned char* d, size_t n) { return do_digest(EVP_sha256(), d, n); }
  std::vector<unsigned char> md5(const unsigned char* d, size_t n)    { return do_digest(EVP_md5(),    d, n); }

  std::vector<unsigned char> hmac_sha256(const unsigned char* key, size_t keylen,
                                         const unsigned char* data, size_t len) {
    std::vector<unsigned char> out(EVP_MAX_MD_SIZE);
    unsigned int outlen = 0;
#if OPENSSL_VERSION_NUMBER >= 0x30000000L
    HMAC(EVP_sha256(), key, static_cast<int>(keylen), data, len, out.data(), &outlen);
#else
    HMAC(EVP_sha256(), key, static_cast<int>(keylen), data, len, out.data(), &outlen);
#endif
    out.resize(outlen);
    return out;
  }
}
