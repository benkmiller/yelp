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


class ViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate{
    
    var restaurants = [Restaurant](repeating: Restaurant(), count:10)
    var data = YelpData() //Instantiate Data Model
    var numCalls = 1
    
    //let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadRestaurantIds()
        
        for index in 0...9 {
            print("******viewload restaurant data \(index)")
            print(" \(restaurants[index].name)")
        }
        /*
        // 2
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 3
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        */
    }
    
    
        
    
    
    //TODO
    func sortPageByRating(action: UIAlertAction) {
        //var modifiedRestaurants:[Restaurant](repeating: Restaurant(), count:10)
    }
    
    //TODO
    func sortPageByDistance(action: UIAlertAction) {
        //let url = URL(string: "https://" + action.title!)!
        //webView.load(URLRequest(url: url))
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
                self.loadRestaurantDetails()

            }
            //self.loadRestaurantDetails()
        }
    }
    
    
    func loadRestaurantDetails() {
        for index in 0...9 {
            Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                
                if((responseData.result.value) != nil) {
                    
                    //debugPrint(responseData)
                    let jsonVar = JSON(responseData.result.value!)
                    
                    self.data.restaurantDetails[index] = jsonVar
                    self.restaurants[index].updateInfo(json: jsonVar)
                    
                    print("*********loading details \(index)")
                    print("Address:  "+self.restaurants[index].address)
                    print("Stars:    "+String(self.restaurants[index].rating))
                    
                    
                    /*Distance
                    var distance: [Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                    distance[index] = self.locationManager.location?.distance(from: CLLocation(latitude: (self.restaurants[index].lat)?, longitude: (self.restaurants[index].long)? ))?
                    self.data.restaurantDistances = distance
                    */
            
                    if index == 9 {
                        self.loadPics()
                    }
                }
            }
        }
    }
    /*
    func loadRestaurantDetailsMap() {
        restaurants.map({
            (restaurant: Restaurant) ->	Restaurant in
            return (
            
            
            Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                
                if((responseData.result.value) != nil) {
                    
                    //debugPrint(responseData)
                    let jsonVar = JSON(responseData.result.value!)
                    
                    self.data.restaurantDetails[index] = jsonVar
                    self.restaurants[index].updateInfo(json: jsonVar)
                    
                    print("*********loading details \(index)")
                    print("Address:  "+self.restaurants[index].address)
                    print("Stars:    "+String(self.restaurants[index].rating))
                    
                    
                    /*Distance
                     var distance: [Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                     distance[index] = self.locationManager.location?.distance(from: CLLocation(latitude: (self.restaurants[index].lat)?, longitude: (self.restaurants[index].long)? ))?
                     self.data.restaurantDistances = distance
                     */
                    
                    if index == 9 {
                        self.loadPics()
                    }
                }
            }
        
    }
    */
   
     
    func loadRestaurantDetail(index: Int, cell: CellClass){
            Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                
                if((responseData.result.value) != nil) {
                    
                    //debugPrint(responseData)
                    let jsonVar = JSON(responseData.result.value!)
                    
                    self.data.restaurantDetails[index] = jsonVar
                    self.restaurants[index].updateInfo(json: jsonVar)
                    self.numCalls = self.numCalls + 1
                    cell.name2.text = String(repeating: "★", count: Int(self.restaurants[index].rating))
                    
                    print("*********loading details \(index)")
                    print("Address:  "+self.restaurants[index].address)
                    print("Stars:    "+String(self.restaurants[index].rating))
                    
                    
                    
                    //self.tableView.reloadData()
                    //self.loadPic(index: index, cell: cell)
                 }
            }
        
    }
 
 
    func loadPic(index: Int, cell:CellClass) {
            Alamofire.request(self.restaurants[index].pictures[0]).responseImage { [unowned self] response in
                //print("*********start load pics")
                //debugPrint(response)
                
                let image = response.result.value
                self.restaurants[index].image1 = image
                print("Image: \(image)")
                print("Printing Restaurants")
                for index in 0...9 {
                    print(self.restaurants[index].name)
                }
                cell.IView.image = response.result.value
                //cell.IView.image =self.restaurants[index].image1
                
                
                //self.tableView.reloadData()
                    //self.loadRestaurantReviews()
                
            }
    }
    
    func loadRestaurantReview(index:Int, cell:CellClass) {
        
            Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let jsonVal = JSON(responseData.result.value!)
                    self.restaurants[index].updateReviews(json: jsonVal)
                }
            }
        
    }
    
    func loadRestaurantDetailChained(index: Int, cell: CellClass){
        Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { [unowned self](responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                
                //debugPrint(responseData)
                let jsonVar = JSON(responseData.result.value!)
                
                self.data.restaurantDetails[index] = jsonVar
                self.restaurants[index].updateInfo(json: jsonVar)
                //self.numCalls = self.numCalls + 1
                //cell.name2.text = String(repeating: "★", count: Int(self.restaurants[index].rating))
                
                print("*********loading details \(index)")
                print("Address:  "+self.restaurants[index].address)
                print("Stars:    "+String(self.restaurants[index].rating))
                
                
                    Alamofire.request(self.restaurants[index].pictures[0]).responseImage { [unowned self] response in
                        //print("*********start load pics")
                        //debugPrint(response)
                        
                        let image = response.result.value
                        self.restaurants[index].image1 = image
                        print("Image: \(image)")
                        print("Printing Restaurants")
                        for index in 0...9 {
                            print(self.restaurants[index].name)
                        }
                        cell.name2.text = String(repeating: "★", count: Int(self.restaurants[index].rating))
                        cell.IView.image = response.result.value
                        //cell.IView.image =self.restaurants[index].image1
                        
                        
                        //self.tableView.reloadData()
                        //self.loadRestaurantReviews()
                        
                    }
                
                
                
                //self.tableView.reloadData()
                //self.loadPic(index: index, cell: cell)
            }
        }
        
    }

    
    
    
    /*
    func loadRestaurantDetails() {
        for index in 0...9 {
            
        
        
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        
        Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header)
            .response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(),
                completionHandler: { response in
                    // You are now running on the concurrent `queue` you created earlier.
                    print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                    
                    let jsonVar = JSON(response.result.value!)
                    
                    self.data.restaurantDetails[index] = jsonVar
                    self.restaurants[index].updateInfo(json: jsonVar)
                    
                    print("*********loading details \(index)")
                    print("Address:  "+self.restaurants[index].address)
                    print("Stars:    "+String(self.restaurants[index].rating))
                    // Validate your JSON response and convert into model objects if necessary
                    print(response.result.value)
                    
                    // To update anything on the main thread, just jump back on like so.
                    if index == 9 {
                        DispatchQueue.main.async {
                            print("Am I back on the main thread: \(Thread.isMainThread)")
                        }
                        self.loadPics()
                    }
            }
        )
        }
    }
    */
    
    func loadPics() {
        for index in 0...9 {
           
            Alamofire.request(self.restaurants[index].pictures[0]).responseImage { [unowned self] response in
                //print("*********start load pics")
                //debugPrint(response)
                
                let image = response.result.value
                //if index2 == 0{
                    self.restaurants[index].image1 = image
                //}
                /*
                if index2 == 1{
                    self.restaurants[index].image2 = image
                }
                if index2 == 2{
                    self.restaurants[index].image3 = image
                }
                */
                
                if index == 9 {
                    self.tableView.reloadData()
                    self.loadRestaurantReviews()
                }
            }
        }
    }
    
    func loadRestaurantReviews() {
        for index in 0...9 {
            Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { [unowned self](responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let jsonVal = JSON(responseData.result.value!)
                    self.restaurants[index].updateReviews(json: jsonVal)
                    if index == 9 {
                        
                    }
                }
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
        }
    }

    func rewriteString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    }
    /*
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //map.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    */
    
    
    ////TABLE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return numCalls
        return data.restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellClass = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! CellClass

        cell.name1.text = data.restaurantNames[indexPath.row]
        
        //cell.IView.image = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
        //cell.IView.downloadImageFrom(link: restaurants[indexPath.row].pictures[0], contentMode: UIViewContentMode.scaleAspectFit)
        loadRestaurantDetail(index: indexPath.row, cell: cell)
        
        //loadPic(index: indexPath.row, cell: cell)
        
        //
        //cell.name2.text = String(repeating: "★", count: Int(restaurants[indexPath.row].rating))
        cell.distanceLabel.text = String(data.restaurantDistances[indexPath.row])
        //cell.IView.image = restaurants[indexPath.row].image1

            //UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
        //restaurants[indexPath.row].image1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = data.restaurantNames[indexPath.row]
            print("IMAGE::::   \(restaurants[indexPath.row].image1?.images)")
            vc.restDetail = restaurants[indexPath.row]
            //vc.pictures[indexPath.row] = data.restaurantDetails["photos"].stringValue
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func getToken() {
        
        // prepare json data
        let json: [String: Any] = ["title": "ABC"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://api.yelp.com/oauth2/token?grant_type=client_credentials&client_id=zF67jx6Sj9YgQNqZz_ACEQ&client_secret=qxvN5rD05kV2zwpERS27ivIjPLcL5D94vNhxr5mzmj1ne8K0D79BsZKxP3sHb7cd")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        
    }
    
    
     func loadRestaurantIds()  {
     Alamofire.request(data.urlP1+data.term+data.urlP2+data.location, headers: data.header).responseJSON { (responseData) -> Void in
     if((responseData.result.value) != nil) {
     let jsonVar = JSON(responseData.result.value!)
     for index in 0...9 {
     self.data.restaurantIds[index] = jsonVar["businesses"][index]["id"].stringValue
     self.data.restaurantNames[index] = jsonVar["businesses"][index]["name"].stringValue
     self.data.dat = jsonVar;
     }
     //print(self.data.restaurantIds)
     print(self.data.restaurantNames)
     self.loadRestaurantDetails()
     //self.tableView.reloadData()
     }
     }
     }
     
     func loadRestaurantDetails() {
     for index in 0...9 {
     Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { (responseData) -> Void in
     if((responseData.result.value) != nil) {
     print("*********start load details")
     //debugPrint(responseData)
     let jsonVar = JSON(responseData.result.value!)
     //print("*********************jsonprint")
     //print(jsonVar.stringValue)
     self.data.restaurantDetails[index] = jsonVar
     self.restaurants[index].updateInfo(json: jsonVar)
     //if index == 9 {
     //self.loadPics()
     self.tableView.reloadData()
     //self.loadRestaurantReviews()
     //for index2 in 0...9{
     print(self.restaurants[index].name)
     //    print(self.restaurants[index2].address)
     //}
     //}
     }
     }
     }
     //print("******after resquestsprint")
     //for index3 in 0...9{
     //    print(restaurants[index3].name+"asdfasdf")
     //}
     //self.loadPics()
     }
     
     func loadPics() {
     for index in 0...9 {
     Alamofire.request(self.restaurants[index].pictures[0]).responseImage { response in
     //print("*********start load pics")
     //debugPrint(response)
     
     let image = response.result.value
     //if index2 == 0{
     self.restaurants[index].image1 = image
     //}
     /*
     if index2 == 1{
     self.restaurants[index].image2 = image!
     }
     if index2 == 2{
     self.restaurants[index].image3 = image!
     }
     */
     if index == 9 {
     self.tableView.reloadData()
     self.loadRestaurantReviews()
     }
     }
     }
     //self.tableView.reloadData()
     //self.loadRestaurantReviews()
     }
     
     func loadRestaurantReviews() {
     for index in 0...9 {
     Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { (responseData) -> Void in
     if((responseData.result.value) != nil) {
     let jsonVal = JSON(responseData.result.value!)
     self.restaurants[index].updateReviews(json: jsonVal)
     if index == 9 {
     
     }
     }
     }
     }
     }
     */
    

    

}
extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}


