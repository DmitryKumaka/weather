//
//  ViewController.swift
//  wather
//
//  Created by 1 on 28/09/16.
//  Copyright © 2016 dima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&&APPID=87159f509b2ef104a1109320fe4cc92c")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
        
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        let weather = OpenWeatherMap(weatherJson: json as NSDictionary)
                        print(weather.nameCity)
                        print(weather.temp)
                        print(weather.description)
                        print(weather.currentTime!)
                        print(weather.image!)
                        
                       
                        DispatchQueue.main.async {
                            self.iconImageView.image = weather.image!
                        }

                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
        
        
        
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

