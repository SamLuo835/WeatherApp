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
        let collectionViewWidth: CGFloat = collectionView?.frame.width ?? 0
        let itemWidth = (collectionViewWidth - 2.0 ) / 3.0
        let layout = collectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
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
        
//        let image = #imageLiteral(resourceName: "loadScreen")
//        let image = UIImage(named: "button1")!
        
//        cell.imageView.image = image
        
        return cell
    }
    
    private func updateCollectionView() {
        print("in updateCollectionView")
        placesClient = GMSPlacesClient.shared()

        if cities.count > 0 {
            let mainDelgete = UIApplication.shared.delegate as! AppDelegate
            let city = cities[0]
            let cityName = city.value(forKey: "name") as? String ?? ""
            let cityPlaceID = city.value(forKey: "placeId") as? String ?? ""

            print(cityName)
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
