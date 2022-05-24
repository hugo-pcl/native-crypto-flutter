package fr.pointcheval.native_crypto_android.utils

class Task<T>(private var task: () -> T) {

    private var successful = false
    private var result: T? = null
    private var exception: Exception? = null

    fun isSuccessful(): Boolean {
        return successful
    }

    fun getResult(): T {
        if (successful && result != null) {
            return result!!
        } else {
            throw Exception("No result found!")
        }
    }

    fun getException(): Exception {
        if (exception != null) {
            return exception!!
        } else {
            throw Exception("No exception found!")
        }
    }

    fun call() {
        try {
            result = task()
            exception = null
            successful = true
        } catch (e: Exception) {
            exception = e
            result = null
            successful = false
        }
    }

    fun finalize(callback: (task: Task<T>) -> Unit) {
        callback(this)
    }
}