//
//  WeatherLocation.swift
//  Weather Gift
//
//  Created by Ale Escalante on 3/17/19.
//  Copyright © 2019 Ale Escalante. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
    func getWeather(completed: @escaping() -> () ) {  // the parameters have me a little confused -- in what case would you put something in them
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double{
                    print("**** temperature inside getWeather = \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                }else{
                    print("Could not return a temperature")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
