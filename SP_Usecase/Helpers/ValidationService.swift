//
//  ValidationService.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

struct ValidationService{
    /// Validate Username
    /// - Parameter username: text string
    /// - Throws: ValidationError
    /// - Returns: validated username string
    func validateUsername(_ username:String?) throws -> String{
        guard let username = username else { throw
            ValidationError.usernameIsEmpty
        }
        guard !username.isEmpty else { throw
            ValidationError.usernameIsEmpty
        }
        
        return username
    }
    
    /// Validate Password
    /// - Parameter password: text string
    /// - Throws: ValidationError
    /// - Returns: validated password string
    func validatePassword(_ password:String?) throws -> String{
        guard let password = password else { throw
            ValidationError.passwordIsEmpty
        }
        guard !password.isEmpty else { throw
            ValidationError.passwordIsEmpty
        }
        
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        guard passPred.evaluate(with: password) else {
            throw ValidationError.passwordHasSpecialUpperLowerNumber
        }
        
        return password
    }
    
    /// Validate Inspection Remark
    /// - Parameter remark: text string
    /// - Throws: ValidationError
    /// - Returns: validated inspection string
    func validateInspectionRemark(_ remark:String?) throws -> String{
        guard let remark = remark else { throw
            ValidationError.inspectionRemarkIsEmpty
        }
        guard !remark.isEmpty else { throw
            ValidationError.inspectionRemarkIsEmpty
        }
        
        return remark
    }
    
    /// Validate Resolution Remark
    /// - Parameter remark: text string
    /// - Throws: ValidationError
    /// - Returns: validated resolution string
    func validateResolutionRemark(_ remark:String?) throws -> String{
        guard let remark = remark else { throw
            ValidationError.resolutionRemarkIsEmpty
        }
        guard !remark.isEmpty else { throw
            ValidationError.resolutionRemarkIsEmpty
        }
        
        return remark
    }
}

/// Custom Validation Error
enum ValidationError:LocalizedError {
    case invalidValue
    case inspectionRemarkIsEmpty
    case resolutionRemarkIsEmpty
    case usernameIsEmpty
    case passwordIsEmpty
    case passwordHasSpecialUpperLowerNumber
    
    var errorDescription: String?{
        switch self {
        case .invalidValue:
            return MessageConstant.inValidValue
        case .inspectionRemarkIsEmpty:
            return MessageConstant.emptyInspectionRemark
        case .resolutionRemarkIsEmpty:
            return MessageConstant.emptyResolutionRemark
        case .usernameIsEmpty:
            return MessageConstant.emptyUserName
        case .passwordIsEmpty:
            return MessageConstant.emptyPassword
        case .passwordHasSpecialUpperLowerNumber:
            return MessageConstant.invalidPassword
        }
    }
}

