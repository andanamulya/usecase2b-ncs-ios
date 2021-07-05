//
//  LoginViewController.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 28/6/21.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet var viewModel: LoginViewModel!
    @IBOutlet weak var headerView: BaseView!
    @IBOutlet weak var contentWrapper: BaseView!
    @IBOutlet weak var emailAddressTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        self.hasKeyboardSupport = true;
        super.viewDidLoad()
        self.viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.hasSeparator = false
        self.tableView.clearTableFooterView()
        self.headerView.bounds = self.contentWrapper.bounds
        self.tableView.tableHeaderView = self.headerView
    }
    
}

extension LoginViewController:LoginViewModelDelegate {
    func navigateToViewController(identifier: UIStoryboard.vcIndentifier) {
        DispatchQueue.main.async {
            self.hideLoading()
            if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                delegate.updateRootViewController(identifier:identifier)
            }
        }
    }
    func displayError(errorString: String) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showAlert(message: errorString)
        }
    }
}
/// Actions
extension LoginViewController {
    @IBAction func loginButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.showLoading(message: "Authenticating...")
        self.viewModel.signIn(username: self.emailAddressTextfield.text ?? "", password: self.passwordTextfield.text ?? "")
    }
    
    override func updateKeyboardConstraints(keyboardHeight:CGFloat){
        self.tableViewBottomConstraint.constant = keyboardHeight
        let contentBounds = self.contentWrapper.bounds
        self.headerView.frame = CGRect.init(x: contentBounds.origin.x, y: contentBounds.origin.y, width: contentBounds.size.width, height: contentBounds.size.height - keyboardHeight)
        self.tableView.tableHeaderView = self.headerView
    }
}
