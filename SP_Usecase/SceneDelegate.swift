//
//  SceneDelegate.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 28/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let main = UIStoryboard(name: "Main", bundle: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        if UserDataService.shared.isSignIn {
            if UserDataService.shared.userAttributeRole == UserModel.userRole.manager.rawValue{
                self.updateRootViewController(identifier: .managerNavigationDashboard)
            }else{
                self.updateRootViewController(identifier: .techNavigationDashboard)
            }
        }else{
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.signOut { success in }
                }
                self.updateRootViewController(identifier: .login)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.fetchCurrentAuthSession(completion: { (isSignedIn, userName, userId, accessToken, idToken) in
                DispatchQueue.main.async {
                    if isSignedIn {
                        UserDataService.shared.isSignIn = isSignedIn
                        UserDataService.shared.userAccessTokenData = accessToken ?? ""
                        UserDataService.shared.userIdTokenData = idToken ?? ""
                        UserDataService.shared.userName = userName ?? ""
                        UserDataService.shared.userId = userId ?? ""
                        appDelegate.fetchCurrentAuthenticatedUser { userData in
                            DispatchQueue.main.async {
                                if let _userData = userData {
                                    UserDataService.shared.userAttributeName = _userData.userAttributeName
                                    UserDataService.shared.userAttributeEmailAddress = _userData.userAttributeEmailAddress
                                    UserDataService.shared.userAttributeRole = _userData.userAttributeRole
                                    UserDataService.shared.userAttributeGivenName = _userData.userAttributeGivenName
                                    UserDataService.shared.userAttributePhoneNumber = _userData.userAttributePhoneNumber
                                    if UserDataService.shared.userAttributeRole == UserModel.userRole.manager.rawValue{
                                        self.updateRootViewController(identifier: .managerNavigationDashboard)
                                    }else{
                                        self.updateRootViewController(identifier: .techNavigationDashboard)
                                    }
                                }else{
                                    UserDataService.shared.clear()
                                    appDelegate.signOut { success in }
                                    self.updateRootViewController(identifier: .login)
                                }
                            }
                        }
                    }else{
                        UserDataService.shared.clear()
                        appDelegate.signOut { success in }
                        self.updateRootViewController(identifier: .login)
                    }
                }
            })
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    /// Update Root View Controller
    /// - Parameter vcName: View Controller Name
    func updateRootViewController(identifier:UIStoryboard.vcIndentifier){
        if let vc = UIStoryboard.loadFromMain(identifier.name) as? UIViewController{
            self.window?.rootViewController =  vc
        }
        self.window?.makeKeyAndVisible()
    }
}

