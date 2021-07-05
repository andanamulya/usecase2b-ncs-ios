//
//  SiteModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import ObjectMapper
import CoreLocation

enum TechnicianActiveSitesStatus:String,CaseIterable{
    case inspect = "To Inspect"
    case fix = "To Fix"
    case complete = "Completed"
    case none = ""
}

//"assignmentId": "AS0001",
//            "asigneeName": "user1",
//            "asigneeEmail": "user1@gmail.com",
//            "siteName": "Changi Site",
//            "siteAddress": "changi",
//            "siteLong": "103.9832",
//            "siteLat": "1.3450",
//            "description": "Sample Description",
//            "scheduleVisitDate": "2012-04-23T18:25:43.511Z",
//            "nextVisitDate": "2012-04-23T18:25:43.511Z",
//            "jobStatus": "complete",
//            "completedDate": "2012-04-23T18:25:43.511Z"

class AssignmentModel: BaseModel {
    @objc dynamic var assignmentId:String = ""
    @objc dynamic var asigneeName:String = ""
    @objc dynamic var asigneeEmail:String = ""
    @objc dynamic var siteName:String = ""
    @objc dynamic var siteAddress:String = ""
    @objc dynamic var siteLongitude:Double = 0.0
    @objc dynamic var siteLatitude:Double = 0.0
    @objc dynamic var description:String = ""
    @objc dynamic var scheduleVisitDate:String = ""
    @objc dynamic var nextVisitDate:String = ""
    dynamic var jobStatus:TechnicianActiveSitesStatus = .none
    @objc dynamic var lastUpdatedDate:String = ""
    
    @objc dynamic var inspectionRemarks:String = ""
    @objc dynamic var resolutionRemarks:String = ""
    
    var reservedSpareParts:[ReservedSpareParts] = []
    
    var distance:Double = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        //Object Mapping
        super.mapping(map: map)
        
        self.assignmentId <- map["assignmentId"]
        self.asigneeName <- map["assigneeName"]
        self.asigneeEmail <- map["assigneeEmail"]
        self.siteName <- map["siteName"]
        self.siteAddress <- map["siteAddress"]
        
        //convert
        var longitude:String?
        longitude <- map["siteLong"]
        if let long = Double(longitude ?? "0.0"){
            self.siteLongitude = long
        }
        
        var latitude:String?
        latitude <- map["siteLat"]
        if let lat = Double(latitude ?? "0.0"){
            self.siteLatitude = lat
        }
        
        //self.siteLongitude <- map["siteLongitude"]
        //self.siteLatitude <- map["siteLatitude"]
        
        self.description <- map["description"]
        self.scheduleVisitDate <- map["scheduleVisitDate"]
        self.nextVisitDate <- map["nextVisitDate"]
        
        //job status
        self.jobStatus <- map["jobStatus"]
        var status:String?
        status <- map["jobStatus"]
        if let tempStatus = status?.lowercased(){
            
            if tempStatus == "toinspect"{
                self.jobStatus = .inspect
            }
            else if tempStatus == "tofix"{
                self.jobStatus = .fix
            }
            else if tempStatus == "complete"{
                self.jobStatus = .complete
            }
        }
        self.lastUpdatedDate <- map["lastUpdatedDate"]
        self.inspectionRemarks <- map["inspectionRemarks"]
        self.resolutionRemarks <- map["resolutionRemarks"]
        self.reservedSpareParts <- map["reservedSpareParts"]
    }
    
    internal func getDistanceFromLocation(location:CLLocation) -> Double{
        let siteLocation = CLLocation(latitude: self.siteLatitude, longitude: self.siteLongitude)
        return siteLocation.distance(from: location)
    }
    
    internal func formatDistanceToString() -> String{
        let unit = self.distance > 1000 ? "km" : "m"
        let displayDistance:Float = Float((distance > 1000) ? (distance/1000) : distance)
        return String.init(format: "%.1f %@",displayDistance,unit)
    }
}

class ReservedSpareParts:BaseModel{
    
    @objc dynamic var sparepartId:String = ""
    @objc dynamic var sparePartName:String = ""
    @objc dynamic var currentStock:String = ""
    @objc dynamic var reservedStock:String = ""
    @objc dynamic var quantity:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        //Object Mapping
        super.mapping(map: map)
        self.sparepartId <- map["sparepartId"]
        self.sparePartName <- map["sparePartName"]
        self.currentStock <- map["currentStock"]
        self.reservedStock <- map["reservedStock"]
        self.quantity <- map["quantity"]
    }
}







