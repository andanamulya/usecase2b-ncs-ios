//
//  SparePartModel.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 1/7/21.
//

import UIKit
import ObjectMapper

class SparePartModel: BaseModel {
    @objc dynamic var quantity:Int = 0
    @objc dynamic var sparepartId:String = ""
    @objc dynamic var sparepartName:String = ""
    @objc dynamic var sparepartDescription:String = ""
    @objc dynamic var catalogRefId:String = ""
    @objc dynamic var category:String = ""
    @objc dynamic var currentStock:String = ""
    @objc dynamic var status:String = ""
    @objc dynamic var reservedStock:String = ""
    @objc dynamic var createdDate:String = ""
    @objc dynamic var lastUpdatedDate:String = ""
    dynamic var sortOrder:Int = 2
                
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        self.sparepartId <- map["sparePartId"]
        self.sparepartName <- map["sparePartName"]
        self.sparepartDescription <- map["sparepartDescription"]
        self.catalogRefId <- map["catalogRefId"]
        self.category <- map["category"]
        self.currentStock <- map["currentStock"]
    
        self.status <- map["status"]
        self.reservedStock <- map["reservedStock"]
        self.createdDate <- map["createdDate"]
        self.lastUpdatedDate <- map["lastUpdatedDate"]
        
        
        var tempCurrentStock:String?
        tempCurrentStock <- map["currentStock"]
        
        var tempReservedStock:String?
        tempReservedStock <- map["reservedStock"]
        
        var tempStatus:String?
        tempStatus <- map["status"]
        
        if tempStatus == "1"
        {
            sortOrder = 1
        }
        else if Int(tempCurrentStock ?? "0") ?? 0  < Int(tempReservedStock ?? "0") ?? 0 {
            sortOrder = 0
        }
        
        
        
        
        
    }
    
//    required convenience init?(name:String, quantity:Int?=0,totalQuantity:Int){
//        self.init()
//        self.name = name
//        self.quantity = quantity ?? 0
//        self.totalQuantity = totalQuantity
//    }
}
