//
//  TechnicianActiveSitesTableViewCell.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit

class TechnicianActiveSitesTableViewCell: BaseTableViewCell {
    
    static let identifier = "TechnicianActiveSitesTableViewCellIdentifier"
    
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var siteNameTextLabel: UILabel!
    @IBOutlet private weak var distanceTextLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!
    @IBOutlet private weak var statusButtonHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Set the site name Text
    var siteNameText:String {
        set{
            self.siteNameTextLabel.text = newValue
        }
        get{
            return self.siteNameTextLabel.text ?? ""
        }
    }
    
    /// Set the distance Text
    var distanceText:String {
        set{
            self.distanceTextLabel.text = newValue
        }
        get{
            return self.distanceTextLabel.text ?? ""
        }
    }
    
    /// Set the description Text
    var descriptionText:String {
        set{
            self.descriptionTextLabel.text = newValue
        }
        get{
            return self.descriptionTextLabel.text ?? ""
        }
    }
    
    
    func updateRowData(assignment:AssignmentModel)
    {
        self.siteNameText = assignment.siteName
        self.descriptionText = assignment.siteAddress
        self.distanceText = assignment.formatDistanceToString()
        
        self.statusButton.setTitle(assignment.jobStatus.rawValue, for: .normal)
        
        self.statusButton.setTitleColor(.white, for: .normal)
        self.statusButton.layer.masksToBounds = true
        self.statusButton.layer.cornerRadius = 15
        
        self.statusButton.backgroundColor = UIColor.getJobStatusColor(status: assignment.jobStatus)
    }
    
//    /// Set the status value
//    /// - Parameter status: status type
//    private func statusValue(_ status:TechnicianActiveSitesStatus?){
//        self.statusButton.setTitleColor(.white, for: .normal)
//        self.statusButton.layer.masksToBounds = true
//        self.statusButton.layer.cornerRadius = 10
//
//        switch status {
//        case .fix:
//            self.statusButton.setTitle(status?.rawValue, for: .normal)
//            self.statusButtonHeightConstraint.constant = 23
//            self.statusButton.backgroundColor = UIColor.getHexColor("#E26389");
//            break;
//        case .inspect:
//            self.statusButton.setTitle(status?.rawValue, for: .normal)
//            self.statusButtonHeightConstraint.constant = 23
//            self.statusButton.backgroundColor = UIColor.getHexColor("#E59A36");
//            break
//        case .complete:
//            self.statusButton.setTitle(status?.rawValue, for: .normal)
//            self.statusButtonHeightConstraint.constant = 23
//            self.statusButton.backgroundColor = UIColor.getHexColor("#3BD965");
//            break
//        default:
//            self.statusButton.setTitle("", for: .normal)
//            self.statusButton.isHidden = true
//            self.statusButtonHeightConstraint.constant = 0
//            break;
//        }
//    }
}
