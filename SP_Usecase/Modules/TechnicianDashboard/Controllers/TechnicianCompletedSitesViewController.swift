//
//  TechnicianCompletedSitesViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit
import GoogleMaps
import ESPullToRefresh

class TechnicianCompletedSitesViewController: BaseViewController {
    
    @IBOutlet weak var viewModel: TechnicianCompletedSitesViewModel!
    @IBOutlet fileprivate  weak var tableView: BaseTableView!
    @IBOutlet fileprivate weak var mapViewWrapper: BaseView!
    @IBOutlet fileprivate weak var mapView: BaseMapView!
    fileprivate var isVisibleTableView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.setupTableView();
        //self.viewModel.processData()
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading(message: "Loading...")
        self.viewModel.fetchAssignmentList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = self.viewModel.getPageTitle()
            let rightButton = UIButton(frame: CGRect(x:0,y:0,width:24,height:24))
            rightButton.backgroundColor = .clear
            if self.isVisibleTableView{
                rightButton.setImage(UIImage(systemName: "map"), for: .normal)
            }else{
                rightButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            }
            rightButton.adjustsImageWhenHighlighted = false
            rightButton.addTarget(self, action: #selector(mapBarButtonAction), for: .touchUpInside)
            tabController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightButton)
        }
    }
    
    func setupTableView(){
        self.tableView.hasSeparator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.clearTableFooterView()
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            self.viewModel.fetchAssignmentList()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "siteCompletedDetailsSegue"{
            if let destination = segue.destination as? TechnicianSiteDetailsViewController{
                if let siteData = sender as? AssignmentModel {
                    destination.viewModel.data = siteData
                }
            }
        }
    }
    
    /// Map and List Button Selector Action
    @objc func mapBarButtonAction() {
        self.isVisibleTableView = !self.isVisibleTableView
        self.view.endEditing(true)
        let rootView = (self.navigationController?.view!)
        if self.isVisibleTableView {
            // show TableView
            UIView.transition(with: rootView!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            }) { [weak self] (b) in
                if let weakSelf = self, b {
                    weakSelf.tableView.isHidden = false
                    weakSelf.mapViewWrapper.isHidden = true
                    if let tabController = weakSelf.parent as? UITabBarController {
                        if let rightButton = tabController.navigationItem.rightBarButtonItem?.customView as? UIButton {
                            rightButton.setImage(UIImage(systemName: "map"), for: .normal)
                        }
                    }
                }
            }
        }else{
            // show Map
            UIView.transition(with: rootView!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            }) { [weak self] (b) in
                if let weakSelf = self, b {
                    weakSelf.tableView.isHidden = true
                    weakSelf.mapViewWrapper.isHidden = false
                    weakSelf.viewModel.reloadMapView(weakSelf.mapView)
                    if let tabController = weakSelf.parent as? UITabBarController {
                        if let rightButton = tabController.navigationItem.rightBarButtonItem?.customView as? UIButton {
                            rightButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
                        }
                    }
                }
            }
        }
    }
}

//TableView Delegate and Datasource
extension TechnicianCompletedSitesViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.cellForRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderData = self.viewModel.didSelectRowAt(tableView, indexPath: indexPath)
        self.performSegue(withIdentifier: "siteCompletedDetailsSegue", sender:senderData)
    }
}

//Google Map Delegate
extension TechnicianCompletedSitesViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return self.viewModel.didTap(mapView,marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        return self.viewModel.didCloseInfoWindowOf(mapView,marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let data = self.viewModel.didTapMarkInfo(marker: marker){
            self.performSegue(withIdentifier: "siteCompletedDetailsSegue", sender: data)
        }
    }
}

// MARK: Protocol Methods
extension TechnicianCompletedSitesViewController: TechnicianCompletedSitesProtocol {
    func reloadTableData() {
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = self.viewModel.getPageTitle()
        }
        self.tableView.reloadData()
        self.tableView.es.stopPullToRefresh()
        self.hideLoading()
    }
}
