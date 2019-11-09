import UIKit
import GooglePlaces
import Charts
class WeatherViewController: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var lineChart : LineChartView!
    @IBOutlet var lat : UILabel!
    @IBOutlet var long : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    // Current Weather Labels
    @IBOutlet var city: UILabel!
    @IBOutlet var main: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var clouds: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var windSp: UILabel!
    @IBOutlet var windDeg: UILabel!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    // Current Weather Icon Container
    @IBOutlet var iconView: UIView!
    
    // To get location of user
    var locationManager = CLLocationManager()
    
    // For seraching cities
    var searchController: UISearchController!
    
    // Weather Chart
    let chart = ChartUtility.init()
    
    var subView :UIView?
    // Service for getting weather chart data
    let service = WebServiceUtility.init()
    // Service for getting current weather data
    let currWeatherService = CurrWeatherServiceUtility.init()
    var fadeLayer : CALayer?
    
    var place: GMSPlace!
    
    // Faviourite a location
    @IBAction func faviourite() {
        print("Add to faviorite")
        if place != nil {
            let city : City = City.init()
            // this data should be populated once the api call finishes
            city.initWithData(id: 0, placeId: place.placeID!, name: place.name!, lat: place.coordinate.latitude, lng: place.coordinate.longitude)
            
            let mainDelegete = UIApplication.shared.delegate as! AppDelegate
            
            //let isSuccess = mainDelegete.addFavouriteToDB(city: city)
            
            // if !isSuccess {
            //    print("Failed to add row to db")
            //}
            //print("SUCCESS: \(isSuccess)")
            //mainDelegete.readDataFromDB()
        }
    }
  
    //Author: Jianlin Luo, add the search sub view and update current location when viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show activity indicator until WebView is loaded
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        var resultsViewController: GMSAutocompleteResultsViewController?
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.photos.rawValue)|UInt(GMSPlaceField.placeID.rawValue))!
        resultsViewController?.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        resultsViewController?.autocompleteFilter = filter
        
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        subView = UIView(frame: CGRect(x: 0, y: 30, width: 350.0, height: 45.0))
        
        subView?.addSubview((searchController?.searchBar)!)
       
        if let sview:UIView = subView{
            view.addSubview(sview)
        }
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        subView?.removeFromSuperview()
        if UIDevice.current.orientation.isLandscape {
               subView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 45.0))
           } else {
               subView = UIView(frame: CGRect(x: 0, y: 30, width: 350, height: 45.0))
           }
         
         subView?.addSubview((searchController?.searchBar)!)
        
         if let sview:UIView = subView{
             view.addSubview(sview)
         }
         searchController?.searchBar.sizeToFit()
         searchController?.hidesNavigationBarDuringPresentation = false
        
    }

}


// Author: Jianlin Luo, Handle the user's selection.
extension WeatherViewController: GMSAutocompleteResultsViewControllerDelegate {
    // Author: Jianlin Luo, draw the chart and refresh the weather forecast labels using the data from openWeatherAPI
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        self.place = place
        self.lineChart.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        //providing the call back function
        self.service.chartRequest(long:place.coordinate.longitude,lat:place.coordinate.latitude){
           time,temp in
           let timeLbl : [String] = time
           let tempLbl : [Double] = temp
           self.chart.drawChart(first: timeLbl, second: tempLbl, chart: self.lineChart)
            DispatchQueue.main.sync {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
        
        self.refreshCurrWeatherFields(long:place.coordinate.longitude,lat:place.coordinate.latitude);

    }
    // Author: Jianlin Luo, use the current location to call openWeatherApi on first time
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
      
        self.service.chartRequest(long:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude){
            time,temp in
            let timeLbl : [String] = time
            let tempLbl : [Double] = temp
            
            
            DispatchQueue.main.sync {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            self.chart.drawChart(first: timeLbl, second: tempLbl, chart: self.lineChart)
            
        }
        
        self.refreshCurrWeatherFields(long:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude);
    }
    
    // Author: Vikki Wong
    // Refreshes all Current Weather labels. Grabs information from the currWeatherService,
    // then setting label texts
    func refreshCurrWeatherFields(long : Double,lat: Double) {
        self.currWeatherService.currentWeatherRequest(long: long,lat: lat) {
            packagedWeather in

            DispatchQueue.main.sync {
                self.city.text = packagedWeather["name"] as! String
                self.main.text = packagedWeather["main"] as! String
                self.temp.text = packagedWeather["temp"] as! String
                self.minTemp.text = packagedWeather["min"] as! String
                self.maxTemp.text = packagedWeather["max"] as! String
                self.clouds.text = packagedWeather["clouds"] as! String
                self.humidity.text = packagedWeather["humidity"] as! String
                self.pressure.text = packagedWeather["pressure"] as! String
                self.windSp.text = packagedWeather["windSp"] as! String
                self.windDeg.text = packagedWeather["windDeg"] as! String
                self.sunrise.text = packagedWeather["sunrise"] as! String
                self.sunset.text = packagedWeather["sunset"] as! String
                // Set weather icon
                let fileName = packagedWeather["icon"] as! String
                let url = URL(string: "https://openweathermap.org/img/w/" + fileName + ".png")
                let data = try? Data(contentsOf: url!)
                // Create Fade Anitmation
                self.setIconAnimation(imgData: data!)
            
            }
    
        }
    }
    
    
    // Author: Vikki Wong
    // To add animation to CALayer, then add CALayer to Icon UIView container.
    func setIconAnimation(imgData: Data) {
        let fadeImage = UIImage(data: imgData)
        if ((fadeLayer) != nil) {
            fadeLayer?.removeFromSuperlayer()
        }
        fadeLayer = CALayer.init()
        fadeLayer?.contents = fadeImage?.cgImage
        fadeLayer?.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        fadeLayer?.position = CGPoint(x: 25, y: 20)
        self.iconView.layer.addSublayer(fadeLayer!)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fadeAnimation.fromValue = NSNumber.init(value: 1.0)
        fadeAnimation.toValue = NSNumber.init(value: 0.0)
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.duration = 3.0
        fadeAnimation.beginTime = 1.0
        fadeAnimation.isAdditive = false
        
        fadeAnimation.fillMode = CAMediaTimingFillMode.both
        fadeAnimation.repeatCount = Float.infinity
        fadeLayer?.add(fadeAnimation, forKey: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
  
}
