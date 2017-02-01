//
//  ViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-20.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit
import CoreLocation


class ViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate{
    
    var data = YelpData() //Instantiate Data Model
    var userLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadRestaurantIds()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        //if CLLocationManager.locationServicesEnabled() {
        //    locationManager.delegate = self
        //    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //    locationManager.startUpdatingLocation()
        //
        //}
        
        // 3
        //if CLLocationManager.locationServicesEnabled() {
        //    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //    locationManager.requestLocation()
        //}
        
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //map.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            //locationManager.startUpdatingLocation()
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //userLocation = locValue
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func loadRestaurantIds()  {
        Alamofire.request(data.urlP1+data.term+data.urlP2+data.location, headers: data.header).responseJSON { [unowned self] (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVar = JSON(responseData.result.value!)
                for index in 0...9 {
                    self.data.restaurantIds[index] = jsonVar["businesses"][index]["id"].stringValue
                    self.data.restaurantNames[index] = jsonVar["businesses"][index]["name"].stringValue
                    self.data.dat = jsonVar;
                }
                print("Load Rest Ids:\(self.data.restaurantNames)")
                //self.loadRestaurantDetails()
                self.tableView.reloadData()

            }
            //self.loadRestaurantDetails()
        }
    }
    
    func loadRestaurantDetail(index: Int, cell: CellClass){
        Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                
            if((responseData.result.value) != nil) {
                //debugPrint(responseData)
                let jsonVar = JSON(responseData.result.value!)
                    
                self.data.restaurantDetails[index] = jsonVar
                /*
                let distance = self.locationManager.location?.distance(from: CLLocation(latitude: jsonVar["coordinates"]["latitude"].doubleValue, longitude: jsonVar["coordinates"]["longitude"].doubleValue))
                let newRestaurant = Restaurant(json: jsonVar, calculatedDistance: distance!){
                self.data.restaurants[index] = newRestaurant
                */
                let newRestaurant = Restaurant(json: jsonVar)
                self.data.restaurants[index] = newRestaurant
                let distance = self.locationManager.location?.distance(from: CLLocation(latitude: newRestaurant.lat!, longitude: newRestaurant.long!))
                //let dist: CLLocationDistance = self.locationManager.location.distanceFr
                
                cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                cell.distanceLabel.text = String(describing: distance)
                    
                print("*********loading details \(index)")
                print("Address:  "+self.data.restaurants[index].address)
                print("Stars:    "+String(self.data.restaurants[index].rating))
                print(" imageUrl:  \(self.data.restaurants[index].pictures[0])")
                print(" latitude of user: \(self.locationManager.location?.coordinate.latitude)")
                print(" longitude of user: \(self.locationManager.location?.coordinate.longitude)")
                //cell.IView.image = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
                //cell.IView.downloadImageFrom(link: self.restaurants[index].pictures[0], contentMode: UIViewContentMode.scaleAspectFit)

                self.loadPic(index: index, cell: cell)
            }
        }
    }
 /*
    func loadPics(index: Int, cell: CellClass) {
            Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { [unowned self] response in
                //print("*********start load pics")
                
                //debugPrint(response)
                let image = response.result.value
                let imageToSave = ImageStruct(images:image!)
                
                Alamofire.request(self.data.restaurants[index].pictures[1]).responseImage { [unowned self] response2 in
                    //print("*********start load pics")
                    
                    //debugPrint(response)
                    let image2 = response2.result.value
                    let imageToSave = ImageStruct(images:image!)
                                       
                    
                    Alamofire.request(self.data.restaurants[index].pictures[2]).responseImage { [unowned self] response in
                        //print("*********start load pics")
                        
                        //debugPrint(response)
                        let image3 = response.result.value
                        let imageToSave = ImageStruct(images:image!)
                        self.data.images[index] = imageToSave
                        
                        
                        cell.IView.contentMode = UIViewContentMode.scaleAspectFit
                        cell.IView.image = image
                        //cell.IView.image =self.restaurants[index].image1
                        //self.tableView.reloadData()
                        self.loadRestaurantReview(index: index, cell: cell)
                        //print("Printing Restaurants")
                        // for index in 0...9 {
                        //    print(self.data.restaurants[index].name)
                        //}
                        
                    }
                }
                
                
                self.loadRestaurantReview(index: index, cell: cell)
                //print("Printing Restaurants")
                // for index in 0...9 {
                //    print(self.data.restaurants[index].name)
                //}
                
            }
    }
 */
    
    func loadPic(index: Int, cell: CellClass){
        Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { [unowned self] response in
            //print("*********start load pics")
            
            //debugPrint(response)
            let image = response.result.value
            let imageToSave = ImageStruct(image:image!)
            self.data.images[index] = imageToSave
            
            
            cell.IView.contentMode = UIViewContentMode.scaleAspectFit
            cell.IView.image = image
            //cell.IView.image =self.restaurants[index].image1
            //self.tableView.reloadData()
            self.loadRestaurantReview(index: index, cell: cell)
            
        }
        
    }
 
    func loadRestaurantReview(index:Int, cell:CellClass) {
        Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { [unowned self](responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVal = JSON(responseData.result.value!)
                let newReview = Reviews(json: jsonVal)
                self.data.reviews[index] = newReview
            }
        }
    }
    
    
    @IBAction func sortButton(_ sender: Any) {
        let ac = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rating", style: .default, handler: sortPageByRating))
        ac.addAction(UIAlertAction(title: "Distance", style: .default, handler: sortPageByDistance))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        if searchField.text != nil || searchField.text != "" {
            data.term = rewriteString(string: searchField.text!)
            loadRestaurantIds()
            //tableView.reloadData()
        }
    }
    
    func sortPageByRating(action: UIAlertAction) {
        filterList()
    }
    
    func filterList() { // should probably be called sort and not filter
        data.restaurants.sort() { $0.rating > $1.rating } // sort the fruit by name
        tableView.reloadData(); // notify the table view the data has changed
    }
    
    
    //TODO
    func sortPageByDistance(action: UIAlertAction) {
        //let url = URL(string: "https://" + action.title!)!
        //webView.load(URLRequest(url: url))
    }

    func rewriteString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    }
    
    
    ////TABLE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellClass = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! CellClass
        cell.name1.text = data.restaurantNames[indexPath.row]
        
        //cell.IView.image = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
        //cell.IView.downloadImageFrom(link: restaurants[indexPath.row].pictures[0], contentMode: UIViewContentMode.scaleAspectFit)
        loadRestaurantDetail(index: indexPath.row, cell: cell)
        //var getLat: CLLocationDegrees = latitude
        //var getLon: CLLocationDegrees = centre.longitude
       
        //cell.distanceLabel.text = String(data.restaurantDistances[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = data.restaurantNames[indexPath.row]
            vc.restDetail = data.restaurants[indexPath.row]
            vc.reviews = data.reviews[indexPath.row]
            vc.images = data.images[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
