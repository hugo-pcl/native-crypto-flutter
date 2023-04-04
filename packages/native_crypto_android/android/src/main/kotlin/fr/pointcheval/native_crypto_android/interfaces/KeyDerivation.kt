package fr.pointcheval.native_crypto_android.interfaces

interface KeyDerivation {
    fun derive(): ByteArray?
}