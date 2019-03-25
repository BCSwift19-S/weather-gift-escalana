//
//  DetailVC.swift
//  Weather Gift
//
//  Created by Ale Escalante on 3/10/19.
//  Copyright © 2019 Ale Escalante. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd, y"
    return dateFormatter
}()

class DetailVC: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManger: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
                self.updateUserInterface()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        if currentPage == 0 {
            getLocation()
        }
    }
    func updateUserInterface(){
        let location = locationsArray[currentPage]
        locationLabel.text = location.name
//        let dateString = formatTimeForTimeZone(unixDate: location.currentTime, timeZone: location.timeZone)
        let dateString = location.currentTime.format(timeZone: location.timeZone, dateFormatter: dateFormatter)
        dateLabel.text = dateString
        tempLabel.text = location.currentTemp
        summaryLabel.text = location.dailySummary
        currentImage.image = UIImage(named: location.currentIcon)
        print("%%%% currentTemp inside updateUserInterface = \(location.currentTemp)")  // keeping this for myself
        tableView.reloadData()
    }
//    func formatTimeForTimeZone(unixDate: TimeInterval, timeZone: String) -> String  {
//        let usableDate = Date(timeIntervalSince1970: unixDate)
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
//        let dateString = dateFormatter.string(from: usableDate)
//        return dateString
//    }
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
                self.locationsArray[0].getWeather  {
                     self.updateUserInterface()
                }

                
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get user location")
    }
    
}
extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath )
       // cell.update(with: locationsArray[currentPage].dailyForecastArray[indexPath.row]) // i declared my func in DayWeatherCell.swift  -- I think it's supposed to work but not sure what is wrong
        cell.update(with: dailyForecast, timeZone: timezone)  //  dont understand error here
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
