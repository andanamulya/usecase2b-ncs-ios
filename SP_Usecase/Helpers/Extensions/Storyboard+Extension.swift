//
//  Storyboard+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

extension UIStoryboard {
    /// Storyboard ViewController Identifier
    enum vcIndentifier{
        case login
        case loginNavigation
        case dashboard
        case techDashboard
        case managerDashboard
        case techNavigationDashboard
        case managerNavigationDashboard
        
        var name:String?{
            switch self {
            case .login:
                return "LoginViewController"
            case .loginNavigation:
                return "LoginNavigationController"
            case .dashboard:
                return "DashboardViewController"
            case .techDashboard:
                return "TechnicianDashboardViewController"
            case .managerDashboard:
                return "ManagerDashboardViewController"
            case .techNavigationDashboard:
                return "TechnicianDashboardNavigationController"
            case .managerNavigationDashboard:
                return "ManagerDashboardNavigationController"
            }
            
        }
    }
    
    /// Static class function to retrieve the view controller from specific storyboard (Main)
    /// - Parameter identifier: View Controller Identifier
    /// - Returns: ViewController or Navigation Controller
    static func loadFromMain(_ identifier: String? = nil) -> Any {
        return load(from: "Main", identifier: identifier)
    }
}

fileprivate extension UIStoryboard {
    /// Static class function to retrieve the view controller from any storyboard
    /// - Parameters:
    ///   - storyboard: Storyboard name
    ///   - identifier: View Controller Identifier
    /// - Returns: View Controller or Navigation Controller
    static func load(from storyboard: String, identifier: String?) -> Any {
        let uiStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        if let identifier = identifier{
            return uiStoryboard.instantiateViewController(withIdentifier: identifier)
        }else{
            return uiStoryboard.instantiateInitialViewController()!
        }
    }
}
