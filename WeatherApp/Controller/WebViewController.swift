//
//  WebViewController.swift
//  WeatherApp
//
//    Displays WebView to the OpenWeather API Website
//
//  Created by Vikki Wong on 2019-11-05.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // Initiating WebView and ActivityIndicator for the View Controller
    @IBOutlet var webView : WKWebView!
    @IBOutlet var activity : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigate to OpenWeatherAPI Website
        let urlAddress = URL(string : "https://openweathermap.org/")
        let url = URLRequest(url:urlAddress!)
        webView.load(url)
        webView.navigationDelegate = self
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
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
