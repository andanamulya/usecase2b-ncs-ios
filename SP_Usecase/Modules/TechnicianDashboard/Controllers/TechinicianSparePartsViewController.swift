//
//  TechinicianSparePartsViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

class TechinicianSparePartsViewController: BaseViewController {
    @IBOutlet var viewModel: TechinicianSparePartsViewModel!
    @IBOutlet fileprivate weak var tableView: BaseTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self;
        self.viewModel.delegate = self;
        self.setupTableView()
        self.setupRightNavigationMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading(message: "Loading...")
        self.viewModel.processData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTableView(){
        self.tableView.hasSeparator = true
        self.tableView.estimatedRowHeight = 58
        self.tableView.clearTableFooterView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
    }
    private func setupRightNavigationMenu(){
        let rightButton = UIButton(frame: CGRect(x:0,y:0,width:24,height:24))
        rightButton.setTitle("Submit", for: .normal)
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
        if segue.identifier == "selectedSparePartSeque"{
            if let destination = segue.destination as? TechinicianSelectedSparePartsViewController{
                destination.viewModel.formData = self.viewModel.formData
            }
        }
    }
}

//TableView Delegate and Datasource
extension TechinicianSparePartsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.viewModel.cellForRowAt(tableView, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

extension TechinicianSparePartsViewController:TechinicianSparePartsTableViewCellDelegate{
    func didQuantityUpdate(tableViewCell: TechinicianSparePartsTableViewCell, action:CounterView.action, quantity: Int) {
        if let indexPath = self.tableView.indexPath(for: tableViewCell){
            self.viewModel.updateSparePartQuantity(indexPath:indexPath, quantity:quantity)
            if quantity > 0 {
                self.tableView.reloadRows(at: [indexPath], with: action == .plus ? .top : .bottom)
            }
        }
    }
}

//Actions
extension TechinicianSparePartsViewController{
    
    /// Next/Submit Action Button
    /// - Parameter sender: Button Action Sender
    @objc func nextSubmitButtonAction(_ sender:Any) {
        self.showLoading(message: "Submitting...")
        self.viewModel.submitInspectionForm()
    }
}

//UISearchBarDelegate
extension TechinicianSparePartsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //code
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(processSearch), object: nil)
        perform(#selector(processSearch), with: nil, afterDelay: 0.5)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         //code
    }
    
    @objc private func processSearch() {
        guard let searchText = self.searchBar.text else {
            return
        }
        self.viewModel.searchKeyword(searchText)
    }
}

//TechinicianSparePartsViewModelDelegate
extension TechinicianSparePartsViewController:TechinicianSparePartsViewModelDelegate{
    func reloadTableData() {
        self.hideLoading()
        self.tableView.reloadData()
    }
    func displaySuccess(message: String?) {
        self.hideLoading()
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers{
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        //self.navigationController?.popToRootViewController(animated: true)
    }
}
