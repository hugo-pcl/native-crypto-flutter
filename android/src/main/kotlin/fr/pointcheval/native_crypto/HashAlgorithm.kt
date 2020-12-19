package fr.pointcheval.native_crypto

import java.security.MessageDigest

enum class HashAlgorithm(val length : Int) {
    SHA1(160),
    SHA224(224),
    SHA256(256),
    SHA384(384),
    SHA512(512);
}


class Hash() {
    fun digest(data: ByteArray?, algorithm: HashAlgorithm): ByteArray {
        val func : String = when (algorithm) {
            HashAlgorithm.SHA1 -> "SHA-1"
            HashAlgorithm.SHA224 -> "SHA-224"
            HashAlgorithm.SHA256 -> "SHA-256"
            HashAlgorithm.SHA384 -> "SHA-384"
            HashAlgorithm.SHA512 -> "SHA-512"
        }
        val md = MessageDigest.getInstance(func)
        return md.digest(data)
    }

    fun digest(data: ByteArray?, algorithm: String): ByteArray {
        val func : HashAlgorithm = when (algorithm) {
            "sha1" -> HashAlgorithm.SHA1
            "sha224" -> HashAlgorithm.SHA224
            "sha256" -> HashAlgorithm.SHA256
            "sha384" -> HashAlgorithm.SHA384
            "sha512" -> HashAlgorithm.SHA512
            else -> HashAlgorithm.SHA256
        }
        return digest(data, func)
    }

    fun digest(data: ByteArray?): ByteArray {
        return digest(data, HashAlgorithm.SHA256)
    }
}
