//
//  TechnicianCompletedSitesViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import GoogleMaps
import SwiftLocation
import CoreLocation

protocol TechnicianCompletedSitesProtocol:BaseProtocol {
    
}

class TechnicianCompletedSitesViewModel: BaseViewModel {
    weak var delegate: TechnicianCompletedSitesProtocol?
    fileprivate var data:[AssignmentModel] = []
    
    func getPageTitle() -> String{
        let countString = (self.data.count > 0) ? "(\(self.data.count))" : ""
        return "Completed Sites" + countString
    }
    
    func fetchAssignmentList(){
        AssignmentServiceManager.getAssignentsList { [weak self](assignmentList) in
            if let weakSelf = self {
                weakSelf.data = []
                let temp = assignmentList.filter {
                    return $0.jobStatus == TechnicianActiveSitesStatus.complete
                }
                weakSelf.data.append(contentsOf: temp)
                weakSelf.delegate?.reloadTableData()
            }
        } _: { [weak self](error) in
            if let weakSelf = self {
                weakSelf.delegate?.reloadTableData()
            }
        }

    }
    
//    func processData(){
//        self.data.append(SiteModel.init(name: "North-South 11 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta", latitude: 1.27899924309964, longitude: 103.844679920086, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 12 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta", latitude: 1.36334651886138, longitude: 103.834839633876, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 13 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque.", latitude: 1.33415949631122, longitude: 103.739318522386, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 14 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta.4", latitude: 1.3270026199524, longitude: 103.848267774628, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 15 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. 5", latitude: 1.28136301224216, longitude: 103.850919074926, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 16 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta. 6", latitude: 1.28705272991924, longitude: 103.840803848104, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 17 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta. 7", latitude: 1.28513346970148, longitude: 103.852316037433, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 18 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. 8", latitude: 1.30913983323922, longitude: 103.862217804276, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 19 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. In tincidunt tincidunt tortor quis porta. 9", latitude: 1.36754924977905, longitude: 103.836740628478, status:.complete)!)
//        self.data.append(SiteModel.init(name: "North-South 20 - Gambas (Permanent Shaft)", desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus pellentesque felis condimentum scelerisque. 10", latitude: 1.33407189658892, longitude: 103.904054100566, status:.complete)!)
//    }
}

extension TechnicianCompletedSitesViewModel{
    /// Retrieve the total number of rows in each section
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
    func cellForRowAt(_ tableView:UITableView, indexPath: IndexPath) -> TechnicianCompletedSitesTableViewCell{
        let cell:TechnicianCompletedSitesTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: TechnicianCompletedSitesTableViewCell.identifier, for: indexPath) as! TechnicianCompletedSitesTableViewCell
        let siteData = self.data[indexPath.row]
        cell.siteNameText = siteData.siteName
        cell.descriptionText = siteData.siteAddress
        cell.selectionStyle = .none
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
extension TechnicianCompletedSitesViewModel{
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
