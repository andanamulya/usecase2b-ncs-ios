//
//  SparePartServiceManager.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 1/7/21.
//

import Foundation
import Alamofire
import ObjectMapper

class SparePartListResponse: NetworkReponse<SparePartModel> {
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["sparePartsList"]
    }
}

class ReservationSpartPartsResponse: BaseModel {
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
class SparePartServiceManager: NSObject {
    
    class func getSparePartList(successHandler:@escaping(([SparePartModel]) -> Void), _ failureHandler:@escaping((Any?) -> Void)){
        let finalURL = Constant.sparePartListURL
      let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: finalURL, method: .get, parameters: nil, headers: header, encoding: URLEncoding.default, success: { (response) in
            guard let responseData = response,
                let serviceResponse = SparePartListResponse(JSON: responseData),
                let data = serviceResponse.data else{
                    failureHandler(NetworkManager.ResponseErrorType.Generic)
                    return
            }
            successHandler(data)
            
        }, failure: { (error) in
            
        })
    }
    
    class func submitSparePartReservation(parameters:Parameters, successHandler:@escaping((String?) -> Void), _ failureHandler:@escaping((Any?) -> Void)){
      let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: Constant.sparePartReservationURL, method: .post, parameters: parameters, headers: header, encoding: JSONEncoding.default, success: { (response) in
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
    
    
    
    class func updateSparePartPO(sparePartId:String, successHandler:@escaping(() -> Void), _ failureHandler:@escaping((Any?) -> Void)){
        
        let finalURL = Constant.updateSparePartPO + sparePartId
        let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDataService.shared.userIdTokenData)])
        _ = NetworkManager.shared.requestJson(url: finalURL, method: .put, parameters: nil, headers: header, encoding: URLEncoding.default, success: { (response) in
            successHandler()
            
        }, failure: { (error) in
            
        })
    }
}
