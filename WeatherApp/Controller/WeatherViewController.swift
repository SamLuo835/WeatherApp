import UIKit
import GooglePlaces
import Charts
class WeatherViewController: UIViewController {
    @IBOutlet weak var lineChart : LineChartView!
    var searchController: UISearchController!
    @IBOutlet var lat : UILabel!
    @IBOutlet var long : UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    
    func setChartValues(_ count : Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        let data = LineChartData(dataSet: set1)
    
        self.lineChart.data = data
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var resultsViewController: GMSAutocompleteResultsViewController?
        var placesClient : GMSPlacesClient = GMSPlacesClient.shared()

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
        //print(place.photos)
        lat.text = String(place.coordinate.latitude);
        long.text = String(place.coordinate.longitude);
        let service = WebServiceUtility.init()
       
        service.request(long:place.coordinate.longitude,lat:place.coordinate.latitude){
            result in
            var timeLbl : [String] = []
            var tempLbl : [Double] = []
            let list = result["list"] as! NSArray
            var outerCount : NSInteger = 0
            var innerCount : NSInteger = 0

            for item in list{
                if outerCount % 2 == 0{
                    if innerCount % 2 == 0{
                        let NSItem = item as! NSDictionary
                        let NSMain = NSItem["main"] as! NSDictionary
                        let dateString = NSItem.object(forKey: "dt_txt") as! String
                        let r = dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.endIndex, offsetBy: -3)
                        timeLbl.append(String(dateString[r]))
                        tempLbl.append(NSMain.object(forKey: "temp") as! Double)
                    }
                    innerCount = innerCount + 1
                }
                outerCount = outerCount + 1
            }
            var chartEntries : [ChartDataEntry] = []
            self.lineChart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
                return timeLbl[Int(index)]
            })
            for i in 0..<timeLbl.count{
                let newEntry = ChartDataEntry( x:Double(i),y:tempLbl[i])
                chartEntries.append(newEntry)
            }
            
            let set: LineChartDataSet = LineChartDataSet(values: chartEntries, label: "°C")
            set.setColor(NSUIColor.blue, alpha: CGFloat(1))
            set.circleColors = [NSUIColor.blue]
            set.circleRadius = 3
            set.mode = LineChartDataSet.Mode.cubicBezier
           
            let data: LineChartData = LineChartData(dataSet: set)
            self.lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
            self.lineChart.xAxis.labelRotationAngle = -70
            self.lineChart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
                return timeLbl[Int(index)]
            })
            
            self.lineChart.data?.notifyDataChanged()
            self.lineChart.notifyDataSetChanged()
            
            self.lineChart.xAxis.setLabelCount(timeLbl.count, force: true)
            self.lineChart.data = data
        }
        
       
        
        
        //let photoMetadata1: GMSPlacePhotoMetadata = place.photos![0]
        //let photoMetadata2: GMSPlacePhotoMetadata = place.photos![1]
       // let photoMetadata3: GMSPlacePhotoMetadata = place.photos![2]
        
        //print("attributes,",photoMetadata)
        // Call loadPlacePhoto to display the bitmap and attribution.
        
       /* self.placesClient.loadPlacePhoto(photoMetadata1, callback: { (photo, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Error loading photo metadata: \(error.localizedDescription)")
                return
            } else {
                self.imageView1?.image = photo;
            }
        })
        self.placesClient.loadPlacePhoto(photoMetadata2, callback: { (photo, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Error loading photo metadata: \(error.localizedDescription)")
                return
            } else {
                self.imageView2?.image = photo;
            }
        })
        self.placesClient.loadPlacePhoto(photoMetadata3, callback: { (photo, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Error loading photo metadata: \(error.localizedDescription)")
                return
            } else {
                self.imageView3?.image = photo;
            }
        })*/
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
