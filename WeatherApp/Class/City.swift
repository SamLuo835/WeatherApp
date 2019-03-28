//
//  City.swift
//  WeatherApp
//
//  Created by omar Elbanby on 2019-03-27.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class City: NSObject {
    // Add the follwoing feilds CREATE TABLE Favourites(Id INTEGER PRIMARY KEY, PlaceId TEXT, Name TEXT,  Lat REAL, Lng REAL)
    var id      : Int?
    var placeId : String?
    var name    : String?
    var lat     : Double?
    var lng     : Double?
    
    func initWithData(id : Int, placeId : String, name : String, lat : Double, lng : Double) {
        self.id = id
        self.placeId = placeId
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}
