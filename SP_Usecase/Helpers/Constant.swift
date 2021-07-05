//
//  Constant.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import Foundation

class Constant: NSObject {
    static let appName = "SP Technician"
    static let appBundleID = Bundle.main.bundleIdentifier ?? "com.ncs.sg.SP-Usecase"
    static let userDataService = appBundleID + ".userData"
    
    static let mapApiKey = "Gqfd0UiL7G5Yy80BWjB2xYP5AvG8dIvVIr5gHMBQtMLWZyfFEBeYw8+VOv6jRFrw";
    static let aesKeyString = "SPEncryptionKeyString"
    static let aesIVString = "encryptionSPDataIV"
    
    #if DEV
        //APIs
        static let assignementList = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/site-assignments"
        static let assignementListURL = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/assignments?filter=u001"
        static let assignementDetailsURL = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/site-assignments/S001"
        static let sparePartListURL = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/spareparts"
        static let sparePartReservationURL = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/spareparts-reservations"
        static let updateSiteAssignmentURL = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/site-assignments"
        static let updateSparePartPO = "https://jlrhjvj3ya.execute-api.ap-southeast-1.amazonaws.com/stage-v1/spareparts/purchase-order/"
    #else
        static let assignementList = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/site-assignments"
//        static var assignementListURL:String {
//            get{
//                if UserDataService.shared.userAttributeRole != UserModel.userRole.manager.rawValue{
//                    return Constant.assignementList + "?filter=" + UserDataService.shared.userAttributeEmailAddress
//                }else{
//                    return Constant.assignementList
//                }
//                
//            }
//        }
    
        static let assignementDetailsURL = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/site-assignments/"
        static let sparePartListURL = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/spareparts"
        static let sparePartReservationURL = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/spareparts-reservations"
        static let updateSiteAssignmentURL = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/site-assignments"
        static let updateSparePartPO = "https://o6dmiaiwz4.execute-api.ap-southeast-1.amazonaws.com/stage-v2/spareparts/purchase-order/"
        
        
    #endif
}

class MessageConstant{
    
    static let logout = "Are you sure want to logout?"
    static let inValidValue = "You have entered an invalid value."
    
    static let emptyInspectionRemark = "Please provide inspection remark."
    static let emptyResolutionRemark = "Please provide resolution remark."
    static let emptyUserName = "Please enter username."
    static let emptyPassword = "Please enter password."
    static let invalidPassword = "Your password should be a minimum of 8 characters, 1 number, 1 upper case, and 1 special character."
    
    static let poRasied = "Purchased order raised successfully to finance team."
}
