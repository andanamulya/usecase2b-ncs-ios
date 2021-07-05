//
//  TechinicianSelectedSparePartsViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

protocol TechinicianSelectedSparePartsViewModelDelegate:BaseProtocol {
    
}

class TechinicianSelectedSparePartsViewModel: BaseViewModel {
    var formData:TechnicianFormModel?
    weak var delegate: TechinicianSelectedSparePartsViewModelDelegate?
    
}

extension TechinicianSelectedSparePartsViewModel{
    /// Retrieve the total number of rows in each section
    /// - Parameter section: table section
    /// - Returns: total number of rows in search section
    func numberOfRowsInSection(section: Int) -> Int{
        return self.formData?.spareParts.count ?? 0
    }
    
    /// Retrieve the individual tableview cell
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: TableView IndexPath
    /// - Returns: TechnicianActiveSitesTableViewCell
    func cellForRowAt(_ tableView:UITableView, indexPath: IndexPath) -> TechinicianSparePartsTableViewCell{
        let cell:TechinicianSparePartsTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: TechinicianSparePartsTableViewCell.identifier, for: indexPath) as! TechinicianSparePartsTableViewCell
        let sparePart = self.formData?.spareParts[indexPath.row]
        cell.partName = sparePart?.sparepartName ?? ""
        cell.quantity = sparePart?.quantity ?? 0
        if let currentStock = sparePart?.currentStock{
            cell.totalQuantity = Int(currentStock) ?? 0
        }else{
            cell.totalQuantity = 0
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func updateSparePartQuantity(indexPath:IndexPath, quantity:Int){
        if let spFormData = self.formData{
            let sparePartData = spFormData.spareParts[indexPath.row]
            sparePartData.quantity = quantity
            self.formData?.spareParts[indexPath.row] = sparePartData
            if let _ = self.formData?.spareParts {
                let filteredWithQuantity = self.formData?.spareParts.filter { spDataModel in
                    if spDataModel.quantity > 0 {
                        return true
                    }
                    return false
                }
                self.formData?.spareParts = filteredWithQuantity ?? []
                if let delegate = self.delegate {
                    delegate.reloadTableData()
                }
            }
        }
    }
}

