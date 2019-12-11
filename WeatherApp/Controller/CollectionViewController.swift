//
//  CollectionViewController.swift
//  WeatherApp
//
//  Created by Vikki Wong on 2019-12-08.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreData

class CollectionViewController: UICollectionViewController {

   var cities: [NSManagedObject] = []
   var cityName: String = ""
   var cityPlaceID: String = ""
   var pictures: [UIImage] = []
   var placesClient: GMSPlacesClient!
   
   var collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        setupCollectionViewItemsSize()
        updateCollectionView()
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.imageView.image = self.pictures[indexPath.item]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "seguePhoto"
           {
               if let vc = segue.destination as? PhotoViewController
               {
                   // get tapped cell first
                   if let cell = sender as? ItemCollectionViewCell
                   {
                       // pass image to destination
                       vc.image = cell.imageView.image
                   }
               }
           }
       }
    
    private func updateCollectionView() {
        print("in updateCollectionView")
        placesClient = GMSPlacesClient.shared()

        if cities.count > 0 {
            let city = cities[0]
            let cityPlaceID = city.value(forKey: "placeId") as? String ?? ""

            // Specify the place data types to return (in this case, just photos).
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!

            // change this to be place id which we have!
            placesClient?.fetchPlace(fromPlaceID: cityPlaceID , placeFields: fields, sessionToken: nil, callback: {
                (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    // Get the metadata for the first photo in the place photo metadata list.
                    self.pictures = []
                    for  i in 0...9 {
                        let photoMetadata: GMSPlacePhotoMetadata = place.photos![i]

                        // Call loadPlacePhoto to display the bitmap and attribution.
                        self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                            if let error = error {
                                // TODO: Handle the error.
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                            } else {
                                self.pictures.append((photo)!)
                                self.collectionView.reloadData()
                            }
                        })
                    }
                }
            })

        }


    }

}
