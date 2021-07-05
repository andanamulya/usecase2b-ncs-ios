//
//  TechnicianSiteDetailsViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import CoreLocation
import SwiftLocation

protocol TechnicianSiteDetailsProtocol:BaseProtocol {
    
}

class TechnicianSiteDetailsViewModel: BaseViewModel {
    
    weak var delegate: TechnicianSiteDetailsProtocol?
    
    var data:AssignmentModel?
    
    /// Setup Direction Action Sheet
    /// - Parameters:
    ///   - vc: ViewController
    ///   - completion: void
    func getDirection(vc:BaseViewController, completion:@escaping(() -> Void)){
        let currentStatus = SwiftLocation.authorizationStatus
        if currentStatus == .denied || currentStatus == .restricted {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Constant.appName, message: "Please enable your location services.", preferredStyle: .alert)
                alert.overrideUserInterfaceStyle = .light
                
                let okAction = UIAlertAction(title: "Settings", style: .default) { alert in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }
                alert.addAction(okAction)
                
                let closeAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                }
                alert.addAction(closeAction)
                vc.present(alert, animated: true, completion: nil)
            }
            completion();
        }else{
            LocationManager.getCurrentLocation { [weak self] currentLocation in
                if let weakSelf = self, let weakData = weakSelf.data, let location = currentLocation{
                    let appleMapRedirectUrl = URL.init(string:"https://maps.apple.com/?saddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&daddr=\(weakData.siteLatitude),\(weakData.siteLongitude)")
                    let googleMapRedirectUrl = URL.init(string:"comgooglemaps://?saddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&daddr=\(weakData.siteLatitude),\(weakData.siteLongitude)&directionsmode=transit");
                    DispatchQueue.main.async {
                        var status = false
                        let alert = UIAlertController(title: Constant.appName, message: "Select route direction provider.", preferredStyle: .actionSheet)
                        if UIApplication.shared.canOpenURL(appleMapRedirectUrl!) {
                            let appleAction = UIAlertAction(title: "Apple Map", style: .default) { alert in
                                UIApplication.shared.open(appleMapRedirectUrl!, options: [ : ]) { success in
                                }
                            }
                            alert.addAction(appleAction)
                            status = true
                        }
                        if UIApplication.shared.canOpenURL(googleMapRedirectUrl!) {
                            let googleAction = UIAlertAction(title: "Google Map", style: .default) { alert in
                                UIApplication.shared.open(googleMapRedirectUrl!, options: [ : ]) { success in
                                }
                            }
                            alert.addAction(googleAction)
                            status = true
                        }
                        if status {
                            alert.overrideUserInterfaceStyle = .light
                            let closeAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
                            }
                            alert.addAction(closeAction)
                            vc.present(alert, animated: true, completion: nil)
                        }else{
                            vc.showAlert(message: "Direction not available.")
                        }
                    }
                }
                completion();
            }
        }
    }
    
    func fetchSiteDetails(){
        
        if let assignmentId = self.data?.assignmentId{
            AssignmentServiceManager.getAssignentsDetailList(assignmentId: assignmentId) { [weak self](assignmentList) in
                if let weakSelf = self {
                    weakSelf.data = nil
                    if assignmentList.count > 0 {
                        weakSelf.self.data = assignmentList.first
                    }
                    weakSelf.delegate?.reloadTableData()
                }
            } _: { [weak self](error) in
                if let weakSelf = self {
                    weakSelf.delegate?.reloadTableData()
                }
            }
        }
    }
    
    /// Retrieve site name from data model
    /// - Returns: Site name string
    func getSiteName() -> String{
        return self.data?.siteName ?? ""
    }
    /// Retrieve address string from data model
    /// - Returns: Address  string
    func getAddress() -> String{
        return self.data?.siteAddress ?? ""
    }
    /// Retrieve description from data model
    /// - Returns: Description string
    func getDescription() -> String{
        return self.data?.description ?? ""
    }
    /// Retrieve description from data model
    /// - Returns: Description string
    func getStatus() -> TechnicianActiveSitesStatus{
        return self.data?.jobStatus ?? .none
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if user role is techinician
    func isUserLoginManagerRole() -> Bool{
        return (UserDataService.shared.userAttributeRole == UserModel.userRole.manager.rawValue)
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for inspection
    func checkJobStatusInspection() -> Bool {
        if let userData = self.data, userData.jobStatus == .inspect {
            return true
        }
        return false
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for fixing
    func checkJobStatusToFix() -> Bool {
        if let userData = self.data, userData.jobStatus == .fix {
            return true
        }
        return false
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for completed
    func checkJobStatusCompleted() -> Bool {
        if let userData = self.data, userData.jobStatus == .complete {
            return true
        }
        return false
    }
}
