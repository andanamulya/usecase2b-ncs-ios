//
//  FormModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

class TechnicianFormModel: NSObject {
    var remarks:String = ""
    var spareParts:[SparePartModel] = []
    
    convenience init(remarks:String? = "", spareParts:[SparePartModel]? = []) {
        self.init()
        self.remarks = remarks ?? ""
        self.spareParts = spareParts ?? []
    }
    func clean(){
        self.remarks = ""
        self.spareParts = []
    }
}
