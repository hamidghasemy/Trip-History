//
//  NewFriendFotter.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/15/23.
//

import Foundation
import Contacts

class NewFriendFotter : UICollectionReusableView {
    
    @IBOutlet weak var btnContacts: UIButton!
    @IBOutlet weak var txtName: UITextField!
    
    public var personViewModel : PersonViewModel = PersonViewModel()
    
    @IBAction func saveClick(_ sender: Any) {
        if let name = txtName.text{
            personViewModel.insert(name: name)
        }
    }
    
}
