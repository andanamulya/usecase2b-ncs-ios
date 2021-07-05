//
//  TechinicianSparePartsTableViewCell.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

protocol TechinicianSparePartsTableViewCellDelegate: BaseProtocol {
    func didQuantityUpdate(tableViewCell:TechinicianSparePartsTableViewCell, action:CounterView.action, quantity:Int)
}
class TechinicianSparePartsTableViewCell: BaseTableViewCell {
    
    static let identifier = "TechinicianSparePartsTableViewCellIdentifier"
    weak var delegate: TechinicianSparePartsTableViewCellDelegate?
    
    @IBOutlet private weak var nameTextLabel: UILabel!
    @IBOutlet private weak var counterViewWrapper: CounterView!
    
    var quantity:Int {
        set{
            self.counterViewWrapper.counter = newValue
        }
        get {
            return self.counterViewWrapper.counter
        }
    }
    var totalQuantity:Int {
        set{
            self.counterViewWrapper.totalQuantity = newValue
        }
        get {
            return self.counterViewWrapper.totalQuantity
        }
    }
    var partName:String {
        set{
            self.nameTextLabel.text = newValue
        }
        get {
            return self.nameTextLabel.text ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.counterViewWrapper.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
extension TechinicianSparePartsTableViewCell:CounterViewDelegate{
    func didQuantityUpdate(view: CounterView, action:CounterView.action, quantity: Int) {
        if let delegate = self.delegate {
            delegate.didQuantityUpdate(tableViewCell: self, action:action, quantity: quantity)
        }
    }
}
