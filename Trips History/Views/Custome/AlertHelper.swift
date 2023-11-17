//
//  Alert.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/15/23.
//

import Foundation

class AlertHelper {
    public static func showAlert(message: String , title: String ,vc : UIViewController) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
