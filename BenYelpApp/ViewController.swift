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


class ViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    var data = YelpData() //Instantiate Data Model
    var userLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var reloadTableForSort = false

    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        locationManager.delegate = self
        self.searchField.delegate = self
    }
    /*
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        //textField code
        //textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    func performAction() {
        if searchField.hasText == true {
            data.term = rewriteString(string: searchField.text!)
            let url = data.urlP1+data.term+data.urlP2+data.location
            loadRestaurantIds(url: url)
            tableView.reloadData()
            
        }
        //action events
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        //self.hideKeyboardWhenTappedAround()
        locationAuthStatus()
        
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //map.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            
        }
        else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func loadRestaurantIds(url: String)  {
        //let url1 = data.urlP1+data.term+data.urlP2+data.location

        Alamofire.request(url, headers: data.header).responseJSON { [unowned self] (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVar = JSON(responseData.result.value!)
                for index in 0...9 {
                    self.data.restaurantIds[index] = jsonVar["businesses"][index]["id"].stringValue
                    self.data.restaurantNames[index] = jsonVar["businesses"][index]["name"].stringValue
                    self.data.dat = jsonVar;
                }
                print("Load Rest Ids:\(self.data.restaurantNames)")
                self.tableView.reloadData()
            }
        }
    }
    
    func loadRestaurantDetail(index: Int, cell: CellClass){
        Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                
            if((responseData.result.value) != nil) {
                //debugPrint(responseData)
                
                let jsonVar = JSON(responseData.result.value!)
                let lat = jsonVar["coordinates"]["latitude"].doubleValue
                let long = jsonVar["coordinates"]["longitude"].doubleValue

                self.data.restaurantDetails[index] = jsonVar
                //guard lat != 0 && long != 0  else {return}
                
                if let distance = self.locationManager.location?.distance(from: CLLocation(latitude: lat, longitude: long)){
                    let newRestaurant = Restaurant(json: jsonVar, calculatedDistance: distance)
                    self.data.restaurants[index] = newRestaurant
                    cell.distanceLabel.text = String(describing: Int(distance/1000))+"km away"
                    cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                }
                else{
                    let newRestaurant = Restaurant(json: jsonVar, calculatedDistance: 0.0)
                    self.data.restaurants[index] = newRestaurant
                    
                    cell.distanceLabel.text = "nodata"
                    cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                }
                
                print("*********loading details \(index)")
                print("Address:  "+self.data.restaurants[index].address)
                print("Stars:    "+String(self.data.restaurants[index].rating))
                print(" imageUrl:  \(self.data.restaurants[index].pictures[0])")
                print(" latitude of user: \(self.locationManager.location?.coordinate.latitude)")
                print(" longitude of user: \(self.locationManager.location?.coordinate.longitude)")

                self.loadPic(index: index, cell: cell)
            }
            else {
                print("ERROR: RESPONSE VAL NIL")
            }
        }
    }
    
    func loadPic(index: Int, cell: CellClass){
        Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { [unowned self] response in
            //print("*********start load pics")
            //debugPrint(response)
            if let image = response.result.value{
                let imageToSave = ImageStruct(image:image)
                self.data.images[index] = imageToSave

                cell.IView.contentMode = UIViewContentMode.scaleAspectFit
                cell.IView.image = image
                
                self.loadRestaurantReview(index: index, cell: cell)
            }
            else{
                print("ERROR LOADING PIC")
            }
        }
        
    }
 
    func loadRestaurantReview(index:Int, cell:CellClass) {
        Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { [unowned self](responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVal = JSON(responseData.result.value!)
                let newReview = Reviews(json: jsonVal)
                self.data.reviews[index] = newReview
            }
            else {
                print("ERROR: RESPONSE VAL NIL")
            }
        }
    }
    
    @IBAction func goTriggered(_ sender: Any) {
        if searchField.hasText == true {
            data.term = rewriteString(string: searchField.text!)
            let url = data.urlP1+data.term+data.urlP2+data.location
            loadRestaurantIds(url: url)
            tableView.reloadData()
        }
    }
    
    @IBAction func nearMePressed(_ sender: Any) {
        let lat = self.locationManager.location?.coordinate.latitude
        let long = self.locationManager.location?.coordinate.longitude
        let url = data.urlP1+data.term+data.urlP1A+String(describing: lat!)+data.urlP2A+String(describing: long!)
        print(url)
        loadRestaurantIds(url: url)
        tableView.reloadData()
    }
    
    @IBAction func sortButton(_ sender: Any) {
        reloadTableForSort = true
        let ac = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rating", style: .default, handler: sortPageByRating))
        ac.addAction(UIAlertAction(title: "Distance", style: .default, handler: sortPageByDistance))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    /*
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        if searchField.hasText == true {
            data.term = rewriteString(string: searchField.text!)
            let url = data.urlP1+data.term+data.urlP2+data.location
            loadRestaurantIds(url: url)
            tableView.reloadData()
            
        }
    }
    */
    func sortPageByRating(action: UIAlertAction) {
        data.restaurants.sort() { $0.rating > $1.rating }
        for index in 0...9 {
            print(data.restaurants[index].rating)
        }
        tableView.reloadData()
    }
    
    func sortPageByDistance(action: UIAlertAction) {
        for index in 0...9{
            guard data.restaurants[index].distanceToUser != nil else {return}
        }
        data.restaurants.sort() { $0.distanceToUser! < $1.distanceToUser! }
        tableView.reloadData()
    }

    func rewriteString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    }
    
    ////DELEGATE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellClass = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! CellClass
        if reloadTableForSort == false{
            cell.name1.text = data.restaurantNames[indexPath.row]
            loadRestaurantDetail(index: indexPath.row, cell: cell)
            return cell
        }
        else {
            cell.name1.text = data.restaurants[indexPath.row].name
            cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[indexPath.row].rating))
            cell.IView.contentMode = UIViewContentMode.scaleAspectFit
            cell.IView.image = data.images[indexPath.row].image1
            if data.restaurants[indexPath.row].distanceToUser != nil {
                cell.distanceLabel.text = String(describing: Int(data.restaurants[indexPath.row].distanceToUser!/1000))+"km away"
            }
            else {
                cell.distanceLabel.text = "nodata"
            }
            //REMEMBER TO CONFIGURE DISTANCE
            //reloadTableForSort = false;
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = data.restaurantNames[indexPath.row]
            vc.restDetail = data.restaurants[indexPath.row]
            vc.reviews = data.reviews[indexPath.row]
            vc.image1 = data.images[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

