//
//  WebServiceUtility.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class WebServiceUtility: NSObject {
    
    
    
    func request(long:Double,lat:Double,handler: @escaping (NSDictionary)->()){
        let url = URL(string:"https://api.openweathermap.org/data/2.5/forecast?units=metric&lat=\(lat)&lon=\(long)&appid=7d2f8fdc5ef5aba4d3197fc3bddd874e")!
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let urlContent =  data {
                    
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        // I would not recommend to use NSDictionary, try using Swift types instead
                        guard let newValue = jsonResult as? NSDictionary else {
                            print("invalid format")
                            return
                        }
                        
                        handler(newValue)
                        
                    }catch {
                        print("JSON Preocessing failed")
                    }
                }
            }
        }
        task.resume()
    }
}
