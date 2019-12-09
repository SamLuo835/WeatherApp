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
class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cityPictureSegue = "showCollectionSegue"
           
    //properties updated
    var managedObjectContext: NSManagedObjectContext!
    var moCities: [NSManagedObject] = []  // whole managed objects
   // var faviouriteCities : [City] = []
    @IBOutlet var tableView:UITableView!
    
    @IBAction func unwindToFavioriteViewController(sender: UIStoryboardSegue!) {}
    
    override func viewDidLoad(){
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
        self.tableView.reloadData()
    }
    
    required init?(coder  aCoder: NSCoder){
        // initialize managed object context in this class
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        // call superclass init() right after init all properties of this class
        super.init(coder:aCoder)
        
    }
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
        
        // set full name to the cell
        let cityName = moCities.value(forKey: "name") as? String ?? ""
        cell.textLabel?.text = "\(cityName)"
        cell.layer.backgroundColor = UIColor.clear.cgColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.performSegue(withIdentifier: "showCollectionSegue", sender: indexPath);
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == cityPictureSegue {
            if let vc = segue.destination as? CollectionViewController{
                
                let index = self.tableView.indexPathForSelectedRow?.row ?? 0
//                let city = self.moCities[index]
                print("indexPathFor")
                vc.cities = [self.moCities[index]]
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // load data from CoreData to arrays of managed objects
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let cityRequest = NSFetchRequest<NSManagedObject>(entityName: "CityModel")
        

        // to sort city by name with natural ascending
        let cityDescriptor = NSSortDescriptor(key: "name",
                                                 ascending: true,
                                                 selector: #selector(NSString.localizedStandardCompare))
        cityRequest.sortDescriptors = [cityDescriptor]


        // fetch data within do-catch block
        do
        {
            self.moCities = try managedObjectContext.fetch(cityRequest)
            print(String(self.moCities.count) + " length of objects")
            print(self.moCities)

        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }

    }
    
}

