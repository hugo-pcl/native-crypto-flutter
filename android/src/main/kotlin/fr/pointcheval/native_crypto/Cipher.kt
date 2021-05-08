package fr.pointcheval.native_crypto

import java.lang.Exception
import javax.crypto.Cipher
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

enum class CipherAlgorithm(val spec: String) {
    AES("AES"),
}

enum class BlockCipherMode(val instance: String) {
    CBC("CBC"),
    GCM("GCM"),
}

enum class Padding(val instance: String) {
    PKCS5("PKCS5Padding"),
    None("NoPadding")
}

class CipherParameters(private val mode: BlockCipherMode, private val padding: Padding) {
    override fun toString(): String {
        return mode.instance + "/" + padding.instance
    }
}

class Cipher {

    fun getCipherAlgorithm(dartAlgorithm: String) : CipherAlgorithm {
        return when (dartAlgorithm) {
            "aes" -> CipherAlgorithm.AES
            else -> CipherAlgorithm.AES
        }
    }

    fun getInstance(mode : String, padding : String) : CipherParameters {
        val m = when (mode) {
            "cbc" -> BlockCipherMode.CBC
            "gcm" -> BlockCipherMode.GCM
            else -> throw Exception()
        }
        val p = when (padding) {
            "pkcs5" -> Padding.PKCS5
            else -> Padding.None
        }
        return CipherParameters(m,p)
    }

    fun encrypt(data: ByteArray, key: ByteArray, algorithm: String, mode: String, padding: String) : List<ByteArray> {
        val algo = getCipherAlgorithm(algorithm)
        val params = getInstance(mode, padding)

        val keySpecification = algo.spec + "/" + params.toString()

        val mac = Hash().digest(key + data)
        val sk: SecretKey = SecretKeySpec(key, algo.spec)

        val cipher = Cipher.getInstance(keySpecification)
        cipher.init(Cipher.ENCRYPT_MODE, sk)

        val encryptedBytes = cipher.doFinal(mac + data)
        val iv = cipher.iv

        return listOf(encryptedBytes, iv);
    }

    fun decrypt(payload: Collection<ByteArray>, key: ByteArray, algorithm: String, mode: String, padding: String) : ByteArray? {
        val algo = getCipherAlgorithm(algorithm)
        val params = getInstance(mode, padding)

        val keySpecification = algo.spec + "/" + params.toString()

        val sk: SecretKey = SecretKeySpec(key, algo.spec)
        val cipher = Cipher.getInstance(keySpecification);
        val iv = payload.last();
        val ivSpec = IvParameterSpec(iv)
        cipher.init(Cipher.DECRYPT_MODE, sk, ivSpec);

        val decryptedBytes = cipher.doFinal(payload.first());

        val mac = decryptedBytes.copyOfRange(0, 32)
        val decryptedContent : ByteArray = decryptedBytes.copyOfRange(32, decryptedBytes.size)
        val verificationMac = Hash().digest(key + decryptedContent)

        return if (mac.contentEquals(verificationMac)) {
            decryptedContent
        } else {
            null;
        }
    }
}