//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import GooglePlaces
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var celBoolean : Bool = true
    var disBoolean : Bool = true
    var apiKey : String = ""
    var dbName : String? = "WeatherDB.db"
    var dbPath : String?
    var city : City!
    var faviouriteCities : [City] = []
    var music = MusicUtility.init()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        apiKey = "AIzaSyACDlOhJkX6sZ5D4rml43fgdHSdRw0z68I"
        GMSPlacesClient.provideAPIKey(apiKey)
        // Override point for customization after application launch.
        celBoolean = true
        disBoolean = true
        
        // Open Connection with database to retrive all Faviourite city info
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDir = documentPaths[0]
        dbPath = documentDir.appending("/" + dbName!)
        checkAndCreateDB()
        readDataFromDB()
        music.playBackgroundMusic()
        return true
    }

    func checkAndCreateDB() {
        var success = false
        let fileManger = FileManager.default
        success = fileManger.fileExists(atPath: dbPath!)
        if success {
            return
        }
        
        let dbPathFromApp = Bundle.main.resourcePath?.appending("/" + dbName!)
        try? fileManger.copyItem(atPath: dbPathFromApp!, toPath: dbPath!)
        
    }
    
    // will populate the favioriteCityArray
    func readDataFromDB()-> Array<City> {
        faviouriteCities.removeAll()
        
        var db : OpaquePointer? = nil
        // Open db connection
        if sqlite3_open(self.dbPath, &db) == SQLITE_OK {
            print("Connection esablished with DB")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementStr : String = "SELECT * FROM Favourites"
            
            if sqlite3_prepare_v2(db, queryStatementStr, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                   
                    let cPlaceId = sqlite3_column_text(queryStatement, 1)
                    let cName = sqlite3_column_text(queryStatement, 2)
                    
                    let lat : Double = Double(sqlite3_column_double(queryStatement, 3))
                    let lng : Double = Double(sqlite3_column_double(queryStatement, 4))
                    
                    let placeId = String(cString: cPlaceId!)
                    let name = String(cString: cName!)
                    
                    let city : City = City.init()
                    city.initWithData(id: id, placeId: placeId, name: name, lat: lat, lng: lng)
                    faviouriteCities.append(city)
                    print("Query Result")
                    print("\(id) | \(placeId) | \(name) | \(lat) | \(lng) ")
                }
                
            } else {
                print("Failed to QUERY DB")

            }
            sqlite3_finalize(queryStatement)
            sqlite3_close(db)
            
        } else {
            print("Failed to OPEN DB")
        }
        return faviouriteCities
    }
    
    // DB insert
    func addFavouriteToDB(city: City ) -> Bool {
        var isSuccess = true
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.dbPath, &db) == SQLITE_OK {
            var insertStatement : OpaquePointer? = nil
            var insertStatementStr : String = "INSERT INTO Favourites VALUES(NULL, ?, ?, ? , ?)"
            
            if sqlite3_prepare_v2(db, insertStatementStr, -1, &insertStatement, nil) == SQLITE_OK {
                let placeId = city.placeId! as NSString
                let name = city.name! as NSString
                
                sqlite3_bind_text(insertStatement, 1, placeId.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 3, city.lat!)
                sqlite3_bind_double(insertStatement, 4, city.lng!)
                
                if sqlite3_step(insertStatement) != SQLITE_DONE {
                    isSuccess = false
                    print("Failed adding row sattement")
                }
                
                sqlite3_finalize(insertStatement)

            } else {
                print("Failed to insert data")
                isSuccess = false
            }
            sqlite3_close(insertStatement)
            
        } else {
            print("Failed to OPEN DB - WHILE INSERTING")
            isSuccess = false
        }
        
        return isSuccess
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

