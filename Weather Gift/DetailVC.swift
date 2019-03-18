//
//  DetailVC.swift
//  Weather Gift
//
//  Created by Ale Escalante on 3/10/19.
//  Copyright © 2019 Ale Escalante. All rights reserved.
//

import UIKit
import CoreLocation


class DetailVC: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManger: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }
    func updateUserInterface(){
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
    }
}

extension DetailVC: CLLocationManagerDelegate {
    func getLocation() {
        locationManger = CLLocationManager()
        locationManger.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status{
        case .notDetermined: locationManger.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse: locationManger.requestLocation()
        case .denied: print("Sorry, can't show location. User has not authorized it")
        case .restricted: print("Access denied. Likely parental controls are restrict location services in this app.")
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude), \(currentLongitude)"
        print(currentCoordinates)
        dateLabel.text = currentCoordinates
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
            {placemarks, error in
                if placemarks != nil {
                    let placemarks = placemarks?.last
                    place = (placemarks?.name)!
                } else {
                    print("Error retriving place. Error: \(error!)")
                    place = "Unknown Weather Location"
                }
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentCoordinates
                self.updateUserInterface()
                
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get user location")
    }
    
}
