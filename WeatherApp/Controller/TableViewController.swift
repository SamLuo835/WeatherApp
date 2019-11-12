//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-11-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import Charts

// TODO:  Rename to faviourite view controller
class TableViewController: UIViewController {
   
    

    let mainDelegete = UIApplication.shared.delegate as! AppDelegate
    
    var faviouriteCities : [City] = []
    
    @IBOutlet var tableView:UITableView!

    @IBAction func unwindToFavioriteViewController(sender: UIStoryboardSegue!) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faviouriteCities.removeAll();
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

