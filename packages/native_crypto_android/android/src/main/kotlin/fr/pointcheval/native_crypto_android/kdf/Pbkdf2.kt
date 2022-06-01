package fr.pointcheval.native_crypto_android.kdf

import fr.pointcheval.native_crypto_android.interfaces.KeyDerivation
import fr.pointcheval.native_crypto_android.keys.SecretKey
import fr.pointcheval.native_crypto_android.utils.HashAlgorithm
import fr.pointcheval.native_crypto_android.utils.KdfAlgorithm
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec

class Pbkdf2(
    private val keyBytesCount: Int, private val iterations: Int,
    private val hash: HashAlgorithm = HashAlgorithm.sha256
) : KeyDerivation {

    private var password: String? = null
    private var salt: String? = null

    fun init(password: String, salt: String) {
        this.password = password
        this.salt = salt
    }

    override val algorithm: KdfAlgorithm
        get() = KdfAlgorithm.pbkdf2

    override fun derive(): SecretKey {
        if (password == null || salt == null) {
            throw Exception("Password and Salt must be initialized.")
        }
        val spec = PBEKeySpec(
            password!!.toCharArray(),
            salt!!.toByteArray(),
            iterations,
            keyBytesCount * 8
        )
        val skf: SecretKeyFactory = SecretKeyFactory.getInstance(hash.pbkdf2String())
        return SecretKey(skf.generateSecret(spec).encoded)
    }
}