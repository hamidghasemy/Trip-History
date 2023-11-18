//
//  NeshanApiManager.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/18/23.
//

import Foundation

class NeshanRequestMaker{
    
    private static let API_TOKEN = "service.fYFAjXz8Ua8BNbkReNJr66AB9qFTYYfdWUNfSnoM"
    
    var onDone: ((Data) -> Void)
    var onError:((String) -> Void)
    
    init(onDone: @escaping (Data) -> Void, onError: @escaping (String) -> Void) {
        self.onDone = onDone
        self.onError = onError
    }
    
    func sendRequest(requestURL : String) {
        let url: URL = URL(string: requestURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.setValue(NeshanRequestMaker.API_TOKEN, forHTTPHeaderField: "Api-Key")
        
        let session: URLSession = URLSession.shared
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            let httpResponse: HTTPURLResponse = urlResponse as! HTTPURLResponse
            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    if let data = data { self.onDone(data) }
                }
                else {
                    self.onError("Error on neshan API request -> \(requestURL) has HTTP Code \(httpResponse.statusCode)" )
                }
            }
        }
        dataTask.resume()
    }
    
}
