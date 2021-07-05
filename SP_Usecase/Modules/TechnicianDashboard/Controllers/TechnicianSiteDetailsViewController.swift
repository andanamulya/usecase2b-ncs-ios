//
//  TechnicianSiteDetailsViewController.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import ESPullToRefresh

class TechnicianSiteDetailsViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: BaseTableView!
    @IBOutlet private weak var headerView: BaseView!
    @IBOutlet private weak var contentWrapper: BaseView!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var siteNameTextLabel: UILabel!
    @IBOutlet private weak var addressTextLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!
    @IBOutlet private weak var directionButton: UIButton!
    @IBOutlet private weak var reportButton: UIButton!
    @IBOutlet private weak var directionSecondButton: UIButton!
    @IBOutlet private weak var singleButtonViewWrapper: BaseView!
    @IBOutlet private weak var doubleButtonViewWrapper: BaseView!
    @IBOutlet private weak var statusButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewWrapperHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var reportButtonHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var directionButtonHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var directionSecondButtonHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewModel: TechnicianSiteDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.siteNameTextLabel.text = self.viewModel.getSiteName()
        self.addressTextLabel.text = self.viewModel.getAddress()
        self.descriptionTextLabel.text = self.viewModel.getDescription()
        self.statusValue(self.viewModel.getStatus())
        
        self.reportButton.layer.masksToBounds = true
        self.reportButton.layer.cornerRadius = 5
        self.directionButton.layer.masksToBounds = true
        self.directionButton.layer.cornerRadius = 5
        self.directionSecondButton.layer.masksToBounds = true
        self.directionSecondButton.layer.cornerRadius = 5
        self.setupTableView()
        self.viewModel.delegate = self
        self.buttonViewWrapperIsHidden(self.viewModel.isUserLoginManagerRole())
        self.reportButtonIsHidden(self.viewModel.checkJobStatusCompleted())
        if self.viewModel.checkJobStatusInspection() {
            self.reportButton.setTitle("Inspection Report", for: .normal)
        }else if self.viewModel.checkJobStatusToFix() {
            self.reportButton.setTitle("Resolution Report", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Download the Details Data.
        self.viewModel.fetchSiteDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView(){
        self.tableView.hasSeparator = false
        self.tableView.clearTableFooterView()
//        self.headerView.bounds = self.contentWrapper.bounds
        self.tableView.tableHeaderView = self.headerView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            self.viewModel.fetchSiteDetails()
        }
    }
    
    /// Set the status value
    /// - Parameter status: status type
    func statusValue(_ status:TechnicianActiveSitesStatus){
        self.statusButton.setTitleColor(.white, for: .normal)
        self.statusButton.layer.masksToBounds = true
        self.statusButton.layer.cornerRadius = 10
        
        self.statusButton.setTitle(status.rawValue, for: .normal)
        self.statusButtonHeightConstraint.constant = 23
        
        self.statusButton.backgroundColor = UIColor.getJobStatusColor(status: status)
        if status == .none{
            self.statusButton.setTitle("", for: .normal)
            self.statusButton.isHidden = true
            self.statusButtonHeightConstraint.constant = 0
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "resolutionFormSegue"{
            if let destination = segue.destination as? TechnicianInspectResolutionReportViewController{
                destination.viewModel.data = self.viewModel.data
            }
        }
    }
    
    func reportButtonIsHidden(_ hide:Bool){
        if hide {
            self.singleButtonViewWrapper.isHidden = false
            self.doubleButtonViewWrapper.isHidden = true
        }else{
            self.singleButtonViewWrapper.isHidden = true
            self.doubleButtonViewWrapper.isHidden = false
        }
    }
    
    func buttonViewWrapperIsHidden(_ hide:Bool){
        if hide {
            self.reportButton.isUserInteractionEnabled = false
            self.reportButton.isEnabled = false
            self.directionButton.isUserInteractionEnabled = false
            self.directionButton.isEnabled = false
            self.directionSecondButton.isUserInteractionEnabled = false
            self.directionSecondButton.isEnabled = false
            self.reportButtonHeightContraint.constant = 0
            self.directionButtonHeightContraint.constant = 0
            self.directionSecondButtonHeightContraint.constant = 0
            self.buttonViewWrapperHeightContraint.constant = 0
        }else{
            self.reportButton.isUserInteractionEnabled = true
            self.reportButton.isEnabled = true
            self.directionButton.isUserInteractionEnabled = true
            self.directionButton.isEnabled = true
            self.directionSecondButton.isUserInteractionEnabled = true
            self.directionSecondButton.isEnabled = true
            self.reportButtonHeightContraint.constant = 34
            self.directionButtonHeightContraint.constant = 34
            self.directionSecondButtonHeightContraint.constant = 34
            self.buttonViewWrapperHeightContraint.constant = 64
        }
        
        self.reportButton.isHidden = hide
        self.directionButton.isHidden = hide
    }
}
// Actions
extension TechnicianSiteDetailsViewController{
    
    @IBAction func directionButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        if button == self.directionButton {
            self.directionButton.isUserInteractionEnabled = false;
            self.directionButton.setImage(UIImage.init(systemName: "clock"), for: .normal)
        }else if button == self.directionSecondButton {
            self.directionSecondButton.isUserInteractionEnabled = false;
            self.directionSecondButton.setImage(UIImage.init(systemName: "clock"), for: .normal)
        }
        self.viewModel.getDirection(vc: self) {
            if button == self.directionButton {
                self.directionButton.isUserInteractionEnabled = true;
                self.directionButton.setImage(UIImage.init(named: "location_icon"), for: .normal)
            }else if button == self.directionSecondButton {
                self.directionSecondButton.isUserInteractionEnabled = true;
                self.directionSecondButton.setImage(UIImage.init(named: "location_icon"), for: .normal)
            }
        }
    }
    
    @IBAction func reportButtonAction(_ sender: Any) {
        if (self.viewModel.checkJobStatusInspection() || self.viewModel.checkJobStatusToFix()){
            self.performSegue(withIdentifier: "resolutionFormSegue", sender: nil)
        }
    }
}

