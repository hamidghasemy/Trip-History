//
//  NeshanApiViewModel.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/18/23.
//

import Foundation
class NeshanApiViewModel {
    
    var onReadyAddress: ((String) -> Void)?
    
    func neshanReverseAPI(location: NTLngLat) {
        
        let manager = NeshanApiManager(
            onDone: { resultDic in
                var textResult = ""
                
                if let neighbour = resultDic[NeshanApiManager.REVERSE_RESULT_NEIGHBOURHOOD_KEY]{
                    if neighbour != "" { textResult = textResult + " در همسایگی : \(neighbour)" }
                }
                
                if let address = resultDic[NeshanApiManager.REVERSE_RESULT_ADDRESS_KEY]{
                    if address != "" { textResult = textResult + " آدرس : \(address)" }
                }
                self.onReadyAddress?(textResult)
                
            },
            onError: {errorMessage in
                print(errorMessage)
            })
        manager.reverse(location: location)
    }
}
