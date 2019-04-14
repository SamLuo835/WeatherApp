//
//  WebServiceUtility.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class WebServiceUtility: NSObject {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    func chartRequest(long:Double,lat:Double,handler: @escaping ([String],[Double])->()){
        var units = "metric"
        
        if(mainDelegate.celBoolean){
            units = "metric"
        }
        else {units = "imperial"}
        
        let url = URL(string:"https://api.openweathermap.org/data/2.5/forecast?units=\(units)&lat=\(lat)&lon=\(long)&appid=7d2f8fdc5ef5aba4d3197fc3bddd874e")!
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let urlContent =  data {
                    
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let newValue = jsonResult as? NSDictionary else {
                            print("invalid format")
                            return
                        }
                        var timeLbl : [String] = []
                        var tempLbl : [Double] = []
                        let list = newValue["list"] as! NSArray
                        var outerCount : NSInteger = 0
                        var innerCount : NSInteger = 0
                        
                        for item in list{
                            if outerCount % 2 == 0{
                                if innerCount % 2 == 0{
                                    let NSItem = item as! NSDictionary
                                    let NSMain = NSItem["main"] as! NSDictionary
                                    let dateString = NSItem.object(forKey: "dt_txt") as! String
                                    let r = dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.endIndex, offsetBy: -3)
                                    timeLbl.append(String(dateString[r]))
                                    tempLbl.append(NSMain.object(forKey: "temp") as! Double)
                                }
                                innerCount = innerCount + 1
                            }
                            outerCount = outerCount + 1
                        }
                        handler(timeLbl,tempLbl)
                        
                    }catch {
                        print("JSON Preocessing failed")
                    }
                }
            }
        }
        task.resume()
    }
    
}
