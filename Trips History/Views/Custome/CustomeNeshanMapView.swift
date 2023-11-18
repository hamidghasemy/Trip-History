//
//  CustomeMapView.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/17/23.
//

import Foundation

class CustomeNeshanMapView : NTMapView {
    
    static let MARKER_IMAGE_1 = "map-red-pin"
    static let MARKER_IMAGE_2 = "map"
    static let MARKER_IMAGE_3 = "map-green-pin"
    
    static let MASHHAD = NTLngLat(x: 59.6067, y: 36.2972)
    static let TEHRAN = NTLngLat(x: 51.330743, y: 35.767234)
    
    private var markerLayer = NTVectorElementLayer()
 
    func initMap(cameraLocation : NTLngLat , zoom : Float , style : NTNeshanMapStyle) {
        markerLayer = NTNeshanServices.createVectorElementLayer()
        self.getLayers().add(markerLayer)
        self.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(style)
        self.getLayers()?.insert(0, layer: baseMap)
        self.setZoom(zoom, durationSeconds: 0.5)
        setCamera(location: cameraLocation)
    }
    
    
    func setCamera(location : NTLngLat){
        self.setFocalPointPosition(location, durationSeconds: 0.5)
    }
    
    func addMarker(loc: NTLngLat , markerImage : String) -> NTMarker?{
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: markerImage)))
        var markSt = NTMarkerStyle()
        markSt = markStCr!.buildStyle()
        if let marker = NTMarker(pos: loc, style: markSt) {
            marker.setMetaData("id", element: NTVariant(doubleVal: 1))
            markerLayer.add(marker)
            return marker
        }
        return nil
    }
    
    func removeMarker (marker : NTMarker){
        markerLayer.remove(marker)
    }
    
}
