//
//  CityPicturesViewController.swift
//  WeatherApp
//
//  Created by omar Elbanby on 2019-03-27.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class CityPicturesViewController: UIViewController {
    
    @IBOutlet weak var lblCityName : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainDelgete = UIApplication.shared.delegate as! AppDelegate
        lblCityName.text = mainDelgete.cityName
    }
    
}
