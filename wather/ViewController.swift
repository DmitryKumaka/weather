//
//  ViewController.swift
//  wather
//
//  Created by 1 on 28/09/16.
//  Copyright © 2016 dima. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation


class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var icon1: UIImage!
    var icon2: UIImage!
    var icon3: UIImage!
    var icon4: UIImage!

    var temp1Text: String!
    var temp2Text: String!
    var temp3Text: String!
    var temp4Text: String!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var openWeather = OpenWeatherMap()
    var hud = MBProgressHUD()
    
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        //set background
        let bg = UIImage(named: "back.jpg")
        self.view.backgroundColor = UIColor(patternImage: bg!)
        
        // set setup
        self.openWeather.delegate =  self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func atCity(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    func displayCity(){
        
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let textField = alert.textFields?.first  {
                self.activityIndicator()
                self.openWeather.getWeatherFor(city: textField.text!)
            }
        }
        alert.addAction(ok)
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func activityIndicator() {
        
        hud.label.text = "loading..."
        hud.dimBackground = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    
    }
    
    // OpenWeatherMAp delegete
    
    func updateWeatherInfo(weatherJson: JSON) {
        
        hud.hide(animated: true)
        
        if let tempResult = weatherJson["list"][0]["main"]["temp"].double{
            
            // get country
            let country = weatherJson["city"]["country"].string
            print(country!)
            
            // get cityName
            let cityName =  weatherJson["city"]["name"].string
            print(cityName!)
            self.cityNameLabel.text = "\(cityName!), \(country!)"
            
            // get time
            let now  = Int(NSDate().timeIntervalSince1970)
            let time = weatherJson["list"][0]["dt"].int
            let timeToStr = openWeather.timeFromUnix(unixTime: now)
            print(timeToStr)
            self.timeLabel.text = "At \(timeToStr) it is"
            
            //get converted temperature
            let temperature = openWeather.converteTemperature(country: country!, temperature: tempResult)
            print(temperature)
            self.tempLabel.text = "\(temperature)°"
            
            // get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].int
            let iconSrt = weather["icon"].string
            let nightTime = openWeather.isTimeNight(icon: iconSrt!)
            openWeather.updateWeatherIcon(condition: condition!, nightTime: nightTime, index: 0, weatherIcon: self.updateIconList)
//            self.iconImageView.image = icon
            
            // get descr
            let description = weather["description"].string
            print(description)
            self.descriptionLabel.text = "\(description!)"

            
            //get speed wind 
            let speedWind = weatherJson["list"][0]["wind"]["speed"].double
            print(speedWind)
            self.speedWindLabel.text = "\(speedWind!)"
            
            // get humidity
            let humidity = weatherJson["list"][0]["main"]["humidity"].int
            print(humidity)
            self.humidityLabel.text = "\(humidity!)"
            
            for index in 1...4 {
            
                if let tempResult = weatherJson["list"][index]["main"]["temp"].double{
                    
                    //get converted temperature
                    let temperature = openWeather.converteTemperature(country: country!, temperature: tempResult)
                    
                    if index == 1 {
                        temp1Text = "\(temperature)°"
                    }else if index == 2 {
                        temp2Text = "\(temperature)°"
                    }else if index == 3 {
                        temp3Text = "\(temperature)°"
                    }else if index == 4 {
                        temp4Text = "\(temperature)°"
                    }

                    // get forecast time
                    let forecastTime = weatherJson["list"][index]["dt"].int
                    let timeToStr = openWeather.timeFromUnix(unixTime: forecastTime!)
                    if index == 1 {
                        time1Text = timeToStr
                    }else if index == 2 {
                        time2Text = timeToStr
                    }else if index == 3 {
                        time3Text = timeToStr
                    }else if index == 4 {
                        time4Text = timeToStr
                    }
                    // get icon
                    let weather = weatherJson["list"][index]["weather"][0]
                    let iconSrt = weather["icon"].string
                    let nightTime = openWeather.isTimeNight(icon: iconSrt!)
                    openWeather.updateWeatherIcon(condition: condition!, nightTime: nightTime, index: index, weatherIcon: self.updateIconList)
//                    self.iconImageView.image = icon
                
                }
            }
            
        } else {
            print("Enable load weather info")
        }
    }
    
    func updateIconList(index: Int, name: String) {
        if index == 0 {
            self.iconImageView.image = UIImage(named: name)
        }
        if index == 1 {
            self.icon1 = UIImage(named: name)
        }
        if index == 2 {
            self.icon2 = UIImage(named: name)
        }
        if index == 3 {
            self.icon3 = UIImage(named: name)
        }
        if index == 4 {
            self.icon4 = UIImage(named: name)
        }
        
    
    }
    
    func failure(){
        
        hud.hide(animated: true)

        // no conection
        let networkController = UIAlertController(title: "Error", message: "No connection to internet", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        networkController.addAction(okButton)
        
        self.present(networkController, animated: true, completion: nil)

    
    }
    
    // CLLocationManagerDelegate delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location)
        
        self.activityIndicator()
        var currentLocation = locations.last! as CLLocation
        
        if currentLocation.horizontalAccuracy > 0 {
            // stop updating location to save battery power
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.openWeather.weatherFor(geo: coords)
            print(coords)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Cannot get your location")
    }
    
    // prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
        
            let forecastController = segue.destination as! ForecastViewController
            forecastController.time1 = self.time1Text
            forecastController.time2 = self.time2Text
            forecastController.time3 = self.time3Text
            forecastController.time4 = self.time4Text
            
            forecastController.icon1Image = self.icon1
            forecastController.icon2Image = self.icon2
            forecastController.icon3Image = self.icon3
            forecastController.icon4Image = self.icon4

            forecastController.temp1 = self.temp1Text
            forecastController.temp2 = self.temp2Text
            forecastController.temp3 = self.temp3Text
            forecastController.temp4 = self.temp4Text

        }
    }
    

}

