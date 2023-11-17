//
//  CoreDataHelper.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/15/23.
//

import Foundation
import CoreData

class CoreDataHelper{
    
    public static func getContext() -> NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
}
