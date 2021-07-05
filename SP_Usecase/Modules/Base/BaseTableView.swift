//
//  BaseTableView.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 28/6/21.
//

import UIKit

class BaseTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var hasSeparator:Bool = true {
        didSet{
            if hasSeparator {
                self.separatorStyle = .singleLine
            }else{
                self.separatorStyle = .none
            }
        }
    }
    
    /// Set the table footer view to empty view
    func clearTableFooterView(){
        self.tableFooterView = UIView()
    }
    
}
