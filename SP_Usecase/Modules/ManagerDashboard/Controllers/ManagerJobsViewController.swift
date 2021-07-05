//
//  ManagerJobsViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit
import GoogleMaps
import ESPullToRefresh

class ManagerJobsViewController: BaseViewController {
    
    @IBOutlet var managerJobsViewModel: ManagerJobsViewModel!
    //var managerJobsViewModel:ManagerJobsViewModel!
    
    @IBOutlet weak var managerJobsTableView: BaseTableView!
    
    @IBOutlet weak var mapViewWrapper: BaseView!
    @IBOutlet weak var managerJobsSearchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapViewWrapperHeighContraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: BadgedButton!
    
    @IBOutlet weak var mapView: BaseMapView!
    
    fileprivate var isVisibleTableView = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        //Setup Tableview
        self.setupTableView()
        self.mapViewWrapper.isHidden = true
        
        self.managerJobsViewModel.delegate = self
        
        self.setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //download the data
        self.showLoading(message: "Loading...")
        self.managerJobsViewModel.fetchAssignmentList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Jobs"
            let rightButton = UIButton(frame: CGRect(x:0,y:0,width:24,height:24))
            rightButton.backgroundColor = .clear
            rightButton.adjustsImageWhenHighlighted = false
            rightButton.addTarget(self, action: #selector(mapBarButtonAction), for: .touchUpInside)
            tabController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightButton)
            
            if self.isVisibleTableView{
                rightButton.setImage(UIImage(systemName: "map"), for: .normal)
            }else{
                rightButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "siteActiveDetailsSegue"{
            if let destination = segue.destination as? TechnicianSiteDetailsViewController{
                if let siteData = sender as? AssignmentModel {
                    destination.viewModel.data = siteData
                }
            }
        } else if segue.identifier == "managerJobsFilterSegue" {
            if let destination = segue.destination as? ManagerJobsFilterViewController {
                destination.assignmentsData = managerJobsViewModel.assignmentsData
                destination.delegate = self
                destination.emailSelected = managerJobsViewModel.currentAsigneeEmails
                destination.statusSelected = managerJobsViewModel.currentStatus
            }
        }
    }
    
    @objc func mapBarButtonAction() {
        self.isVisibleTableView = !self.isVisibleTableView
        self.view.endEditing(true)
        let rootView = (self.navigationController?.view!)
        
        UIView.transition(with: rootView!, duration: 0.5, options: .transitionFlipFromRight, animations: {
        }) { [weak self] (b) in
            if let weakSelf = self, b {
                
                if weakSelf.isVisibleTableView{
                    weakSelf.managerJobsTableView.isHidden = false
                    weakSelf.mapViewWrapper.isHidden = true
                    weakSelf.filterButton.isHidden = false
                    weakSelf.mapViewWrapperHeighContraint.constant = 60
                }
                else
                {
                    weakSelf.managerJobsTableView.isHidden = true
                    weakSelf.mapViewWrapper.isHidden = false
                    weakSelf.filterButton.isHidden = true
                    weakSelf.mapViewWrapperHeighContraint.constant = 0
                    weakSelf.managerJobsViewModel.reloadMapView(weakSelf.mapView)
                }
                
                if let tabController = weakSelf.parent as? UITabBarController {
                    if let rightButton = tabController.navigationItem.rightBarButtonItem?.customView as? UIButton {
                        if weakSelf.isVisibleTableView{
                            rightButton.setImage(UIImage(systemName: "map"), for: .normal)
                        }
                        else{
                            rightButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
                        }
                    }
                }
            }
        }
    }
}

// MARK: Pricate Methods
extension ManagerJobsViewController{
    
    private func setupTableView()
    {
        self.managerJobsTableView.hasSeparator = false
        self.managerJobsTableView.delegate = self
        self.managerJobsTableView.dataSource = self
        self.managerJobsTableView.estimatedRowHeight = 44.0
        self.managerJobsTableView.rowHeight = UITableView.automaticDimension
        self.managerJobsTableView.clearTableFooterView()
        self.managerJobsTableView.keyboardDismissMode = .onDrag
        self.managerJobsTableView.es.addPullToRefresh {
            [unowned self] in
            self.managerJobsViewModel.fetchAssignmentList()
        }
    }
}

// MARK: TableView Data source and Delegate

extension ManagerJobsViewController:UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.managerJobsViewModel.numberOfSectionInTable()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.managerJobsViewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.managerJobsViewModel.cellForRowAtIndex(tableView, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderData = self.managerJobsViewModel.didSelectCellRowAtIndex(indexPath: indexPath)
        self.performSegue(withIdentifier: "siteActiveDetailsSegue", sender:senderData)
    }
}


// MARK: Google Map Delegate
extension ManagerJobsViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return self.managerJobsViewModel.didTap(mapView,marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        return self.managerJobsViewModel.didCloseInfoWindowOf(mapView,marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let data = self.managerJobsViewModel.didTapMarkInfo(marker: marker){
            self.performSegue(withIdentifier: "siteActiveDetailsSegue", sender: data)
        }
    }
}

// MARK: Protocol Methods
extension ManagerJobsViewController: ManagerJobsProtocol {
    func reloadTableData() {
        self.hideLoading()
        self.managerJobsTableView.reloadData()
        self.managerJobsTableView.es.stopPullToRefresh()
        let badgeValue = managerJobsViewModel.badgeValue()
        self.filterButton.badge = badgeValue > 0 ? "\(badgeValue)" : nil
    }
}

extension ManagerJobsViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        self.searchBar.clearBackgroundColor()
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.delegate = self
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(processSearch), object: nil)
        perform(#selector(processSearch), with: nil, afterDelay: 0.5)
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
        
        managerJobsViewModel.search(searchString)
    }
    
}

extension ManagerJobsViewController: ManagerJobsFilterViewControllerDelegate {
    func onSelect(assignments: [String], status: [TechnicianActiveSitesStatus]) {
        managerJobsViewModel.filter(asigneeEmails: assignments, status: status, searchText: searchBar.text ?? "")
    }
}
