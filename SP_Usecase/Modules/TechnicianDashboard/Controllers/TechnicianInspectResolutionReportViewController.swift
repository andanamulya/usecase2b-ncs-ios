//
//  TechnicianResolutionReportViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

class TechnicianInspectResolutionReportViewController: BaseViewController {
    
    @IBOutlet weak var viewModel: TechnicianInspectResolutionReportViewModel!
    
    @IBOutlet fileprivate weak var headerView: BaseView!
    @IBOutlet fileprivate weak var tableView: BaseTableView!
    @IBOutlet fileprivate weak var contentWrapper: BaseView!
    @IBOutlet fileprivate weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var switchButton: UISwitch!
    @IBOutlet fileprivate weak var switchButtonViewWrapper: BaseView!
    @IBOutlet fileprivate weak var remarkTextView: BaseTextView!
    @IBOutlet fileprivate weak var switchButtonViewWrapperHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        self.hasKeyboardSupport = true;
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel.delegate = self
        self.remarkTextView.delegate = self
        self.navigationItem.title = self.viewModel.getPageTitle();
        if !self.viewModel.checkJobStatusCompleted(){
            if self.viewModel.checkJobStatusInspection(){
                var title = "Submit";
                if switchButton.isOn {
                    title = self.viewModel.getRightNavigationTitle()
                }
                self.updateRightNavigationTitleButton(title)
                self.hideSwitchWrapper(false)
            }else{
                self.hideSwitchWrapper(true)
                self.updateRightNavigationTitleButton(self.viewModel.getRightNavigationTitle())
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTableView()
        self.remarkTextView.becomeFirstResponder()
    }
    
    private func hideSwitchWrapper(_ hide:Bool){
        if hide{
            self.switchButtonViewWrapper.isUserInteractionEnabled = false
            self.switchButton.isUserInteractionEnabled = false
            self.switchButtonViewWrapperHeightConstant.constant = 0
        }else{
            self.switchButtonViewWrapperHeightConstant.constant = 30
            self.switchButtonViewWrapper.isUserInteractionEnabled = true
            self.switchButton.isUserInteractionEnabled = true
        }
        self.switchButton.isHidden = hide
        self.switchButtonViewWrapper.isHidden = hide
    }
    private func setupTableView(){
        self.tableView.hasSeparator = false
        self.tableView.clearTableFooterView()
        self.headerView.bounds = self.contentWrapper.bounds
        self.tableView.tableHeaderView = self.headerView
    }
    
    private func updateRightNavigationTitleButton(_ title:String){
        let rightButton = UIButton(frame: CGRect(x:0,y:0,width:24,height:24))
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(UIColor.custom.navigationItemTitle.colorValue, for: .normal)
        rightButton.adjustsImageWhenHighlighted = false
        rightButton.addTarget(self, action: #selector(nextSubmitButtonAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightButton)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sparePartSeque"{
            if let destination = segue.destination as? TechinicianSparePartsViewController{
                destination.viewModel.formData = self.viewModel.formData
                destination.viewModel.data = self.viewModel.data
            }
        }
    }

}

/// Actions
extension TechnicianInspectResolutionReportViewController {
    override func updateKeyboardConstraints(keyboardHeight:CGFloat){
        self.tableViewBottomConstraint.constant = keyboardHeight
        let contentBounds = self.contentWrapper.bounds
        self.headerView.frame = CGRect.init(x: contentBounds.origin.x, y: contentBounds.origin.y, width: contentBounds.size.width, height: contentBounds.size.height - keyboardHeight)
        self.tableView.tableHeaderView = self.headerView
    }
    
    /// Next/Submit Action Button
    /// - Parameter sender: Button Action Sender
    @objc func nextSubmitButtonAction(_ sender:Any) {
        if self.viewModel.checkJobStatusToFix(){
            self.view.endEditing(true)
            self.showLoading(message: "Submitting...")
            self.viewModel.submitResolutionForm()
        }else if self.viewModel.checkJobStatusInspection(){
            if switchButton.isOn {
                if self.viewModel.processInspectionRemarValidation(){
                    self.performSegue(withIdentifier: "sparePartSeque", sender:nil)
                }
            }else{
                self.view.endEditing(true)
                self.showLoading(message: "Submitting...")
                self.viewModel.submitInspectionForm()
            }
        }
    }
    
    /// Switch button to check if  there are tech issue
    /// - Parameter sender: Any sender data
    @IBAction func switchButtonAction(_ sender: Any) {
        if self.viewModel.checkJobStatusInspection(){
            var title = "Submit";
            if switchButton.isOn {
                title = self.viewModel.getRightNavigationTitle()
            }
            self.updateRightNavigationTitleButton(title)
        }
    }
}
extension TechnicianInspectResolutionReportViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textFieldText: NSString = (textView.text ?? "") as NSString
        let newString = textFieldText.replacingCharacters(in: range, with: text)
        self.viewModel.updateRemarkValue(newString)
        return true
    }
}

extension TechnicianInspectResolutionReportViewController:TechnicianInspectResolutionReportViewModelDelegate{
    func displayError(errorString: String) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showAlert(message: errorString)
        }
    }
    func displaySuccess(message: String?) {
        self.hideLoading()
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
}
