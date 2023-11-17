//
//  VCNewEditTrip.swift
//  Trips History
//
//  Created by Hamid Ghasemi on 11/14/23.
//

import Foundation
import Contacts

class TripViewController : UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , ContactHelperDelegate{
    
    //Views
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    //View Models
    let personViewModel = PersonViewModel()
    var tripViewModel : TripViewModel?
    
    //Optional Properties
    var editTrip : Trip?
    var newTripLat : Double?
    var newTripLong : Double?
    
    var selectedFriends = [IndexPath] ()
    var contactHelper : ContactHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initObservers()
        prepareCollectionView()
        prepareEditTrip()
    }
    
    override func viewWillAppear(_ animated: Bool) { friendsCollectionView.reloadData() }
    
    func initObservers(){
        personViewModel.onPersonArrayUpdate = { [weak self] in
            self?.friendsCollectionView.reloadData()
        }
    }
    
    func prepareCollectionView(){
        friendsCollectionView.allowsMultipleSelection = true
        
        friendsCollectionView.register(UINib(nibName: "FriendCell", bundle: nil), forCellWithReuseIdentifier: "FriendCell")
        friendsCollectionView.register(UINib(nibName: "NewFriendFotter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "NewFriendFotter")
        
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
    }
    
    func prepareEditTrip(){
        if let trip = editTrip{
            self.saveButton.setTitle("Update Trip", for: .normal)
            self.removeButton.isHidden = false
            self.titleTextField.text = trip.title
            selectedFriends = personViewModel.indexOfPersons(frineds: trip.friends as! Set<Person>)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return personViewModel.count()}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UICollectionViewCell()
        }
        
        let person = personViewModel.getPerson(index: indexPath.row)
        cell.lblName.text = person.name
        if selectedFriends.contains(indexPath) { cell.contentView.backgroundColor = UIColor.blue }
        else { cell.contentView.backgroundColor = UIColor.clear }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter{
            if let fotter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "NewFriendFotter", for: indexPath) as? NewFriendFotter{
                fotter.personViewModel = personViewModel
                fotter.btnContacts.addTarget(self, action: #selector(showContacts), for: .touchUpInside)
                return fotter
            }
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedFriends.contains(indexPath){ selectedFriends = selectedFriends.filter { $0 != indexPath} }
        else { selectedFriends.append(indexPath) }
        collectionView.reloadData()
    }

    @objc func showContacts(){
        if contactHelper == nil{
            contactHelper = ContactHelper.init(viewController: self);
            contactHelper.delegate = self
        }
        contactHelper.show()
    }
    
    func onContactSelected(name : String){ personViewModel.insert(name: name) }
    
    @IBAction func removeClicked(_ sender: Any) {
        if let trip = editTrip{
            tripViewModel?.remove(trip: trip)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let allPersons = personViewModel.getAll()
        let selectedPersons = selectedFriends.compactMap { allPersons[$0.row] }
        let title = titleTextField.text
        
        if let trip = editTrip{
            tripViewModel?.update(trip: trip , title: title , friendsArray: selectedPersons)
        } else{
            tripViewModel?.insert(title: title!, lat: newTripLat! , long: newTripLong!, friends: selectedPersons)
        }
        self.dismiss(animated: true)
    }
    
}
