//
//  LoginViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 28/6/21.
//

import UIKit
import Amplify
import AWSPluginsCore
import AWSCognitoAuthPlugin


protocol LoginViewModelDelegate: BaseProtocol {}

class LoginViewModel:BaseViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    /// User signIn process
    /// - Parameters:
    ///   - username: text
    ///   - password: text
    func signIn(username: String, password: String) {
        let validation = ValidationService()
        do {
            let validatedUsername = try validation.validateUsername(username)
            let validatedPassword = try validation.validatePassword(password)
            Amplify.Auth.signIn(username: validatedUsername, password: validatedPassword) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                            appDelegate.fetchCurrentAuthSession(completion: { (isSignedIn, userName, userId, accessToken, idToken) in
                                UserDataService.shared.isSignIn = isSignedIn
                                UserDataService.shared.userAccessTokenData = accessToken ?? ""
                                UserDataService.shared.userIdTokenData = idToken ?? ""
                                UserDataService.shared.userName = userName ?? ""
                                UserDataService.shared.userId = userId ?? ""
                                appDelegate.fetchCurrentAuthenticatedUser { userData in
                                    if let _userData = userData {
                                        UserDataService.shared.userAttributeName = _userData.userAttributeName
                                        UserDataService.shared.userAttributeEmailAddress = _userData.userAttributeEmailAddress
                                        UserDataService.shared.userAttributeRole = _userData.userAttributeRole
                                        UserDataService.shared.userAttributeGivenName = _userData.userAttributeGivenName
                                        UserDataService.shared.userAttributePhoneNumber = _userData.userAttributePhoneNumber
                                        if let weakSelf = self,let delegate = weakSelf.delegate {
                                            if UserDataService.shared.userAttributeRole == UserModel.userRole.manager.rawValue{
                                                delegate.navigateToViewController(identifier: .managerNavigationDashboard)
                                            }else{
                                                delegate.navigateToViewController(identifier: .techNavigationDashboard)
                                            }
                                        }
                                    }else{
                                        if let weakSelf = self,let delegate = weakSelf.delegate {
                                            UserDataService.shared.clear()
                                            delegate.displayError(errorString: "Unable to retrieve user data.")
                                        }
                                    }
                                }
                            })
                        }
                    }
                    break;
                case .failure(let error):
                    if let weakSelf = self,let delegate = weakSelf.delegate {
                        delegate.displayError(errorString: error.errorDescription)
                    }
                }
            }
        }catch {
            if let error = error as? ValidationError {
                if let delegate = self.delegate {
                    delegate.displayError(errorString: error.errorDescription!)
                }
            }
        }
    }

}
