//
//  TechinicianSparePartsViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

import Alamofire
protocol TechinicianSparePartsViewModelDelegate:BaseProtocol {}
class TechinicianSparePartsViewModel: BaseViewModel {
    weak var delegate: TechinicianSparePartsViewModelDelegate?
    var data:AssignmentModel?
    fileprivate var partsData:[SparePartModel] = []
    fileprivate var searchData:[SparePartModel] = []
    var formData:TechnicianFormModel?
    
    func processData(){
        SparePartServiceManager.getSparePartList { [weak self] sparePartData in
            if let weakSelf = self {
                weakSelf.partsData = []
                weakSelf.partsData.append(contentsOf: sparePartData)
                weakSelf.searchData = weakSelf.partsData
                if let delegate = weakSelf.delegate{
                    delegate.reloadTableData()
                }
            }
        } _: { [weak self] error in
            if let weakSelf = self {
                weakSelf.searchData = []
                weakSelf.partsData = []
                if let delegate = weakSelf.delegate{
                    delegate.reloadTableData()
                }
            }
        }
    }
    
    /// Search spare part using specific keyword string
    /// - Parameter keyboard: search string
    func searchKeyword(_ keyboard:String){
        if keyboard.isEmpty {
            self.searchData = self.partsData
        } else {
            self.searchData = self.partsData.filter { part in
                return part.sparepartName.localizedCaseInsensitiveContains(keyboard)
            }
        }
        
        if let delegate = self.delegate{
            delegate.reloadTableData()
        }
    }
    
    /// Submit Inspection form data
    func submitInspectionForm(){
        //Submit Inspection Report with no issues. (remarks can be empty)
        /*
         {
             "assignmentId" : "1",
             "status" : "ToInspect",
             "inspectionRemarks" : "Need Fix",
             "resolutionRemarks": "Fixed"
         }
         **/
        if let _data = self.data{
            //Submit Inspection Report with no issues. (remarks can be empty)
            if let _formData = self.formData {
                let parameter:Parameters = ["assignmentId":_data.assignmentId,"status":"tofix","inspectionRemarks":_formData.remarks];
                AssignmentServiceManager.submitAssignment(parameters: parameter) { object in
                    if let delegate = self.delegate {
                        var spareParts:[Parameters] = []
                        for part in _formData.spareParts{
                            spareParts.append(["sparePartId":part.sparepartId,"quantity":part.quantity])
                        }
                        let paramters:Parameters = ["assignmentId":_data.assignmentId,"partsReservation":spareParts];
                        SparePartServiceManager.submitSparePartReservation(parameters: paramters) { paramters in
                            self.formData?.clean()
                            delegate.displaySuccess(message: nil)
                        } _: { error in
                            delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
                        }
                    }
                } _: { error in
                    if let delegate = self.delegate {
                        delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
                    }
                }
            }
        }else{
            if let delegate = self.delegate {
                delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
            }
        }
    }
}

extension TechinicianSparePartsViewModel{
    /// Retrieve the total number of rows in each section
    /// - Parameter section: table section
    /// - Returns: total number of rows in search section
    func numberOfRowsInSection(section: Int) -> Int{
        return self.searchData.count
    }
    
    /// Retrieve the individual tableview cell
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: TableView IndexPath
    /// - Returns: TechnicianActiveSitesTableViewCell
    func cellForRowAt(_ tableView:UITableView, indexPath: IndexPath) -> TechinicianSparePartsTableViewCell{
        let cell:TechinicianSparePartsTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: TechinicianSparePartsTableViewCell.identifier, for: indexPath) as! TechinicianSparePartsTableViewCell
        let sparePart = self.searchData[indexPath.row]
        cell.partName = sparePart.sparepartName
        cell.quantity = sparePart.quantity
        cell.totalQuantity = Int(sparePart.currentStock) ?? 0
        cell.selectionStyle = .none
        return cell
    }
    
    func updateSparePartQuantity(indexPath:IndexPath, quantity:Int){
        let sparePartData = self.searchData[indexPath.row]
        sparePartData.quantity = quantity
        self.searchData[indexPath.row] = sparePartData
        if let _ = self.formData?.spareParts {
            let filteredWithQuantity = self.searchData.filter { spDataModel in
                if spDataModel.quantity > 0 {
                    return true
                }
                return false
            }
            self.formData?.spareParts = filteredWithQuantity
        }
    }
}

