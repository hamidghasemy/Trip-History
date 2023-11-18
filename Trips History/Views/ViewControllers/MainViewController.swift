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
    @IBOutlet weak var addressLabel: UILabel!
    
    //Model Views
    let locationViewModel = LocationViewModel()
    let tripViewModel = TripViewModel()
    let neshanApiViewModel = NeshanApiViewModel()
    
    var newTripLocation : NTLngLat?
    var contactHelper : ContactHelper!
    
    private var tripsMarker = [NTMarker]()
    private var selectedMarker : NTMarker?
    private var currentMarker : NTMarker?
    
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
        tripViewModel.onTripArrayUpdate = { self.updateTripsOnMap() }
        
        locationViewModel.locationUpdateHandler = { [weak self] location in
            self?.updateCurrentOnMap(location: NTLngLat(x:location.coordinate.longitude , y:location.coordinate.latitude))
            self?.locationViewModel.stopLocationUpdate()
        }
        
        neshanApiViewModel.onReadyAddress = { address in
            self.addressLabel.isHidden = false
            self.addressLabel.text = address
        }
    }
    
    func prepareMap () {
        map.initMap(cameraLocation: CustomeNeshanMapView.MASHHAD!, zoom: 13, style: NTNeshanMapStyle.STANDARD_NIGHT)
        
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapClickedBlock =  { [self] clickInfo in
            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_LONG {
                newTripLocation = clickInfo.getClickPos()
                if let marker = selectedMarker { map.removeMarker(marker: marker)}
                selectedMarker = map.addMarker(loc: newTripLocation!, markerImage: CustomeNeshanMapView.MARKER_IMAGE_3)
                if let location = newTripLocation { neshanApiViewModel.neshanReverseAPI(location: location) }
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
                    addressLabel.isHidden = true
                    if let marker = selectedMarker { map.removeMarker(marker: marker) }
                }
                else{
                    AlertHelper.showAlert(message: "First select trip location by long click on the map", title: "Location is not Selected!", vc: self)
                    return
                }
            }
        }
    }
    
    func updateTripsOnMap(){
        for marker in tripsMarker{ map.removeMarker(marker:marker) }
        tripsMarker.removeAll()
        let trips = tripViewModel.getAll()
        for trip in trips {
            if let location = NTLngLat(x: trip.latuide, y: trip.longtuide){
                if let marker = map.addMarker(loc: location, markerImage: CustomeNeshanMapView.MARKER_IMAGE_2) {
                    tripsMarker.append(marker)
                }
            }
        }
    }
    
    func updateCurrentOnMap(location : NTLngLat){
        if let marker = currentMarker { map.removeMarker(marker: marker) }
        currentMarker = map.addMarker(loc: location, markerImage: CustomeNeshanMapView.MARKER_IMAGE_1)
        map.setCamera(location: location)
    }
    
    @IBAction func myLocClick(_ sender: Any) {
        locationViewModel.requestLocationUpdate()
    }
}

