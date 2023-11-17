//
//  TripViewModel.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/15/23.
//

import Foundation
import CoreData

class TripViewModel : NSObject{
    
    var onTripArrayUpdate: (() -> Void)?
    
    private var tripArray : [Trip]! { didSet{ onTripArrayUpdate?() }}
    
    override init() {
        super.init()
        self.fetchAll()
    }
    
    public func update(trip: Trip , title : String? = nil, lat : Double? = nil , long : Double? = nil , friendsArray : [Person]? = nil){
        guard let context = CoreDataHelper.getContext() else { return }
        trip.title = title ?? trip.title
        trip.latuide = lat ?? trip.latuide
        trip.longtuide = long ?? trip.longtuide
        if let friends = friendsArray{
            trip.friends = []
            trip.addToFriends(NSSet(array: friends))
        }
        do { try context.save() }
        catch let error as NSError{ print("Could not save. \(error), \(error.userInfo)") }
        fetchAll()
    }
    
    public func insert(title : String , lat : Double , long : Double , friends : [Person]){
        guard let context = CoreDataHelper.getContext() else { return }
        let trip = Trip(context: context)
        trip.title = title
        trip.latuide = lat
        trip.longtuide = long
        trip.addToFriends(NSSet(array: friends))
        do { try context.save() }
        catch let error as NSError{ print("Could not save. \(error), \(error.userInfo)") }
        fetchAll()
    }
    
    public func update () {
        guard let context = CoreDataHelper.getContext() else { return }
        do{ try context.save() }
        catch let error as NSError{ print("Could not update . \(error), \(error.userInfo)") }
        fetchAll()
    }
    
    public func remove(trip : Trip){
        guard let context = CoreDataHelper.getContext() else { return }
        context.delete(trip)
        fetchAll()
    }
    
    private func fetchAll (){
        guard let context = CoreDataHelper.getContext() else { return }
        let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        do{
            let trips = try context.fetch(fetchRequest)
            self.tripArray = [Trip]()
            for trip in trips{
                self.tripArray.append(trip)
            }
        } catch let error as NSError{ print("Could not fetch . \(error), \(error.userInfo)") }
    }
    
    public func getAll() -> [Trip] { return self.tripArray}
    
    public func getTrip(index : Int) -> Trip { return self.tripArray[index]}
    
    public func count() -> Int {return self.tripArray.count}
    
    public func getTitle (index : Int) -> String {return self.tripArray[index].title ?? "NO-TITLE"}
    
    public func getDescription (index : Int) -> String {
        let trip = getTrip(index: index)
        var description = "Trip with:"
        if let persons = trip.friends as? Set<Person>{
            for person in persons {
                description = description + " " + (person.name ?? "NO-NAME")
            }
        }
        return description
    }
    
    
}
