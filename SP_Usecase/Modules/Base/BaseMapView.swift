//
//  BaseMapView.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftLocation

class BaseMapView: GMSMapView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.settings.myLocationButton = true
        self.settings.compassButton = true
        LocationManager.getCurrentLocation { location in
            if let _ = location {
                self.isMyLocationEnabled = true
            }
        }
    }
    
}
