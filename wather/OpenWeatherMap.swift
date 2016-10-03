//
//  OpenWeatherMap.swift
//  wather
//
//  Created by 1 on 28/09/16.
//  Copyright © 2016 dima. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation


protocol OpenWeatherMapDelegate {
    
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
    
}


class OpenWeatherMap {
    
     let weatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast?&&APPID=87159f509b2ef104a1109320fe4cc92c")!
    
    var delegate: OpenWeatherMapDelegate!
    
    func getWeatherFor(city: String){
            
        let params = ["q" : city]
        setReqest(parameters: params as [String : AnyObject]?)

    }
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        
        let params = ["lat" : geo.latitude, "lon" : geo.longitude]
        setReqest(parameters: params as [String : AnyObject]?)
        
    }
    
    func setReqest(parameters: [String : AnyObject]?){
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet Connection Available!")
            request(weatherUrl, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
                
                if let result = response.result.value {
                
                    let weatherJson = JSON(result)
                    DispatchQueue.main.async {
                        self.delegate.updateWeatherInfo(weatherJson: weatherJson)}
                    }
            }
        } else {
            
            print("Internet Connection not Available!")
                DispatchQueue.main.async {
                    self.delegate.failure() }
                }
    }
    

    
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
        
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool, index: Int, weatherIcon:(_ index: Int, _ icon: String) -> () ) {
    
        switch (condition, nightTime) {
        
        case let (x,y) where x < 300 && y == true:  weatherIcon(index, "11n")
        case let (x,y) where x < 300 && y == false: weatherIcon(index, "11d")
            
        case let (x,y) where x < 500 && y == true:  weatherIcon(index, "09n")
        case let (x,y) where x < 500 && y == false: weatherIcon(index, "09d")
            
        case let (x,y) where x <= 504 && y == true:  weatherIcon(index, "10n")
        case let (x,y) where x <= 504 && y == false: weatherIcon(index, "10d")
            
        case let (x,y) where x == 511 && y == true:  weatherIcon(index, "13n")
        case let (x,y) where x == 511 && y == false: weatherIcon(index, "13d")
            
        case let (x,y) where x < 600 && y == true:  weatherIcon(index, "09n")
        case let (x,y) where x < 600 && y == false: weatherIcon(index, "09d")
            
        case let (x,y) where x < 700 && y == true:  weatherIcon(index, "13n")
        case let (x,y) where x < 700 && y == false: weatherIcon(index, "13d")
            
        case let (x,y) where x < 800 && y == true:  weatherIcon(index, "50n")
        case let (x,y) where x < 800 && y == false: weatherIcon(index, "50d")
            
        case let (x,y) where x == 800 && y == true:  weatherIcon(index, "01n")
        case let (x,y) where x == 800 && y == false: weatherIcon(index, "01d")
            
        case let (x,y) where x < 801 && y == true:  weatherIcon(index, "02n")
        case let (x,y) where x < 801 && y == false: weatherIcon(index, "02d")
            
        case let (x,y) where x > 802 || x < 804 && y == true:   weatherIcon(index, "03n")
        case let (x,y) where x > 802 || x < 804 && y == false:  weatherIcon(index, "03d")
            
        case let (x,y) where x == 804 && y == true:  weatherIcon(index,"04n")
        case let (x,y) where x == 804 && y == false: weatherIcon(index, "04d")
            
        case let (x,y) where x < 1000 && y == true:  weatherIcon(index, "11n")
        case let (x,y) where x < 1000 && y == false: weatherIcon(index, "11d")
            
        case let (x,y): weatherIcon(index, "none")

            
        }

    }
    
    
    
    func converteTemperature(country: String, temperature: Double) -> Double {
        
        if country == "US"{
            // converte to F
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            // converte to C
            return round(temperature - 273.15)
        }
    
    }
    
    func isTimeNight(icon: String) -> Bool {
    
        return icon.range(of: "n") != nil
    }
    
//    func isTimeNight(weatherJson: JSON) -> Bool {
//        
//        var nightTime = false
//        let nowTime = NSDate().timeIntervalSince1970
//        let sunrise = weatherJson["sys"]["sunrise"].double
//        let sunset = weatherJson["sys"]["sunset"].double
//        
//        if (nowTime < sunrise! || nowTime > sunset!) {
//            nightTime = true
//        }
//        return nightTime
//    }

}

