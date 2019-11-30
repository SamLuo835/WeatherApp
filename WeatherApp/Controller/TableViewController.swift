//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-11-03.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import Charts
import CoreData
import os.log       // for system logging

// TODO:  Rename to faviourite view controller
class TableViewController: UIViewController {
       
    let mainDelegete = UIApplication.shared.delegate as! AppDelegate
    
    //properties updated
    var managedObjectContext: NSManagedObjectContext!
    var moCities: [NSManagedObject] = []  // whole managed objects
   // var faviouriteCities : [City] = []
    @IBOutlet var tableView:UITableView!
    @IBAction func unwindToFavioriteViewController(sender: UIStoryboardSegue!) {}
    
    
    ///////////////////////////////////////////////////////////////////////////
    //Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return self.moCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)

        // get managed object at index
        let index = indexPath.row
        let moCities = self.moCities[index]
        
        //other properties if you want to use them
        let cityId = moCities.value(forKey: "id") as? Int32
        let cityLat = moCities.value(forKey: "lat") as? String ?? ""
        let cityLong = moCities.value(forKey: "long") as? String ?? ""
        let cityPlaceId = moCities.value(forKey: "placeId") as? String ?? ""
    
        // set full name to the cell
        let cityName = moCities.value(forKey: "name") as? String ?? ""
        cell.textLabel?.text = "\(cityName)"

        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //faviouriteCities.removeAll();
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // load data from CoreData to arrays of managed objects
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let cityRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        

        // to sort students by first name with natural ascending
        let cityDescriptor = NSSortDescriptor(key: "name",
                                                 ascending: true,
                                                 selector: #selector(NSString.localizedStandardCompare))
        cityRequest.sortDescriptors = [cityDescriptor]


        // fetch data within do-catch block
        do
        {
            self.moCities = try managedObjectContext.fetch(cityRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }

    }
    
}

