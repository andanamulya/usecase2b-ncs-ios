//
//  Data+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//


import Foundation
import CommonCrypto

extension Data{
    func aesDataEncryption( keyData: Data, ivData: Data, operation: Int) -> Data {
        let dataLength = self.count
        let cryptLength  = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)
        var numBytesEncrypted :size_t = 0
        let cryptStatus = cryptData.withUnsafeMutableBytes { (cryptBytes:UnsafeMutableRawBufferPointer) in
            self.withUnsafeBytes({ (dataBytes:UnsafeRawBufferPointer) in
                ivData.withUnsafeBytes({ (ivBytes:UnsafeRawBufferPointer) in
                    keyData.withUnsafeBytes({ (keyBytes:UnsafeRawBufferPointer) in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes.baseAddress?.assumingMemoryBound(to: UInt32.self), keyLength,
                                ivBytes.baseAddress?.assumingMemoryBound(to: UInt32.self),
                                dataBytes.baseAddress?.assumingMemoryBound(to: UInt32.self), dataLength,
                                cryptBytes.baseAddress?.assumingMemoryBound(to: UInt32.self), cryptLength,
                                &numBytesEncrypted)
                    })
                })
            })
        }
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        }
        return cryptData;
    }
}

