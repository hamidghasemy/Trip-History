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
    
    static let MASHHAD = NTLngLat(x: 51.330743, y: 35.767234)
    
    var markerLayer = NTVectorElementLayer()
    var marker = NTMarker()
    var animSt = NTAnimationStyle()
    var contactHelper : ContactHelper!
 
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
    
    func addMarker(loc: NTLngLat , markerImage : String) {
        
        // AnimationStyle
//        let animStB1 = NTAnimationStyleBuilder()
//        animStB1?.setFade(NTAnimationType.ANIMATION_TYPE_SMOOTHSTEP)
//        animStB1?.setSizeAnimationType(NTAnimationType.ANIMATION_TYPE_SPRING)
//        animStB1?.setPhaseInDuration(0.5)
//        animStB1?.setPhaseOutDuration(0.5)
//        animSt = animStB1!.buildStyle()
        
        // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
        // and then call buildStyle method on it. This method returns an object of type MarkerStyle
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: markerImage)))
//        markStCr?.setAnimationStyle(animSt)
        var markSt = NTMarkerStyle()
        markSt = markStCr!.buildStyle()
        
        // Creating marker
        marker = NTMarker(pos: loc, style: markSt)
        // Setting a metadata on marker, here we have an id for each marker
        marker.setMetaData("id", element: NTVariant(doubleVal: 1))
        // Adding marker to markerLayer, or showing marker on map!
        markerLayer.add(marker)
        
        
        //        let vectorElementEventListener = VectorElementClickedListener()
        //        vectorElementEventListener?.onVectorElementClickedBlock = {clickInfo in
        //            // If a double click happens on a marker...
        //            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_DOUBLE {
        //                let removeId = (clickInfo.getVectorElement().getMetaDataElement("id").getDouble())
        //                // updating own ui element must run on ui thread not in map ui thread
        //                DispatchQueue.main.async {
        //                    NeshanHelper.toast(self, message: "Pin number \(Int(removeId)) removed")
        //                }
        //                //getting marker reference from clickInfo and remove that marker from markerLayer
        //                self.markerLayer.remove(clickInfo.getVectorElement())
        //
        //            // If a single click happens...
        //            } else if clickInfo.getClickType() == NTClickType.CLICK_TYPE_SINGLE {
        //                // changing marker to blue
        //                self.changeMarkerToBlue(redMarker: NTMarker(pos: clickInfo.getClickPos(), style: markSt))
        //            }
        //            return true
        //        }
        //        markerLayer.setVectorElementEventListener(vectorElementEventListener)
    }
    
    func changeMarkerToBlue(redMarker: NTMarker) {
        // create new marker style
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(20)
        // Setting a new bitmap as marker
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic-map-marker")))
        // AnimationStyle object - that was created before - is used here
        markStCr?.setAnimationStyle(animSt)
        let blueMarkSt = markStCr?.buildStyle()
        // changing marker style using setStyle
        redMarker.setStyle(blueMarkSt)
    }
}
