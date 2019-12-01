//
//  CityPicturesViewController.swift
//  WeatherApp
//
//  Created by omar Elbanby on 2019-11-05.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import GooglePlaces

class CityPicturesViewController: UIViewController {
    
    @IBOutlet weak var lblCityName : UILabel!
    @IBOutlet var firstImg : UIImageView!
    @IBOutlet var secImg : UIImageView!
    @IBOutlet var thirdImg : UIImageView!
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  placesClient = GMSPlacesClient.shared()
        
        let mainDelgete = UIApplication.shared.delegate as! AppDelegate
        let city  =
        
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        
        // change this to be place id which we have!
        placesClient?.fetchPlace(fromPlaceID: city.placeId! , placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                // Get the metadata for the first photo in the place photo metadata list.
                for  i in 0...3 {
                    let photoMetadata: GMSPlacePhotoMetadata = place.photos![i]
                    
                    // Call loadPlacePhoto to display the bitmap and attribution.
                    self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                        if let error = error {
                            // TODO: Handle the error.
                            print("Error loading photo metadata: \(error.localizedDescription)")
                            return
                        } else {
                            self.lblCityName.text = city.name!
                            switch i {
                            case 0: self.firstImg.image = photo
                            case 1: self.secImg.image = photo
                            case 2: self.thirdImg.image = photo
                            default: print("no image")
                            }
                        }
                    })
                }
            }
        })
     */
    }
}
