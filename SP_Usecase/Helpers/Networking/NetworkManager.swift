//
//  NetworkManager.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 27/6/21.
//

import Foundation
import Alamofire
import ObjectMapper

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    static let serviceTimeOut  = 30
    
    enum ResponseErrorType:String {
        case TimeOut = "Network connection error. Please try again later."
        case Generic = "Oops, something went wrong. Please try again later."
        case System = "System error. Please try again"
    }

    let manager:Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(NetworkManager.serviceTimeOut)
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = nil;
        
        let manager  = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    /// This Method is used to call web service request.
    ///
    /// - Parameters:
    ///   - url: Web Service Name
    ///   - method: methods type (.get/.post/...)
    ///   - parameters: parameters in [String: Any]
    ///   - successHandler: call successHandler when get success response
    ///   - failureHandler: if any error call failureHandler
    public func requestJson(url: String,
                        method: HTTPMethod = .post,
                        parameters: Parameters? = nil,
                        headers: HTTPHeaders? = nil,
                        encoding: ParameterEncoding? = URLEncoding.default,
                        success: @escaping((Parameters?) -> Void),
                        failure: @escaping((Any?) -> Void) ) -> DataRequest{
        
        
        //headers?.add(HTTPHeader)setValue(UserDataService.shared.userIdTokenData, forHTTPHeaderField:"Authorization")
        
        let manager  = NetworkManager.shared.manager
        return manager.request(url, method: method, parameters: parameters,encoding:encoding!, headers:headers).responseJSON { (response) in
            switch (response.result) {
            case let .success(result):
                if let json = result as? Parameters{
                    success(json);
                }else if let jsonArray = result as? [Parameters]{
                    success(["value":jsonArray]);
                }else{
                    failure(NetworkManager.ResponseErrorType.Generic)
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    failure(NetworkManager.ResponseErrorType.TimeOut)
                }else{
                    failure(NetworkManager.ResponseErrorType.Generic)
                }
                break
            }
        }
    }
    
}

class NetworkReponse<T:Mappable>: Mappable {
    var data : [T]?
    var dataDic : T?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) { }
}
