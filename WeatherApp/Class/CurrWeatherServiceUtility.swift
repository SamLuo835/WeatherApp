//
//  CurrWeatherServiceUtility.swift
//  WeatherApp
//
//  Created by Vikki Wong on 2019-04-14.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class CurrWeatherServiceUtility: NSObject {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let converter = ConverterUtility.init()
    
    func currentWeatherRequest(long:Double,lat:Double,handler: @escaping (NSDictionary)->()){
        var units = "metric"
        
        if(mainDelegate.celBoolean){
            units = "metric"
        }
        else {units = "imperial"}
        
        let currentWeatherUrl = URL(string:"https://api.openweathermap.org/data/2.5/weather?units=\(units)&lat=\(lat)&lon=\(long)&appid=7d2f8fdc5ef5aba4d3197fc3bddd874e")!
        print(currentWeatherUrl)
        let task = URLSession.shared.dataTask(with: currentWeatherUrl){ (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let urlContent =  data {
                    
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let currentWeather = jsonResult as? NSMutableDictionary else {
                            print("invalid format")
                            return
                        }
                        
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
                        
                        let sunrise = sys!["sunrise"] as! Double 
                        let sunset = sys!["sunset"] as! Double
                        let sunriseDate = NSDate(timeIntervalSince1970: sunrise)
                        let sunsetDate = NSDate(timeIntervalSince1970: sunset)
                        
                        let formatter =  DateFormatter()
                        formatter.dateFormat = "HH:mm:ss"
                        let formattedSunrise = formatter.string(from: sunriseDate as Date)
                        let formattedSunset = formatter.string(from: sunsetDate as Date)
                        
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
