//
//  TechinicianSelectedSparePartsViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

class TechinicianSelectedSparePartsViewController: BaseViewController {
    @IBOutlet var viewModel: TechinicianSelectedSparePartsViewModel!
    @IBOutlet fileprivate weak var tableView: BaseTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel.delegate = self
        self.setupTableView()
        self.setupRightNavigationMenu()
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
    }
    private func setupRightNavigationMenu(){
        let rightButton = UIButton(frame: CGRect(x:0,y:0,width:24,height:24))
        rightButton.setTitle("Next", for: .normal)
        rightButton.setTitleColor(UIColor.custom.navigationItemTitle.colorValue, for: .normal)
        rightButton.adjustsImageWhenHighlighted = false
        rightButton.addTarget(self, action: #selector(nextSubmitButtonAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightButton)
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

//TableView Delegate and Datasource
extension TechinicianSelectedSparePartsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.viewModel.cellForRowAt(tableView, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

extension TechinicianSelectedSparePartsViewController:TechinicianSparePartsTableViewCellDelegate{
    func didQuantityUpdate(tableViewCell: TechinicianSparePartsTableViewCell, action:CounterView.action, quantity: Int) {
        if let indexPath = self.tableView.indexPath(for: tableViewCell){
            self.viewModel.updateSparePartQuantity(indexPath:indexPath, quantity:quantity)
        }
    }
}
extension TechinicianSelectedSparePartsViewController:TechinicianSelectedSparePartsViewModelDelegate{
    func reloadTableData() {
        self.tableView.reloadData()
    }
}

//Actions
extension TechinicianSelectedSparePartsViewController{
    
    /// Next/Submit Action Button
    /// - Parameter sender: Button Action Sender
    @objc func nextSubmitButtonAction(_ sender:Any) {
        
    }
}
