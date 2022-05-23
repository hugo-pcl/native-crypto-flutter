package fr.pointcheval.native_crypto_android

import java.security.MessageDigest

object Hash {
    fun digest(data: ByteArray?, algorithm: HashAlgorithm): ByteArray {
        val func : String = when (algorithm) {
            HashAlgorithm.SHA256 -> "SHA-256"
            HashAlgorithm.SHA384 -> "SHA-384"
            HashAlgorithm.SHA512 -> "SHA-512"
        }
        val md = MessageDigest.getInstance(func)
        return md.digest(data)
    }

    fun digest(data: ByteArray?, algorithm: String): ByteArray {
        val func : HashAlgorithm = when (algorithm) {
            "sha256" -> HashAlgorithm.SHA256
            "sha384" -> HashAlgorithm.SHA384
            "sha512" -> HashAlgorithm.SHA512
            else -> HashAlgorithm.SHA256
        }
        return digest(data, func)
    }
}