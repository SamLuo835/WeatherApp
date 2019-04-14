import UIKit
import GooglePlaces
import Charts
class WeatherViewController: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var lineChart : LineChartView!
    @IBOutlet var lat : UILabel!
    @IBOutlet var long : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    // Curr Weather
    @IBOutlet var city: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var main: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var clouds: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var windSp: UILabel!
    @IBOutlet var windDeg: UILabel!
    @IBOutlet var visibility: UILabel!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    
    var locationManager = CLLocationManager()
    var searchController: UISearchController!
    let chart = ChartUtility.init()
    let service = WebServiceUtility.init()
    let currWeatherService = CurrWeatherServiceUtility.init()
    
    var place: GMSPlace!
    
    // Faviourite a location
    @IBAction func faviourite() {
        print("Add to faviorite")
        if place != nil {
            let city : City = City.init()
            // this data should be populated once the api call finishes
            city.initWithData(id: 0, placeId: place.placeID!, name: place.name!, lat: place.coordinate.latitude, lng: place.coordinate.longitude)
            
            let mainDelegete = UIApplication.shared.delegate as! AppDelegate
            
            let isSuccess = mainDelegete.addFavouriteToDB(city: city)
            
            if !isSuccess {
                print("Failed to add row to db")
            }
            print("SUCCESS: \(isSuccess)")
            mainDelegete.readDataFromDB()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}

// Handle the user's selection.
extension WeatherViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        self.place = place
        self.lineChart.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
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
    
    func refreshCurrWeatherFields(long : Double,lat: Double) {
        self.currWeatherService.currentWeatherRequest(long: long,lat: lat) {
    packagedWeather in
    
    //let cloud = currentWeather["clouds"] as! NSDictionary
    
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
//    self.visibility.text = packagedWeather["visibility"] as! String
    
    
    let fileName = packagedWeather["icon"] as! String
    
    let url = URL(string: "https://openweathermap.org/img/w/" + fileName + ".png")
    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    self.icon.image = UIImage(data: data!)
    
    print(packagedWeather)
    }
    
    }
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
