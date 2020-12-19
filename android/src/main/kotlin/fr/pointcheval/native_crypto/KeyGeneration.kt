package fr.pointcheval.native_crypto

import java.security.KeyPairGenerator
import java.security.SecureRandom
import javax.crypto.KeyGenerator

class KeyGeneration {
    fun keygen(size : Int) : ByteArray {
        val secureRandom = SecureRandom()
        val keyGenerator = if (size in listOf<Int>(128,192,256)) {
            KeyGenerator.getInstance("AES")
        } else {
            KeyGenerator.getInstance("BLOWFISH")
        }

        keyGenerator.init(size, secureRandom)
        val sk = keyGenerator.generateKey()

        return sk!!.encoded
    }

    fun rsaKeypairGen(size : Int) : List<ByteArray> {
        val secureRandom = SecureRandom()
        val keyGenerator = KeyPairGenerator.getInstance("RSA")

        keyGenerator.initialize(size, secureRandom)
        val keypair = keyGenerator.genKeyPair()
        val res : List<ByteArray> = listOf(keypair.public.encoded, keypair.private.encoded)

        return res
    }
}