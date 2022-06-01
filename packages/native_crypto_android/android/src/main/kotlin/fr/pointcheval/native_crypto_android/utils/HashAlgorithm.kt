package fr.pointcheval.native_crypto_android.utils

import java.security.MessageDigest

@Suppress("EnumEntryName")
enum class HashAlgorithm(val bitsCount: Int) {
    sha256(256),
    sha384(384),
    sha512(512);

    fun messageDigestString(): String {
        return when (this) {
            sha256 -> "SHA-256"
            sha384 -> "SHA-384"
            sha512 -> "SHA-512"
        }
    }

    fun hmacString(): String {
        return when (this) {
            sha256 -> "HmacSHA256"
            sha384 -> "HmacSHA384"
            sha512 -> "HmacSHA512"
        }
    }

    fun pbkdf2String(): String {
        return when (this) {
            sha256 -> "PBKDF2WithHmacSHA256"
            sha384 -> "PBKDF2WithHmacSHA384"
            sha512 -> "PBKDF2WithHmacSHA512"
        }
    }

    fun digest(data: ByteArray): ByteArray {
        val md = MessageDigest.getInstance(messageDigestString())
        return md.digest(data)
    }

    companion object {
        fun digest(data: ByteArray, algorithm: String): ByteArray {
            for (h in values()) {
                if (h.name == algorithm) {
                    return h.digest(data)
                }
            }
            throw Exception("Unknown HashAlgorithm: $algorithm")
        }
    }
}