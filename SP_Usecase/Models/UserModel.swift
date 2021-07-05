//
//  UserModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import Foundation

import UIKit
import ObjectMapper

class UserModel: BaseModel {
    enum userRole:String{
        case manager = "Manager"
        case technician = "Technician"
    }
    @objc dynamic var userAttributeName:String = ""
    @objc dynamic var userAttributeGivenName:String = ""
    @objc dynamic var userAttributeEmailAddress:String = ""
    @objc dynamic var userAttributeRole:String = ""
    @objc dynamic var userAttributePhoneNumber:String = ""
    
    required convenience init?(name:String, givenName:String, email:String, role:String, phone:String) {
        self.init()
        self.userAttributeName = name;
        self.userAttributeGivenName = givenName;
        self.userAttributeEmailAddress = email;
        self.userAttributeRole = role;
        self.userAttributePhoneNumber = phone;
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.userAttributeName <- map["name"]
        self.userAttributeGivenName <- map["givenName"]
        self.userAttributeEmailAddress <- map["email"]
        self.userAttributeRole <- map["role"]
        self.userAttributePhoneNumber <- map["phone"]
    }
}
