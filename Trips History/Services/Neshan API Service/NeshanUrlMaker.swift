//
//  NeshanUrlMaker.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/18/23.
//

import Foundation

class NeshanUrlMaker {
    private static let BASE_URL = "https://api.neshan.org/v2/"
    
    public static func getReverseUrl(location : NTLngLat) -> String{
        let url: String = String(format: "%@/reverse?lat=%f&lng=%f", BASE_URL,location.getY(), location.getX())
        return url
    }
}
