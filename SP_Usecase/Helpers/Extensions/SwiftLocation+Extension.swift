//
//  SwiftLocation+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit
import SwiftLocation
import CoreLocation

extension LocationManager{
    
    /// Retrieve current location
    /// - Parameter completion: current location
   class func getCurrentLocation(completion:@escaping((_ location: CLLocation?) -> Void)){
        let currentStatus = SwiftLocation.authorizationStatus
        switch currentStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                SwiftLocation.gpsLocation(accuracy: .neighborhood).then { result in
                    switch result {
                    case .success(let location):
                        completion(location)
                        break
                    case .failure(_):
                        completion(nil)
                        break
                    }
                }
            break;
        case .notDetermined:
            SwiftLocation.requestAuthorization { status in
                SwiftLocation.gpsLocation(accuracy: .neighborhood).then { result in
                    switch result {
                    case .success(let location):
                        completion(location)
                        break
                    case .failure(_):
                        completion(nil)
                        break
                    }
                }
            }
            break;
        default:
            completion(nil)
            break;
        }
    }
    
}
