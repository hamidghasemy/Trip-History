//
//  ViewController.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/14/23.
//

import UIKit

class MainViewController: UIViewController {
    
    //Views
    @IBOutlet weak var map : CustomeNeshanMapView!
    @IBOutlet weak var newEditButton: UIButton!
    
    //Model Views
    let locationViewModel = LocationViewModel()
    let tripViewModel = TripViewModel()
    
    var newTripLocation : NTLngLat?
    var contactHelper : ContactHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareMap()
        locationViewModel.requestLocationUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) { updateTripsOnMap() }
    
    func initObservers(){
        tripViewModel.onTripArrayUpdate = {
            self.updateTripsOnMap()
            self.locationViewModel.requestLocationUpdate()
        }
        
        locationViewModel.locationUpdateHandler = { [weak self] location in
            self?.updateCurrentOnMap(location: NTLngLat(x:location.coordinate.longitude , y:location.coordinate.latitude))
            self?.locationViewModel.stopLocationUpdate()
        }
    }
    
    func prepareMap () {
        map.initMap(cameraLocation: CustomeNeshanMapView.MASHHAD!, zoom: 13, style: NTNeshanMapStyle.STANDARD_NIGHT)
        
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapClickedBlock =  { clickInfo in
            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_LONG {
                self.updateTripsOnMap()
                self.newTripLocation = clickInfo.getClickPos()
                self.map.addMarker(loc: self.newTripLocation!, markerImage: CustomeNeshanMapView.MARKER_IMAGE_3)
                self.locationViewModel.requestLocationUpdate()
            }
        }
        map.setMapEventListener(mapEventListener)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTripSegue" {
            if let destination = segue.destination as? TripViewController {
                if let location = newTripLocation {
                    destination.newTripLat = location.getX()
                    destination.newTripLong = location.getY()
                    destination.tripViewModel = tripViewModel
                    newTripLocation = nil
                }
                else{
                    AlertHelper.showAlert(message: "First select trip location by long click on the map", title: "Location is not Selected!", vc: self)
                    return
                }
            }
        }
    }
    
    func updateTripsOnMap(){
        map.markerLayer.clear()
        let trips = tripViewModel.getAll()
        for trip in trips {
            if let location = NTLngLat(x: trip.latuide, y: trip.longtuide){
                map.addMarker(loc: location, markerImage: CustomeNeshanMapView.MARKER_IMAGE_2)
            }
        }
    }
    
    func updateCurrentOnMap(location : NTLngLat){
        map.addMarker(loc: location, markerImage: CustomeNeshanMapView.MARKER_IMAGE_1)
        map.setCamera(location: location)
    }
    
    @IBAction func myLocClick(_ sender: Any) {
        locationViewModel.requestLocationUpdate()
    }
}

