package fr.pointcheval.native_crypto_android.ciphers

import fr.pointcheval.native_crypto_android.interfaces.Cipher
import fr.pointcheval.native_crypto_android.utils.FileParameters
import javax.crypto.CipherOutputStream
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

class AES : Cipher {
   private var cipherInstance: javax.crypto.Cipher? = null

    private fun lazyLoadCipher() {
        if (cipherInstance == null) {
            cipherInstance = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        }
    }


    // native.crypto cipherText representation = [NONCE(12) || CIPHERTEXT(n-28) || TAG(16)]
    override fun encrypt(data: ByteArray, key: ByteArray, predefinedIV: ByteArray?): ByteArray {
        // Initialize secret key spec
        val sk = SecretKeySpec(key, "AES")

        // Initialize cipher (if not already done)
        lazyLoadCipher()

        // If predefinedIV is not null, use it
        if (predefinedIV != null && predefinedIV.isNotEmpty()) {
            // Here we use the predefinedIV as the nonce (12 bytes)
            // And we set the tag length to 16 bytes (128 bits)
            val gcmParameterSpec = GCMParameterSpec(16*8, predefinedIV)
            cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk, gcmParameterSpec)
        } else {
            // If predefinedIV is null, we generate a new one
            cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        }

        // Encrypt data
        val bytes: ByteArray = cipherInstance!!.doFinal(data)
        val iv: ByteArray = cipherInstance!!.iv

        return iv.plus(bytes)
    }

    override fun encryptFile(fileParameters: FileParameters, key: ByteArray, predefinedIV: ByteArray?): Boolean {
        // Initialize secret key spec
        val sk = SecretKeySpec(key, "AES")

        // Initialize cipher (if not already done)
        lazyLoadCipher()

        // If predefinedIV is not null, use it
        if (predefinedIV != null && predefinedIV.isNotEmpty()) {
            // Here we use the predefinedIV as the nonce (12 bytes)
            // And we set the tag length to 16 bytes (128 bits)
            val gcmParameterSpec = GCMParameterSpec(16*8, predefinedIV)
            cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk, gcmParameterSpec)
        } else {
            // If predefinedIV is null, we generate a new one
            cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        }

        var len: Int?
        val buffer = ByteArray(8192)
        val inputFile = fileParameters.getFileInputStream()
        val outputFile = fileParameters.getFileOutputStream()
        val iv: ByteArray? = cipherInstance!!.iv

        outputFile?.write(iv)
        outputFile?.flush()

        val encryptedStream = CipherOutputStream(outputFile!!, cipherInstance)
        while(true) {
            len = inputFile?.read(buffer)
            if (len != null && len > 0) {
                encryptedStream.write(buffer,0,len)
            } else {
                break
            }
        }
        encryptedStream.flush()
        encryptedStream.close()
        inputFile?.close()
        outputFile.close()

        return fileParameters.outputExists()
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray {
        // Extract the IV from the cipherText
        val iv: ByteArray = data.take(12).toByteArray()
        val payload: ByteArray = data.drop(12).toByteArray()

        // Initialize secret key spec
        val sk = SecretKeySpec(key, "AES")

        // Initialize GCMParameterSpec
        val gcmParameterSpec = GCMParameterSpec(16 * 8, iv)

        // Initialize cipher (if not already done)
        lazyLoadCipher()
        cipherInstance!!.init(javax.crypto.Cipher.DECRYPT_MODE, sk, gcmParameterSpec)

        // Decrypt data
        return cipherInstance!!.doFinal(payload)
    }

    override fun decryptFile(fileParameters: FileParameters, key: ByteArray): Boolean {
        val iv = ByteArray(12)
        val inputFile = fileParameters.getFileInputStream() ?: throw Exception("Error while reading IV")

        // Read the first 12 bytes from the file
        for (i in 0 until 12) {
            iv[i] = inputFile.read().toByte()
        }

        // Initialize secret key spec
        val sk = SecretKeySpec(key, "AES")

        // Initialize GCMParameterSpec
        val gcmParameterSpec = GCMParameterSpec(16 * 8, iv)

        // Initialize cipher (if not already done)
        lazyLoadCipher()

        cipherInstance!!.init(javax.crypto.Cipher.DECRYPT_MODE, sk, gcmParameterSpec)

        var len: Int?
        val buffer = ByteArray(8192)
        val outputFile = fileParameters.getFileOutputStream()
        val decryptedStream = CipherOutputStream(outputFile!!, cipherInstance)
        while (true) {
            len = inputFile.read(buffer)
            if(len > 0){
                decryptedStream.write(buffer,0, len)
            } else {
                break
            }
        }
        decryptedStream.flush()
        decryptedStream.close()
        inputFile.close()

        return fileParameters.outputExists()
    }
}