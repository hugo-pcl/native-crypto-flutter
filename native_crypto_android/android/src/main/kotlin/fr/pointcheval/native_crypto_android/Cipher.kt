package fr.pointcheval.native_crypto_android

abstract class Cipher {
    abstract fun encrypt(data: ByteArray, key: ByteArray) : ByteArray?;
    abstract fun decrypt(data: ByteArray, key: ByteArray) : ByteArray?;
}