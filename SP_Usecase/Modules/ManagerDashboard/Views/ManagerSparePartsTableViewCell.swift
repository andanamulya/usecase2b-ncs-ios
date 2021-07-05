//
//  ManagerSparePartsTableViewCell.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 30/6/21.
//


import UIKit

class ManagerSparePartsTableViewCell: BaseTableViewCell{
    
    
    static let identifier = "ManagerSparePartsTableViewCell"
    
    @IBOutlet weak var siteNameLabel: UILabel!
    
    @IBOutlet weak var cartImage: UIImageView!
    
    @IBOutlet weak var totalInStockLabel: UILabel!
    @IBOutlet weak var totalInStockValueLabel: UILabel!
    @IBOutlet weak var reservedLabel: UILabel!
    @IBOutlet weak var reservedValueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    
    
    func updateCellData(sparePart:SparePartModel)
    {
        self.siteNameLabel.text = sparePart.sparepartName
        self.totalInStockValueLabel.text = sparePart.currentStock
        self.reservedValueLabel.text = sparePart.reservedStock
        if (sparePart.status == "1")
        {
            self.statusValueLabel.text = "PO raised"
            self.statusValueLabel.textColor = UIColor.label
        }
        else{
            if let reservedStock = Int(sparePart.reservedStock),
               let currentStock = Int(sparePart.currentStock)
            {
                if reservedStock > currentStock
                {
                    self.statusValueLabel.textColor = UIColor.getAppColor(color: AppColors.insufficient.rawValue)
                    self.statusValueLabel.text = "Insufficient"
                }
                else
                {
                    self.statusValueLabel.textColor = UIColor.getAppColor(color: AppColors.instock.rawValue)
                    self.statusValueLabel.text = "In stock"
                }
            }
            
        }
        
    }
    
    
}
