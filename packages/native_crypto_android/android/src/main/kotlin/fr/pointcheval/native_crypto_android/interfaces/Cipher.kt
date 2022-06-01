package fr.pointcheval.native_crypto_android.interfaces

import fr.pointcheval.native_crypto_android.utils.CipherAlgorithm

interface Cipher {
    val algorithm: CipherAlgorithm

    fun encrypt(data: ByteArray, key: ByteArray): ByteArray
    fun decrypt(data: ByteArray, key: ByteArray): ByteArray
    fun encryptAsList(data: ByteArray, key: ByteArray): List<ByteArray>
    fun decryptAsList(data: List<ByteArray>, key: ByteArray): ByteArray
}