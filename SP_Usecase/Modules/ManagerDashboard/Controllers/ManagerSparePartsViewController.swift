//
//  ManagerSparePartsViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit
import ESPullToRefresh

class ManagerSparePartsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var managerSparePartsViewModel: ManagerSparePartsViewModel!
    @IBOutlet weak var managerSparePartsSearchView: UIView!
    @IBOutlet weak var managerSparePartsTableView: BaseTableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.managerSparePartsTableView.delegate = self
        self.managerSparePartsTableView.dataSource = self
        self.managerSparePartsTableView.estimatedRowHeight = 44.0
        self.managerSparePartsTableView.rowHeight = UITableView.automaticDimension
        self.managerSparePartsTableView.keyboardDismissMode = .onDrag
        self.managerSparePartsViewModel.delegate = self
        self.managerSparePartsViewModel.fetchSparePartsList()
        self.managerSparePartsTableView.es.addPullToRefresh {
            [unowned self] in
            self.managerSparePartsViewModel.fetchSparePartsList()
        }
        self.setupSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Spare Parts"
            tabController.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading(message: "Loading...")
        self.managerSparePartsViewModel.fetchSparePartsList()
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


// MARK: TableView Data source and Delegate

extension ManagerSparePartsViewController{
 
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.managerSparePartsViewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.managerSparePartsViewModel.cellForRowAtIndex(tableView, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.managerSparePartsViewModel.didSelectCellRowAtIndex(indexPath: indexPath)
    }
}


// MARK: Protocol Methods
extension ManagerSparePartsViewController: ManagerSparePartsProtocol {
    func reloadTableData() {
        self.hideLoading()
        self.managerSparePartsTableView.reloadData()
        self.managerSparePartsTableView.es.stopPullToRefresh()
    }
    
    func displaySuccess(message: String?) {
        self.showAlert(message: message)
    }
    
    func showLoading() {
        self.showLoading(message: "Loading...")
    }
}

// MARK: UISearchBarDelegate
extension ManagerSparePartsViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        self.searchBar.clearBackgroundColor()
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.delegate = self
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.processSearch), object: nil)
        perform(#selector(self.processSearch), with: nil, afterDelay: 0.5)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        guard let searchString = searchBar.text else { return }
        
        if searchString.count > 0 {
            self.processSearch()
        }
    }
    
    @objc private func processSearch() {
        guard let searchString = searchBar.text else {
            return
        }
        
        self.managerSparePartsViewModel.search(searchString)
    }
    
}
