//
//  BaseTabBarController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.overrideUserInterfaceStyle = .light
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

extension BaseTabBarController {
    
    func showAlert(title: String = Constant.appName, message: String?, actionTitle:String? = "OK", cancelTitle:String? = "Cancel", actionHandler:((UIAlertAction) -> Void)? = nil, cancelActionHandler:((UIAlertAction) -> Void)? = nil ){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.overrideUserInterfaceStyle = .light
                if let actionText = actionTitle{
                    let okAction = UIAlertAction(title: actionText, style: .default, handler: actionHandler)
                    alert.addAction(okAction)
                }
                
                if let cancelActionText = cancelTitle{
                    let cancelAction = UIAlertAction(title: cancelActionText, style: .cancel, handler: cancelActionHandler)
                    alert.addAction(cancelAction)
                }
                //Show Alert in top of the view controller.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String = Constant.appName, message: String?, action:UIAlertAction? = nil, cancelAction:UIAlertAction? = nil){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.overrideUserInterfaceStyle = .light
            if let cancelAction = cancelAction{
                alert.addAction(cancelAction)
            }else{
                let closeAction = UIAlertAction(title: "OK", style: .cancel) { alert in
                }
                alert.addAction(closeAction)
            }
            
            if let action = action{
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
