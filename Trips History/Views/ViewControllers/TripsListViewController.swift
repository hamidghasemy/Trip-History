//
//  VCTripList.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/14/23.
//

import Foundation

class TripsListViewController : UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    let tripModelView = TripViewModel()
    @IBOutlet weak var tripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initObservers()
    }
    
    func initObservers(){
        tripModelView.onTripArrayUpdate = {
            self.tripsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tripModelView.count() }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let title = tripModelView.getTitle(index: indexPath.row)
        let description = tripModelView.getDescription(index: indexPath.row)
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editTripSegue", sender: tripModelView.getTrip(index: indexPath.row))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTripSegue" {
            if let vc = segue.destination as? TripViewController{
                if let trip = sender as? Trip{
                    vc.editTrip = trip
                    vc.tripViewModel = self.tripModelView
                }
            }
        }
    }
    
}
