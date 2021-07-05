//
//  ManagerDashboardViewModel.swift
//  SP_Usecase
//
//  Created by Salim Kutubbhai on 30/6/21.
//

import UIKit
import GoogleMaps
import SwiftLocation
import CoreLocation

protocol ManagerJobsProtocol:BaseProtocol {
    
}

class ManagerJobsViewModel: BaseViewModel {
    
    weak var delegate: ManagerJobsProtocol?
    
    var assignmentsData:[AssignmentModel] = []
    private var filteredData: [AssignmentModel] = []
    private var searchedData: [AssignmentModel] = []
    
    // Filter conditions
    var currentAsigneeEmails = [String]()
    var currentStatus = [TechnicianActiveSitesStatus]()
    
    func fetchAssignmentList()
    {
        AssignmentServiceManager.getAssignentsList { [weak self](assignmentList) in
            if let weakSelf = self {
                // clear filter conditions
                weakSelf.currentAsigneeEmails = []
                weakSelf.currentStatus = []
                weakSelf.filteredData = []
                weakSelf.searchedData = []
                weakSelf.assignmentsData = []
                let sorted = assignmentList.sorted { return $0.jobStatus.rawValue > $1.jobStatus.rawValue }
                weakSelf.assignmentsData.append(contentsOf: sorted)
                
                if let delegate = weakSelf.delegate{
                    delegate.reloadTableData()
                }
            }
        } _: { [weak self](error) in
            if let weakSelf = self, let delegate = weakSelf.delegate{                
                delegate.reloadTableData()
            }
        }
    }
    
    func search(_ text: String) {
        if text.isEmpty {
            if !filteredData.isEmpty {
                searchedData = filteredData
            } else {
                searchedData = []
            }
        } else {
            let dataToBeSearched = filteredData.isEmpty ? self.assignmentsData : filteredData
            searchedData = dataToBeSearched.filter { assignment in
                return assignment.siteName.contains(text)
            }
        }
        delegate?.reloadTableData()
    }
    
    func filter(asigneeEmails: [String], status: [TechnicianActiveSitesStatus], searchText: String) {
        currentAsigneeEmails = asigneeEmails
        currentStatus = status
        
        if asigneeEmails.isEmpty && status.isEmpty {
            self.filteredData = []
            if searchText.isEmpty {
                self.searchedData = []
            }
        } else {        
            // use original data to filter
            self.filteredData = assignmentsData.filter { item in
                if !asigneeEmails.isEmpty {
                    if !asigneeEmails.contains(item.asigneeEmail) {
                        return false
                    }
                }
                if !status.isEmpty {
                    if !status.contains(item.jobStatus) {
                        return false
                    }
                }
                return true
            }
        }
        
        if !searchText.isEmpty {
            search(searchText)
        } else {
            delegate?.reloadTableData()
        }
    }
    
    func badgeValue() -> Int {
        return currentStatus.count + currentAsigneeEmails.count
    }
    
}
// MARK: TableView Data source and Delegate
extension ManagerJobsViewModel{
    
    func numberOfSectionInTable() -> Int {
        return 1
    }
    
    
    func numberOfRowsInSection(section:Int) -> Int{
        return assignmentDataToBeUsed().count
    }
    
    func cellForRowAtIndex(_ tableView:UITableView, indexPath:IndexPath) -> UITableViewCell{
        let cell:ManagerJobsTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: ManagerJobsTableViewCell.identifier, for: indexPath) as! ManagerJobsTableViewCell
        cell.updateCellData(assignment: assignmentDataToBeUsed()[indexPath.row])
        return cell
    }
    
    func didSelectCellRowAtIndex(indexPath:IndexPath) -> AssignmentModel {
        return assignmentDataToBeUsed()[indexPath.row]
    }
    
    private func assignmentDataToBeUsed() -> [AssignmentModel] {
        if !searchedData.isEmpty {
            return searchedData
        }
        if !filteredData.isEmpty {
            return filteredData
        }
        return assignmentsData
    }
}

//MARK : Google Map Delegate
extension ManagerJobsViewModel{
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
        if self.assignmentsData.count > 0
        {
            for assignment in assignmentsData{

                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(assignment.siteLatitude),longitude:CLLocationDegrees(assignment.siteLongitude))

                let marker = GMSMarker.init()
                marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                marker.title = assignment.siteName
                marker.snippet = assignment.siteAddress
                marker.userData = assignment
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
