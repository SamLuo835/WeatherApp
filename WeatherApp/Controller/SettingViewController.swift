//
//  SettingViewController.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-05.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet var celLbl: UILabel!
    @IBOutlet var feLbl: UILabel!
    @IBOutlet var kmLbl : UILabel!
    @IBOutlet var miLbl : UILabel!
    var mainDelegate : AppDelegate!
    
    
    @IBAction func tempSwitch(sender:UISwitch){
        if(sender.isOn){
            mainDelegate.celBoolean = true
            feLbl.textColor = .lightGray
            celLbl.textColor = .black
        }
        else{
            mainDelegate.celBoolean = false
            feLbl.textColor = .black
            celLbl.textColor = .lightGray
        }
    }
    
    @IBAction func disSwitch(sender:UISwitch){
        if(sender.isOn){
            mainDelegate.disBoolean = true
            kmLbl.textColor = .black
            miLbl.textColor = .lightGray
        }
        else{
            mainDelegate.disBoolean = false
            kmLbl.textColor = .lightGray
            miLbl.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
