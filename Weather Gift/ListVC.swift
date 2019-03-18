//
//  ListVC.swift
//  Weather Gift
//
//  Created by Ale Escalante on 3/10/19.
//  Copyright © 2019 Ale Escalante. All rights reserved.
//

import UIKit
import GooglePlaces

class ListVC: UIViewController {
    
    var locationsArray = [WeatherLocation] ()
    var currentPage = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self 
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ToPageVC"{
            let destination = segue.destination as! PageVC
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            destination.currentPage = currentPage
            destination.locationsArray = locationsArray
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true{ // if button clicked while editing, want the done button
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
    }
    
}
extension ListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row].name
        return cell
    }
    //MARK: - tableView Editing Functions
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            locationsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = locationsArray[sourceIndexPath.row]
        locationsArray.remove(at: sourceIndexPath.row)
        locationsArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row != 0{
//            return true
//        } else {
//            return false
//        }
        return(indexPath.row != 0 ? true : false)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row != 0{
//            return true
//        } else {
//            return false
//        }
        return(indexPath.row != 0 ? true : false)
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        if proposedDestinationIndexPath.row == 0 {
//            return sourceIndexPath
//        }else{
//            return proposedDestinationIndexPath
//        }
        return(proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath)
    }
    func updateTable(place: GMSPlace) {
        let newIndexPath = IndexPath(row: locationsArray.count, section: 0)
        var newWeatherLocation = WeatherLocation()
        newWeatherLocation.name = place.name!
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        newWeatherLocation.coordinates = "\(latitude), \(longitude)"
        print(newWeatherLocation.coordinates)
        locationsArray.append(newWeatherLocation)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
}
extension ListVC: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        dismiss(animated: true, completion: nil)
        updateTable(place: place)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //TO DO: handle error
        print("Error:", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //user cancelled the operation
        dismiss(animated: true, completion: nil)
    }
    // turn network activity indicator on and off again
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


