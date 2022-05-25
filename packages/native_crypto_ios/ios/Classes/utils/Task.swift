//
//  Task.swift
//  native_crypto_ios
//
//  Created by Hugo Pointcheval on 25/05/2022.
//

import Foundation

class Task<T> {
    
    var task: () throws -> T
    private var successful: Bool = false
    private var result: T? = nil
    private var exception: Error? = nil
    
    init(task: @escaping () throws -> T) {
        self.task = task
    }
    
    func isSuccessful() -> Bool {
        return successful
    }
    
    func getResult() -> T? {
        return result
    }
    
    func getException() -> Error {
        if (exception != nil) {
            return exception!
        } else {
            return NativeCryptoError.exceptionError
        }
    }
    
    func call() {
        do {
            result = try task()
            exception = nil
            successful = true
        } catch {
            exception = error
            result = nil
            successful = false
        }
    }
    
    func finalize(callback: (_ task: Task<T>) -> Void) {
        callback(self)
    }
}
