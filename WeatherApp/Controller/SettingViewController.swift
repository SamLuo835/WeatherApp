//
//  SettingViewController.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-11-05.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    // Labels for toggling weather measurements
    @IBOutlet var celLbl: UILabel!
    @IBOutlet var feLbl: UILabel!
    @IBOutlet var kmLbl : UILabel!
    @IBOutlet var miLbl : UILabel!
    
    // Volume Slider to change background music volume
    @IBOutlet var volSlider : UISlider!
    var mainDelegate : AppDelegate!
    
    // Triggered when silder's value has changed, then
    // change the background music volume
    @IBAction func volumeDidChange(sender: UISlider)
    {
        mainDelegate.music.changeVolume(vol: volSlider.value)
    }
    
    @IBAction func unwindToSetting(sender: UIStoryboardSegue!) {}
    let delegete = UIApplication.shared.delegate as! AppDelegate
    
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
    
    
    @IBAction func removeTable(sender:UIButton){
       delegete.deleteAll()
        showAlert(title: "Delete successful", message: "All favourite cities have been deleted.")
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
    
    func showAlert(title:String = "Error", message:String)
    {
        DispatchQueue.main.async {
            // create alert controller
            let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
            // add default button
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
            // show it
            self.present(alert, animated:true, completion:nil)
        }
    }
}
