//
//  ConverterUtility.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-05.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class ConverterUtility: NSObject {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 1mile = 1.60934km
    func updateUnit(visibility: Double)-> String {
        if (!mainDelegate.disBoolean) {
            let result:String = String(visibility / 1.60934)
            return  result
        } else {
            let result:String = String(visibility)
            return result
        }
    }
    

}
