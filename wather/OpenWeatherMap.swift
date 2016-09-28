//
//  OpenWeatherMap.swift
//  wather
//
//  Created by 1 on 28/09/16.
//  Copyright © 2016 dima. All rights reserved.
//

import Foundation
import UIKit

class OpenWeatherMap {
    
    var nameCity: String
    var temp: Int
    var description: String
    var currentTime: String?
    var image: UIImage?
    
    init(weatherJson: NSDictionary) {
        nameCity = weatherJson["name"] as! String
        
        let main = weatherJson["main"] as! NSDictionary
        temp = main["temp"] as! Int
        
        let weather = weatherJson["weather"] as! NSArray
        let zero = weather[0] as! NSDictionary
        description = zero["description"] as! String
        
        let dt = weatherJson["dt"] as! Int
        currentTime = timeFromUnix(unixTime: dt)
        
        let icon = zero["icon"] as! String
        image = weatherIcon(stringIcon: icon)

        
    }
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
        
    }
    
    func weatherIcon(stringIcon: String) -> UIImage{
        
        let imageName: String
        
        switch stringIcon {
        case "01d": imageName = "01d"
        case "02d": imageName = "02d"
        case "03d": imageName = "03d"
        case "04d": imageName = "04d"
        case "09d": imageName = "09d"
        case "10d": imageName = "10d"
        case "11d": imageName = "11d"
        case "13d": imageName = "13d"
        case "50d": imageName = "50d"
        case "01n": imageName = "01n"
        case "02n": imageName = "02n"
        case "03n": imageName = "03n"
        case "04n": imageName = "04n"
        case "09n": imageName = "09n"
        case "10n": imageName = "10n"
        case "11n": imageName = "11n"
        case "13n": imageName = "13n"
        case "50n": imageName = "50n"
        default: imageName = "none"
        }
        let iconImage = UIImage(named: imageName)
        return iconImage!
        
        
        
    }
    
}
