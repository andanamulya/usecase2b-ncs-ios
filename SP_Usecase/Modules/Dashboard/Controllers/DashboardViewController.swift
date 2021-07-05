//
//  DashboardViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

class DashboardViewController: BaseViewController {
    @IBOutlet var viewModel: DashboardViewModel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.text = "Username: " + UserDataService.shared.userName
        self.timeLabel.text = "Time: " + UserDataService.shared.timestamp
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
