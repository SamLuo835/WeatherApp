//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import Charts

// TODO:  Rename to faviourite view controller
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let mainDelegete = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func unwindToFavioriteViewController(sender: UIStoryboardSegue!) {}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegete.faviouriteCities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        let rowNum = indexPath.row
        tableCell.textLabel?.text = mainDelegete.faviouriteCities[rowNum].name
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let mainDelgete = UIApplication.shared.delegate as! AppDelegate
            mainDelgete.cityName = mainDelegete.faviouriteCities[indexPath.row].name!
            performSegue(withIdentifier: "cityPicturesViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegete.readDataFromDB()
    }
}

