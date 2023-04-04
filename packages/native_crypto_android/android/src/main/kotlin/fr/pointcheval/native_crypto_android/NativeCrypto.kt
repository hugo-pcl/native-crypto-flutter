package fr.pointcheval.native_crypto_android

import android.content.Context
import fr.pointcheval.native_crypto_android.ciphers.AES
import fr.pointcheval.native_crypto_android.kdf.Pbkdf2
import fr.pointcheval.native_crypto_android.utils.FileParameters
import fr.pointcheval.native_crypto_android.utils.HashAlgorithmParser
import java.security.SecureRandom

class NativeCrypto(private val context: Context) : NativeCryptoAPI {
    override fun hash(data: ByteArray, algorithm: HashAlgorithm): ByteArray? {
        val md = HashAlgorithmParser.getMessageDigest(algorithm)

        return md.digest(data)
    }

    override fun hmac(data: ByteArray, key: ByteArray, algorithm: HashAlgorithm): ByteArray? {
        val mac = HashAlgorithmParser.getMac(algorithm)
        val secretKey = javax.crypto.spec.SecretKeySpec(key, mac.algorithm)
        mac.init(secretKey)

        return mac.doFinal(data)
    }

    override fun generateSecureRandom(length: Long): ByteArray {
        val bytes = ByteArray(length.toInt())
        SecureRandom.getInstanceStrong().nextBytes(bytes)

        return bytes
    }

    override fun pbkdf2(
        password: ByteArray,
        salt: ByteArray,
        length: Long,
        iterations: Long,
        algorithm: HashAlgorithm
    ): ByteArray? {
        val pbkdf2 = Pbkdf2(length.toInt(), iterations.toInt(), algorithm)
        pbkdf2.init(password, salt)

        return pbkdf2.derive()
    }

    override fun encrypt(
        plainText: ByteArray,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): ByteArray {
        // For now, only AES is supported
        val aes = AES()

        return aes.encrypt(plainText, key, null)
    }

    override fun encryptWithIV(
        plainText: ByteArray,
        iv: ByteArray,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): ByteArray {
        // For now, only AES is supported
        val aes = AES()

        return aes.encrypt(plainText, key, iv)
    }

    override fun decrypt(
        cipherText: ByteArray,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): ByteArray {
        // For now, only AES is supported
        val aes = AES()

        return aes.decrypt(cipherText, key)
    }

    override fun encryptFile(
        plainTextPath: String,
        cipherTextPath: String,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): Boolean {
        // For now, only AES is supported
        val aes = AES()
        val params = FileParameters(context, plainTextPath, cipherTextPath)

        return aes.encryptFile(params, key, null)
    }

    override fun encryptFileWithIV(
        plainTextPath: String,
        cipherTextPath: String,
        iv: ByteArray,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): Boolean {
        // For now, only AES is supported
        val aes = AES()
        val params = FileParameters(context, plainTextPath, cipherTextPath)

        return aes.encryptFile(params, key, iv)
    }

    override fun decryptFile(
        cipherTextPath: String,
        plainTextPath: String,
        key: ByteArray,
        algorithm: CipherAlgorithm
    ): Boolean {
        // For now, only AES is supported
        val aes = AES()
        val params = FileParameters(context, plainTextPath, cipherTextPath)

        return aes.decryptFile(params, key)
    }
}