extension TechnicianSiteDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (viewModel.data?.reservedSpareParts.count ?? 0) + 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel.data else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InspectionHeaderCell.self), for: indexPath) as! InspectionHeaderCell
                cell.lblRemarks.text = data.inspectionRemarks
                return cell
            } else if indexPath.row == data.reservedSpareParts.count + 1 {
                let cell = UITableViewCell()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SparePartCell.self), for: indexPath) as! SparePartCell
                let sparePart = data.reservedSpareParts[indexPath.row - 1]
                cell.lblDescription.text = sparePart.sparePartName
                cell.lblNumber.text = "x \(sparePart.quantity)"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResolutionReportCell.self), for: indexPath) as! ResolutionReportCell
            cell.lblRemarks.text = data.resolutionRemarks
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.checkJobStatusInspection() {
            return 0
        } else if viewModel.checkJobStatusToFix() {
            return 1
        } else {
            return 2
        }
    }
}

extension TechnicianSiteDetailsViewController:TechnicianSiteDetailsProtocol {
    func reloadTableData() {
        self.tableView.reloadData()
        self.tableView.es.stopPullToRefresh()
        self.buttonViewWrapperIsHidden(self.viewModel.isUserLoginManagerRole())
        self.reportButtonIsHidden(self.viewModel.checkJobStatusCompleted())
        self.siteNameTextLabel.text = self.viewModel.getSiteName()
        self.addressTextLabel.text = self.viewModel.getAddress()
        self.descriptionTextLabel.text = self.viewModel.getDescription()
        self.statusValue(self.viewModel.getStatus())
        if self.viewModel.checkJobStatusInspection() {
            self.reportButton.setTitle("Inspection Report", for: .normal)
        }else if self.viewModel.checkJobStatusToFix() {
            self.reportButton.setTitle("Resolution Report", for: .normal)
        }
    }
}
