//
//  CurrWeatherServiceUtility.swift
//  WeatherApp
//
//   Create requests to obtain Current Weather
//   information from OpenWeather API
//
//  Created by Vikki Wong on 2019-04-14.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class CurrWeatherServiceUtility: NSObject {
    
    // Main Delegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Current Weather Request to get data from OpenWeather API
    func currentWeatherRequest(long:Double,lat:Double,handler: @escaping (NSDictionary)->()){
        var units = "metric"
        
        // Change measurement unit according to Setting's boolean
        if(mainDelegate.celBoolean){
            units = "metric"
        }
        else {units = "imperial"}
        
        // Initiate request to get JSON data for Current Weather
        let currentWeatherUrl = URL(string:"https://api.openweathermap.org/data/2.5/weather?units=\(units)&lat=\(lat)&lon=\(long)&appid=7d2f8fdc5ef5aba4d3197fc3bddd874e")!
        print(currentWeatherUrl)
        let task = URLSession.shared.dataTask(with: currentWeatherUrl){ (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let urlContent =  data {
                    
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        // In case if retrieval of JSON is unsuccessful
                        guard let currentWeather = jsonResult as? NSMutableDictionary else {
                            print("invalid format")
                            return
                        }
                        
                        // Append all neccessary data into an NSDictionary for later use
                        let main = currentWeather["main"] as? NSDictionary
                        let weather = currentWeather["weather"] as? NSArray
                        let name = currentWeather["name"] as? String
                        let visibility = currentWeather["visibility"]

                        let temp = main!["temp"]
                        let min = main!["temp_min"]
                        let max = main!["temp_max"]
                        let pressure = main!["pressure"]
                        let humidity = main!["humidity"]
                        
                        let weatherLst = currentWeather["weather"] as? NSArray
                        let weatherObj = weatherLst![0] as? NSDictionary
                        let mainWeather = weatherObj!["main"]
                        let icon = weatherObj!["icon"] 
                        let clouds = currentWeather["clouds"] as? NSDictionary
                        let cloudAll = clouds!["all"] ?? "Unavailable"
                        
                        let wind = currentWeather["wind"] as? NSDictionary
                        let windSp = wind!["speed"] ?? "Unavailable"
                        let windDeg = wind!["deg"] ?? "Unavailable"
                        
                        let sys = currentWeather["sys"] as? NSDictionary
                        let country = sys!["country"] ?? "Unavailable"
                        
                        // Format the sunrise and sunset date
                        let sunrise = sys!["sunrise"] as! Double 
                        let sunset = sys!["sunset"] as! Double
                        let sunriseDate = NSDate(timeIntervalSince1970: sunrise)
                        let sunsetDate = NSDate(timeIntervalSince1970: sunset)
                        let formatter =  DateFormatter()
                        formatter.dateFormat = "HH:mm:ss"
                        let formattedSunrise = formatter.string(from: sunriseDate as Date)
                        let formattedSunset = formatter.string(from: sunsetDate as Date)
                        
                        // Put all data together into an NSDictioanry
                        let packagedWeather: NSDictionary = [
                            "name" : "\(name!), \(country)",
                            "main" : "\(mainWeather!)",
                            "icon" : "\(icon!)",
                            "temp" : "\(temp!)",
                            "min" : "\(min!)",
                            "max" : "\(max!)",
                            "clouds" : "\(cloudAll)",
                            "humidity" : "\(humidity!)",
                            "pressure" : "\(pressure!)",
                            "windSp" : "\(windSp)",
                            "windDeg" : "\(windDeg)",
                            "sunrise" :"\(formattedSunrise)",
                            "sunset" : "\(formattedSunset)"
                        ]
                        
                        // Return the packaged weather data
                        handler(packagedWeather as NSDictionary)
                        
                    } catch {
                        print("JSON Preocessing failed")
                    }
                }
            }
        }
        task.resume()
    }

}
