//
//  ItemCollectionViewCell.swift
//  WeatherApp
//
//  Created by Vikki Wong on 2019-12-08.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName: String! {
        didSet {
            imageView.image = UIImage(named:imageName)
        }
    }
}
