//
//  String+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import CommonCrypto

extension String{
    func encrypt() -> String?{
        let data = self.data(using:String.Encoding.utf8)!
        let keyData = Constant.aesKeyString.data(using: .utf8)!
        let ivData = Constant.aesIVString.data(using: .utf8)!
        let eData = data.aesDataEncryption(keyData: keyData, ivData: ivData, operation: kCCEncrypt)
        return eData.base64EncodedString()
    }

    func decrypt() -> String?{
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        let keyData = Constant.aesKeyString.data(using: .utf8)!
        let ivData = Constant.aesIVString.data(using: .utf8)!
        let dData = data.aesDataEncryption(keyData: keyData, ivData: ivData, operation: kCCDecrypt)
        return String(bytes:dData, encoding:String.Encoding.utf8)!
    }
}

