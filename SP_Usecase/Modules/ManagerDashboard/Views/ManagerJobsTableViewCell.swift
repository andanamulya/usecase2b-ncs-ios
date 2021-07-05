//
//  ManagerDashboardJobsTableViewCell.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 30/6/21.
//

import UIKit

class ManagerJobsTableViewCell: BaseTableViewCell{
    
    
    static let identifier = "ManagerJobsTableViewCell"
    
    @IBOutlet weak var siteNameLabel: UILabel!
    
    @IBOutlet weak var technicianImage: UIImageView!
    
    @IBOutlet weak var technicianNameLabel: UILabel!
    
    
    @IBOutlet weak var jobStatusButton: UIButton!
    
    
    
    func updateCellData(assignment:AssignmentModel)  {
        
        self.siteNameLabel.text = assignment.siteName
        self.technicianNameLabel.text = assignment.asigneeName
        
        self.jobStatusButton.setTitle(assignment.jobStatus.rawValue, for: .normal)
        
        self.jobStatusButton.setTitleColor(.white, for: .normal)
        self.jobStatusButton.layer.masksToBounds = true
        self.jobStatusButton.layer.cornerRadius = 12
        
        self.jobStatusButton.backgroundColor = UIColor.getJobStatusColor(status: assignment.jobStatus)
    
    }
    
}
