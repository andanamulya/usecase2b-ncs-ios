//
//  ManagerDashboardViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

class ManagerDashboardViewController: BaseTabBarController {
    
 
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// Logout Action Button
    /// - Parameter sender: Button Action Sender
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.showAlert(message: MessageConstant.logout, actionHandler:  { action in
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.signOut { status in
                        DispatchQueue.main.async {
                            if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                delegate.updateRootViewController(identifier:.login)
                            }
                        }
                    }
                }
            }
        })
    }
}
