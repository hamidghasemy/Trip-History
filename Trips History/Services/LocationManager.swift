//
//  LocationManager.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/16/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error on location manager \(error.localizedDescription)")
    }
    
    func requestLocationUpdate(){
        locationManager.requestLocation()
    }
    
    func stopLocationUpdate(){
        locationManager.stopUpdatingLocation()
    }
}

