package fr.pointcheval.native_crypto_android.interfaces

import fr.pointcheval.native_crypto_android.utils.FileParameters

interface Cipher {
    fun encrypt(data: ByteArray, key: ByteArray, predefinedIV: ByteArray?): ByteArray
    fun decrypt(data: ByteArray, key: ByteArray): ByteArray
    fun encryptFile(fileParameters: FileParameters, key: ByteArray, predefinedIV: ByteArray?): Boolean
    fun decryptFile(fileParameters: FileParameters, key: ByteArray): Boolean
}