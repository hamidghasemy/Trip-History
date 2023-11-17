//
//  FriendViewModel.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/14/23.
//

import Foundation
import CoreData

class PersonViewModel : NSObject{
    
    var onPersonArrayUpdate: (() -> Void)?
    
    private var personsArray : [Person]! { didSet{ onPersonArrayUpdate?() }}
    
    override init() {
        super.init()
        self.fetchAll()
    }
    
    public func insert(name : String){
        guard let context = CoreDataHelper.getContext() else { return }
        let p = Person(context: context)
        p.name = name
        do { try context.save() }
        catch let error as NSError{ print("Could not insert the Person. \(error), \(error.userInfo)") }
        fetchAll()
    }
    
    public func remove(person : Person){
        guard let context = CoreDataHelper.getContext() else { return }
        context.delete(person)
        fetchAll()
    }
    
    private func fetchAll (){
        guard let context = CoreDataHelper.getContext() else { return }
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        do{
            let persons = try context.fetch(fetchRequest)
            self.personsArray = [Person]()
            for person in persons{
                self.personsArray.append(person)
            }
        } catch let error as NSError{ print("Could not fetch Persons. \(error), \(error.userInfo)") }
    }
    
    public func getAll() -> [Person] { return self.personsArray}
    
    public func getPerson(index : Int) -> Person { return self.personsArray[index]}
    
    public func count() -> Int {return self.personsArray.count}
    
    public func indexOfPersons(frineds : Set<Person>) -> [IndexPath]{
        let allPersons = getAll()
        var selectedFriends = [IndexPath]()
        for friend in frineds{
            if let index = allPersons.firstIndex(of: friend){
                selectedFriends.append(IndexPath(row: index, section: 0))
            }
        }
        return selectedFriends
    }
    
}
