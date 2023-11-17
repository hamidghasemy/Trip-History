//
//  ContactHelper.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/15/23.
//

import Foundation
import Contacts
import ContactsUI

class ContactHelper : NSObject , CNContactPickerDelegate{
    
    let contactStore = CNContactStore()
    weak var viewController : UIViewController?
    weak var delegate : ContactHelperDelegate?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func show(){
        self.requestContactsAccess()
    }
    
    func requestContactsAccess() {
        contactStore.requestAccess(for: .contacts) { (granted, error) in
            if granted {
                self.showContactPicker()
            } else {
                print("Access to contacts not granted")
            }
        }
    }
    
    private func showContactPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        viewController?.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contactName = "\(contact.givenName) \(contact.familyName)"
        self.delegate?.onContactSelected(name: contactName)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.delegate?.onCanceled!()
    }
    
    
}

@objc protocol ContactHelperDelegate : AnyObject{
    func onContactSelected(name : String)
    @objc optional func onCanceled()
}
