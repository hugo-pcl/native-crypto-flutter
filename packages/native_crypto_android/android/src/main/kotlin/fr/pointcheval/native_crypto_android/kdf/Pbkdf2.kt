package fr.pointcheval.native_crypto_android.kdf

import fr.pointcheval.native_crypto_android.HashAlgorithm
import fr.pointcheval.native_crypto_android.interfaces.KeyDerivation
import fr.pointcheval.native_crypto_android.utils.HashAlgorithmParser
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec

class Pbkdf2(
    private val length: Int, private val iterations: Int,
    private val hashAlgorithm: HashAlgorithm
) : KeyDerivation {

    private var password: CharArray? = null
    private var salt: ByteArray? = null

    fun init(password: ByteArray, salt: ByteArray) {
        // Transform the password to a char array
        val passwordCharArray = CharArray(password.size)
        for (i in password.indices) {
            passwordCharArray[i] = password[i].toInt().toChar()
        }

        this.password = passwordCharArray
        this.salt = salt
    }

    override fun derive(): ByteArray? {
        if (password == null || salt == null) {
            throw Exception("Password and Salt must be initialized.")
        }
        val spec = PBEKeySpec(
            password!!,
            salt!!,
            iterations,
            length * 8
        )
        val skf: SecretKeyFactory =
            SecretKeyFactory.getInstance(HashAlgorithmParser.getPbkdf2String(hashAlgorithm))

        return skf.generateSecret(spec).encoded
    }
}