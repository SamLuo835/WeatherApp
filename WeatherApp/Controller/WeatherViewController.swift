import UIKit
import GooglePlaces
import Charts
class WeatherViewController: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var lineChart : LineChartView!
    @IBOutlet var lat : UILabel!
    @IBOutlet var long : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView! = UIActivityIndicatorView()
    
    var locationManager = CLLocationManager()
    var searchController: UISearchController!
    let chart = ChartUtility.init()
    let service = WebServiceUtility.init()

    
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
            UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.photos.rawValue))!
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
        lat.text = String(place.coordinate.latitude);
        long.text = String(place.coordinate.longitude);
        
        self.service.request(long:place.coordinate.longitude,lat:place.coordinate.latitude){
           time,temp in
           let timeLbl : [String] = time
           let tempLbl : [Double] = temp
           self.chart.drawChart(first: timeLbl, second: tempLbl, chart: self.lineChart)

        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
      
        self.service.request(long:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude){
            time,temp in
            let timeLbl : [String] = time
            let tempLbl : [Double] = temp
            
            
            DispatchQueue.main.sync {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            self.chart.drawChart(first: timeLbl, second: tempLbl, chart: self.lineChart)
            
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