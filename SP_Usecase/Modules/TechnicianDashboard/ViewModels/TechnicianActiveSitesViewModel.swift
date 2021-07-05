//
//  TechnicianActiveSitesViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import GoogleMaps
import SwiftLocation
import CoreLocation

protocol TechnicianActiveSitesProtocol:BaseProtocol {
    
}

class TechnicianActiveSitesViewModel: BaseViewModel {
    //fileprivate var data:[SiteModel] = []
    weak var delegate: TechnicianActiveSitesProtocol?
    
    fileprivate var data:[AssignmentModel] = []
    
    func getPageTitle() -> String{
        let countString = (self.data.count > 0) ? "(\(self.data.count))" : ""
        return "Active Sites" + countString
    }
    
    func fetchAssignmentList(){
        AssignmentServiceManager.getAssignentsList { [weak self](assignmentList) in
            if let weakSelf = self {
                weakSelf.data = []
                let temp = assignmentList.filter {
                    return $0.jobStatus != TechnicianActiveSitesStatus.complete
                }
                
                weakSelf.data.append(contentsOf: temp)
                //weakSelf.delegate?.reloadTableData()
                
                let currentStatus = SwiftLocation.authorizationStatus
                if (currentStatus == .authorizedAlways ||  currentStatus == .authorizedWhenInUse){
                    LocationManager.getCurrentLocation { location in
                        if let location = location {
                            for site in weakSelf.data{
                                let distance = site.getDistanceFromLocation(location: location)
                                site.distance = distance
                            }
                            let sortedData = weakSelf.data.sorted {$0.distance < $1.distance}.map{$0}
                            weakSelf.data = sortedData;
                        }
                        weakSelf.delegate?.reloadTableData()
                    }
                }else{
                    weakSelf.delegate?.reloadTableData()
                }
            }
        } _: { [weak self](error) in
            if let weakSelf = self {
                weakSelf.delegate?.reloadTableData()
            }
        }
    }
}

//Table View View model delegate and datasource
extension TechnicianActiveSitesViewModel{
    /// Retrieve the total number of rows in each section#imageLiteral(resourceName: "simulator_screenshot_576EE660-1EB3-4D4D-8D1C-C53C52F88C92.png")
    /// - Parameter section: table section
    /// - Returns: total number of rows in search section
    func numberOfRowsInSection(section: Int) -> Int{
        return self.data.count
    }
    
    /// Retrieve the individual tableview cell
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: TableView IndexPath
    /// - Returns: TechnicianActiveSitesTableViewCell
    func cellForRowAt(_ tableView:UITableView, indexPath: IndexPath) -> TechnicianActiveSitesTableViewCell{
        let cell:TechnicianActiveSitesTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: TechnicianActiveSitesTableViewCell.identifier, for: indexPath) as! TechnicianActiveSitesTableViewCell
        let assignmentData = self.data[indexPath.row]
        cell.updateRowData(assignment: assignmentData)
        return cell
        
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - tableView: TableView
    ///   - indexPath: TableView IndexPatth
    /// - Returns: Site Model data
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) -> AssignmentModel {
        return self.data[indexPath.row]
    }
}

//MARK : Google Map Delegate
extension TechnicianActiveSitesViewModel{
    func didTap(_ mapView: GMSMapView,marker: GMSMarker) -> Bool {
        if let userData = marker.userData as? AssignmentModel {
            switch userData.jobStatus {
            case .inspect:
                marker.icon = UIImage.init(named: "marker_inspect")
            case .fix:
                marker.icon = UIImage.init(named: "marker_fix")
            case .complete:
                marker.icon = UIImage.init(named: "marker_completed")
            default:
                break
            }
        }
        return false
    }
    func didCloseInfoWindowOf(_ mapView: GMSMapView, marker: GMSMarker) {
        if let userData = marker.userData as? AssignmentModel {
            switch userData.jobStatus {
            case .inspect:
                marker.icon = UIImage.init(named: "marker_inspect")
            case .fix:
                marker.icon = UIImage.init(named: "marker_fix")
            case .complete:
                marker.icon = UIImage.init(named: "marker_completed")
            default:
                break
            }
        }
    }
    
    func didTapMarkInfo(marker: GMSMarker) -> AssignmentModel?{
        if let data = marker.userData as? AssignmentModel{
            return data;
        }
        return nil
    }
    
    func reloadMapView(_ mapView:BaseMapView){
        mapView.clear()
        let path = GMSMutablePath()
        if self.data.count > 0 {
            for siteData in self.data{
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(siteData.siteLatitude),longitude:CLLocationDegrees(siteData.siteLongitude))
                let marker = GMSMarker.init()
                marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                marker.title = siteData.siteName
                marker.snippet = siteData.siteAddress
                marker.userData = siteData
                switch siteData.jobStatus {
                case .inspect:
                    marker.icon = UIImage.init(named: "marker_inspect")
                case .fix:
                    marker.icon = UIImage.init(named: "marker_fix")
                case .complete:
                    marker.icon = UIImage.init(named: "marker_completed")
                default:
                    break
                }
                marker.map = mapView
                path.add(coordinate)
            }
        }
        
        let currentStatus = SwiftLocation.authorizationStatus
        if (currentStatus == .authorizedAlways ||  currentStatus == .authorizedWhenInUse){
            LocationManager.getCurrentLocation { location in
                if let location = location {
                    let marker = GMSMarker.init()
                    marker.icon = UIImage.init(named: "marker_home")
                    marker.map = mapView
                    marker.position = location.coordinate
                    path.add(location.coordinate)
                }
                let bounds = GMSCoordinateBounds(path: path)
                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 90, left: 40, bottom: 40, right: 40))
                mapView.animate(with: update)
            }
        }else{
            let bounds = GMSCoordinateBounds(path: path)
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 90, left: 40, bottom: 40, right: 40))
            mapView.animate(with: update)
        }
    }
}
