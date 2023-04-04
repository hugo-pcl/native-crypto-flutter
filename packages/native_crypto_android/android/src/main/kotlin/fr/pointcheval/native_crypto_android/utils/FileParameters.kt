package fr.pointcheval.native_crypto_android.utils

import android.content.Context
import android.content.res.Resources
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import java.io.*

class FileParameters(ctx: Context, input: String, output: String) {
    private var context: Context

    private var inputPath: String
    private var outputPath: String

    init {
        this.context = ctx
        this.inputPath = input
        this.outputPath = output
    }

    private fun getUri(): Uri? {
        val persistedUriPermissions = context.contentResolver.persistedUriPermissions
        if (persistedUriPermissions.size > 0) {
            val uriPermission = persistedUriPermissions[0]
            return uriPermission.uri
        }
        return null
    }

    private fun getDocumentFileByPath(path: String): DocumentFile {
        var doc = DocumentFile.fromTreeUri(context, getUri()!!)
        val parts = path.split("/")
        for (i in parts.indices) {
            val nextFile = doc?.findFile(parts[i])
            if(nextFile != null){
                doc = nextFile
            }
        }
        if (doc != null){
            return doc
        } else {
            throw Resources.NotFoundException("File not found")
        }
    }

    fun getFileOutputStream(): OutputStream? {
        val path = outputPath
        return try{
            FileOutputStream(path)
        } catch(e: IOException){
            val documentFile: DocumentFile = this.getDocumentFileByPath(path)
            val documentUri = documentFile.uri
            context.contentResolver.openOutputStream(documentUri)
        }
    }

    fun getFileInputStream(): InputStream? {
        val path = inputPath
        return try{
            FileInputStream(path)
        } catch(e: IOException){
            val documentFile: DocumentFile = this.getDocumentFileByPath(path)
            val documentUri = documentFile.uri
            context.contentResolver.openInputStream(documentUri)
        }
    }

    fun outputExists(): Boolean {
        return File(outputPath).exists()
    }
}