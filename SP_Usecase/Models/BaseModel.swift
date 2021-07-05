//
//  BaseModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import ObjectMapper

class BaseModel: Mappable{
    @objc dynamic var identifier:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.identifier <- map["identifier"]
    }
}
