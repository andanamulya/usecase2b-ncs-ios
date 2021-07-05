//
//  UserDataService.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import Foundation
import KeychainAccess

/// User data class using Keychain to store user information
class UserDataService: NSObject{
    private var userService: Keychain
    static let shared = UserDataService()
    
    /// Varialble to save the user login status
    var isSignIn:Bool {
        set{
            self.userService["isSignIn"] = newValue ? "true" : "false"
        }
        get{
            let stringValue = self.userService["isSignIn"]
            return stringValue == "true" ? true : false
        }
    }
    
    /// Varialble to save the access Token
    var userAccessTokenData:String {
        set{
            self.userService["accessToken"] = newValue
        }
        get{
            return self.userService["accessToken"] ?? ""
        }
    }
    
    /// Varialble to save the ID Token
    var userIdTokenData:String {
        set{
            self.userService["idToken"] = newValue
        }
        get{
            return self.userService["idToken"] ?? ""
        }
    }
    
    /// Varialble to save the username
    var userName:String {
        set{
            self.userService["username"] = newValue
        }
        get{
            return self.userService["username"] ?? ""
        }
    }
    
    /// Varialble to save the user id
    var userId:String {
        set{
            self.userService["userId"] = newValue
        }
        get{
            return self.userService["userId"] ?? ""
        }
    }
    
    /// Varialble to save the email address
    var userAttributeEmailAddress:String {
        set{
            self.userService["userAttributeEmailAddress"] = newValue
        }
        get{
            return self.userService["userAttributeEmailAddress"] ?? ""
        }
    }
    
    /// Varialble to save the altribute name
    var userAttributeName:String {
        set{
            self.userService["userAttributeName"] = newValue
        }
        get{
            return self.userService["userAttributeName"] ?? ""
        }
    }
    
    /// Varialble to save the Role
    var userAttributeRole:String {
        set{
            self.userService["userAttributeRole"] = newValue
        }
        get{
            return self.userService["userAttributeRole"] ?? ""
        }
    }
    
    /// Varialble to save the Given Name
    var userAttributeGivenName:String {
        set{
            self.userService["userAttributeGivenName"] = newValue
        }
        get{
            return self.userService["userAttributeGivenName"] ?? ""
        }
    }
    
    /// Varialble to save the Given Name
    var userAttributePhoneNumber:String {
        set{
            self.userService["userAttributePhoneNumber"] = newValue
        }
        get{
            return self.userService["userAttributePhoneNumber"] ?? ""
        }
    }
    
    /// Varialble to save the timestamp
    var timestamp:String {
        set{
            self.userService["timestamp"] = newValue
        }
        get{
            return self.userService["timestamp"] ?? ""
        }
    }
    
    private override init(){
        self.userService = Keychain(service: Constant.userDataService)
    }
    
    /// Clear User Data
    func clear(){
        self.isSignIn = false
        self.userAccessTokenData = ""
        self.userIdTokenData = ""
        self.userName = ""
        self.userId = ""
        self.userAttributeEmailAddress = ""
        self.userAttributeName = ""
        self.userAttributeRole = ""
        self.userAttributeGivenName = ""
        self.userAttributePhoneNumber = ""
        self.timestamp = ""
    }
}
