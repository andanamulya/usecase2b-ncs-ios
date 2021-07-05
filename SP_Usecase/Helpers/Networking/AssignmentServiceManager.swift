//
//  AssignmentServiceManager.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 1/7/21.
//

import Foundation
import Alamofire
import ObjectMapper

class AssignmentListResponse: NetworkReponse<AssignmentModel> {
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["assignmentList"]
    }
}

class AssignmentDetailsListResponse: NetworkReponse<AssignmentModel> {
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["assignmentDetailList"]
    }
}

class SubmitAssignmentResponse: BaseModel {
    @objc dynamic var message:String = ""
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        //Object Mapping
        super.mapping(map: map)
        message <- map["message"]
    }
}

class AssignmentServiceManager: NSObject {
    class func getAssignentsList(successHandler:@escaping(([AssignmentModel]) -> Void), _ failureHandler:@escaping((Any?) -> Void)){
        //let finalURL = Constant.assignementList + "?filter=" + UserDataService.shared.userAttributeEmailAddress
        //let finalURL = Constant.assignementList
        
      let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: Constant.assignementList, method: .get, parameters: nil, headers: header, encoding: URLEncoding.default, success: { (response) in
            guard let responseData = response,
                let serviceResponse = AssignmentListResponse(JSON: responseData),
                let data = serviceResponse.data else{
                
                failureHandler(NetworkManager.ResponseErrorType.Generic)
                    return
            }
            successHandler(data)
        }, failure: { (error) in
            
        })
    }
    
    class func getAssignentsDetailList(assignmentId:String, successHandler:@escaping(([AssignmentModel]) -> Void), _ failureHandler:@escaping((Any?) -> Void)){
        
        var finalURL = Constant.assignementDetailsURL
        #if DEV
        
        #else
        finalURL = finalURL + assignmentId
        #endif
        
        let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: finalURL, method: .get, parameters: nil, headers: header, encoding: URLEncoding.default, success: { (response) in
            
            guard let responseData = response,
                let serviceResponse = AssignmentDetailsListResponse(JSON: responseData),
                let data = serviceResponse.data else{
                    failureHandler(NetworkManager.ResponseErrorType.Generic)
                    return
            }
            successHandler(data)
            
        }, failure: { (error) in
            failureHandler(NetworkManager.ResponseErrorType.Generic)
        })
    }
    
    class func submitAssignment(parameters:Parameters, successHandler:@escaping((String?) -> Void), _ failureHandler:@escaping((Any?) -> Void)){
      let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: Constant.updateSiteAssignmentURL, method: .put, parameters: parameters, headers: header, encoding: JSONEncoding.default, success: { (response) in
            debugPrint("Reponse:\(String(describing: response))")
            guard let responseData = response,
                let serviceResponse = ReservationSpartPartsResponse(JSON: responseData) else{
                    failureHandler(NetworkManager.ResponseErrorType.Generic)
                    return
            }
            successHandler(serviceResponse.message)
        }, failure: { (error) in
            failureHandler(NetworkManager.ResponseErrorType.Generic)
        })
    }
}
