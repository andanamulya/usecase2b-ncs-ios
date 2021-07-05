//
//  BaseViewController.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 27/6/21.
//


import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

/// Base parent view controller, all the controler can inherit from base view controller
class BaseViewController: UIViewController,NVActivityIndicatorViewable {
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var hasKeyboardSupport:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        if hasKeyboardSupport {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        if hasKeyboardSupport {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewController{
    
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
    
    func showLoading(message:String){
        let size = CGSize(width: 30, height: 30)
        let indicatorType = presentingIndicatorTypes[16]
        self.startAnimating(size, message: message, type: indicatorType, fadeInAnimation: nil)
    }
    func hideLoading(){
        self.stopAnimating()
    }
}

extension BaseViewController{
    /// Keyboard will show notification
    /// - Parameter notification: notification center data
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo, let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - view.safeAreaInsets.bottom
            if let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
               let rawAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve.uint32Value << 16))
                self.updateKeyboardConstraints(keyboardHeight: keyboardHeight)
                UIView.animate(withDuration: animationDuration.doubleValue, delay: 0.0, options: [.beginFromCurrentState,animationCurve], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    /// Keyboard will hide notification
    /// - Parameter notification: notification center data
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardHeight = 0.0
            if let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
               let rawAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve.uint32Value << 16))
                self.updateKeyboardConstraints(keyboardHeight: CGFloat(keyboardHeight))
                UIView.animate(withDuration: animationDuration.doubleValue, delay: 0.0, options: [.beginFromCurrentState,animationCurve], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func updateKeyboardConstraints(keyboardHeight:CGFloat){
    }
}
