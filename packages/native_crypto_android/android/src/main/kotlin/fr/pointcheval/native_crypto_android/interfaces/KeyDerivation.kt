package fr.pointcheval.native_crypto_android.interfaces

import fr.pointcheval.native_crypto_android.keys.SecretKey
import fr.pointcheval.native_crypto_android.utils.KdfAlgorithm

interface KeyDerivation {
    val algorithm: KdfAlgorithm

    fun derive(): SecretKey
}