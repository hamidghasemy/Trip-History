//
//  LocationViewModel.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/16/23.
//

import Foundation
import CoreLocation

class LocationViewModel {
    private var locationManager = LocationManager()
    var locationUpdateHandler: ((CLLocation) -> Void)?

    init() {
        locationManager.locationUpdateHandler = { [weak self] location in
            self?.locationUpdateHandler?(location)
        }
    }
    
    func requestLocationUpdate() { locationManager.requestLocationUpdate() }
    
    func stopLocationUpdate(){ locationManager.stopLocationUpdate() }
}
