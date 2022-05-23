package fr.pointcheval.native_crypto_android

enum class HashAlgorithm(val length : Int) {
    SHA256(256),
    SHA384(384),
    SHA512(512);

    fun hmac(): String {
        return when (this) {
            HashAlgorithm.SHA256 -> "HmacSHA256"
            HashAlgorithm.SHA384 -> "HmacSHA384"
            HashAlgorithm.SHA512 -> "HmacSHA512"
        }
    }
}