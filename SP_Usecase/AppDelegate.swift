//
//  AppDelegate.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 28/6/21.
//

import UIKit
import Amplify
import GoogleMaps
import AWSPluginsCore
import AWSCognitoAuthPlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            self.userStatusListener();
        } catch {
            
        }
        
        //GoogleMap Configuration
        GMSServices.provideAPIKey(Constant.mapApiKey.decrypt() ?? "")
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// Retrieve user authentication data
    /// - Parameter completion: (isSignin, accessToken, idToken) - session status, access token and id token from user authentication data
    func fetchCurrentAuthSession(completion:@escaping((_ isSignin: Bool, _ userName:String?, _ userId:String?, _ accessToken: String?,_ idToken: String?) -> Void)) {
        _ = Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()
                if session.isSignedIn {
                    if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                        let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                        let currentUser = Amplify.Auth.getCurrentUser()
                        completion(session.isSignedIn, currentUser?.username, currentUser?.userId, tokens.accessToken,tokens.idToken)
                        return
                    }
                }
                completion(false, nil, nil, nil, nil)
            } catch {
                completion(false, nil, nil, nil, nil)
            }
        }
    }
    
    /// Retrieve authenticated user data
    /// - Parameter completion: completion with user attributed data
    func fetchCurrentAuthenticatedUser(completion:@escaping((_ userData: UserModel?) -> Void)){
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                let userData = UserModel.init()
                for attribute in attributes {
                    switch attribute.key {
                    case .name:
                        userData.userAttributeName = attribute.value
                    case .email:
                        userData.userAttributeEmailAddress = attribute.value
                    case .custom("role"):
                        userData.userAttributeRole = attribute.value
                    case .phoneNumber:
                        userData.userAttributePhoneNumber = attribute.value
                    case .givenName:
                        userData.userAttributeGivenName = attribute.value
                    default: break
                    }
                }
                completion(userData)
                break;
            case .failure(_):
                completion(nil)
                break;
            }
        }
    }
    
    /// Authenticaftion Listener
    func userStatusListener(){
        _ = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                // Update UI
                break;
            case HubPayload.EventName.Auth.sessionExpired:
                // Re-authenticate the user
                UserDataService.shared.clear()
                DispatchQueue.main.async {
                    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        self.signOut { success in }
                        delegate.updateRootViewController(identifier:.login)
                    }
                }
                break;
            case HubPayload.EventName.Auth.signedOut:
                UserDataService.shared.clear()
                DispatchQueue.main.async {
                    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        self.signOut { success in }
                        delegate.updateRootViewController(identifier:.login)
                    }
                }
                // Update UI
            default:
                break;
            }
        }
    }
    
    /// User signout
    /// - Parameter completion: Bool - signout status
    func signOut(completion:@escaping((Bool)->Void)) {
        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
            switch result {
            case .success:
                UserDataService.shared.clear()
                completion(true);
            case .failure(_):
                completion(false);
            }
        }
    }
}

