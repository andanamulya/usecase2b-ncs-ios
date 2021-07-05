//
//  TechnicianCompletedSitesTableViewCell.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit

class TechnicianCompletedSitesTableViewCell: BaseTableViewCell {
    static let identifier = "TechnicianCompletedSitesTableViewCellIdentifier"
    
    @IBOutlet private weak var siteNameTextLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!
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
    var descriptionText:String {
        set{
            self.descriptionTextLabel.text = newValue
        }
        get{
            return self.descriptionTextLabel.text ?? ""
        }
    }
}
