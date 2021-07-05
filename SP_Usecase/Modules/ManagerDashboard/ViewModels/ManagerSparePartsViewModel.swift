//
//  ManagerSparePartsViewModel.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 30/6/21.
//


import UIKit


protocol ManagerSparePartsProtocol:BaseProtocol {
    
    func showLoading()
    
}
class ManagerSparePartsViewModel: BaseViewModel {
    
    weak var delegate: ManagerSparePartsProtocol?
    
    var data:[SparePartModel] = []
    var filteredData:[SparePartModel] = []
    
    func fetchSparePartsList()
    {
        SparePartServiceManager.getSparePartList { [weak self](assignmentList) in
            if let weakSelf = self {
                weakSelf.data = []
                weakSelf.filteredData = []
            
                weakSelf.data.append(contentsOf: assignmentList)
                weakSelf.data = weakSelf.sortSparePartData(data: weakSelf.data)
                weakSelf.filteredData = weakSelf.data
                
                
                weakSelf.delegate?.reloadTableData()
            }
        } _: {  [weak self](error) in
            if let weakSelf = self {
                weakSelf.delegate?.reloadTableData()
            }
        }
    }
    func search(_ text: String) {
        if text.isEmpty {
            self.filteredData = self.data
        } else {
            self.filteredData = self.data.filter { sparePart in
                return sparePart.sparepartName.contains(text)
            }
        }
        delegate?.reloadTableData()
    }
    
    
    func updateSparePartPO(sparePartId:String){
        
        SparePartServiceManager.updateSparePartPO(sparePartId: sparePartId) { [weak self] () in

            if let weakSelf = self {
                
                weakSelf.delegate?.displaySuccess(message: MessageConstant.poRasied)
                
                weakSelf.fetchSparePartsList()
            }
            
        } _: {  [weak self](error) in
            if let weakSelf = self {
                weakSelf.delegate?.reloadTableData()
            }
        }

    }
    
    
    private func sortSparePartData(data:[SparePartModel]) -> [SparePartModel]{
        
       
        var tempdata = data
        
        tempdata.sort{one,two in
            return one.sortOrder < two.sortOrder
        }
        
//        tempdata.sort {one,two in
//
//            let currentStock = Int(one.currentStock) ?? 0
//            let reservedStock = Int(one.reservedStock) ?? 0
//
//            if currentStock < reservedStock{
//                if one.status == "1"{
//                    return false
//                }
//                else{
//                    return true
//                }
//
//            }
//            else if one.status == "1"{
//                return false
//            }
//
//
//            return false
//        }
        
        
        return tempdata
        
    }
}


// MARK: TableView Data source and Delegate
extension ManagerSparePartsViewModel{
    
    func numberOfRowsInSection(section:Int) -> Int{
        return self.filteredData.count
    }
    
    func cellForRowAtIndex(_ tableView:UITableView, indexPath:IndexPath) -> UITableViewCell{
        let cell:ManagerSparePartsTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: ManagerSparePartsTableViewCell.identifier, for: indexPath) as! ManagerSparePartsTableViewCell
       
        
        cell.updateCellData(sparePart: filteredData[indexPath.row])
        
        return cell
        
    }
    func didSelectCellRowAtIndex(indexPath:IndexPath){
        
        if filteredData[indexPath.row].status == "0"{
        
            if let reservedStock = Int(filteredData[indexPath.row].reservedStock),
               let currentStock = Int(filteredData[indexPath.row].currentStock){
                if reservedStock > currentStock
                {
                    self.delegate?.showLoading()
                    self.updateSparePartPO(sparePartId: filteredData[indexPath.row].sparepartId)
                }
            }
        }
        
    }
    
    
}
