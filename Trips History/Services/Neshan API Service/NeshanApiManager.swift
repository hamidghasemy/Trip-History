//
//  NeshanApiManager.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/18/23.
//

import Foundation

class NeshanApiManager {
    
    public static let REVERSE_RESULT_NEIGHBOURHOOD_KEY = "reverse-neighbourhood"
    public static let REVERSE_RESULT_ADDRESS_KEY = "reverse-address"
    
    var onDone: (([String : String]) -> Void)
    var onError:((String) -> Void)
    
    init(onDone: @escaping ([String : String]) -> Void, onError: @escaping (String) -> Void) {
        self.onDone = onDone
        self.onError = onError
    }
    
    func reverse(location : NTLngLat){
        let url = NeshanUrlMaker.getReverseUrl(location: location)
        
        let requestMaker = NeshanRequestMaker(
            onDone: { result in self.parseReverseResult(data : result) },
            onError: { message in self.onError(message) })
            
        requestMaker.sendRequest(requestURL: url)
    }
    
    func parseReverseResult(data : Data){
        do {
            let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                var resultDic : [String : String] = [:]
                
                if responseObject["neighbourhood"] != nil {
                    if let neighbour = responseObject["neighbourhood"] as? String{
                        resultDic[NeshanApiManager.REVERSE_RESULT_NEIGHBOURHOOD_KEY] = neighbour
                    }
                }
                
                if responseObject["formatted_address"] != nil {
                    if let address = responseObject["formatted_address"] as? String{
                        resultDic[NeshanApiManager.REVERSE_RESULT_ADDRESS_KEY] = address
                    }
                }
                
                onDone(resultDic)
        } catch let error {
            onError(error.localizedDescription)
        }
    }
    
    
}
