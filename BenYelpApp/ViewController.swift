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
    
    //var restaurants = [Restaurant](repeating: Restaurant(), count:10)
    var data = YelpData() //Instantiate Data Model
    
    //let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadRestaurantIds()
        
        for index in 0...9 {
            print("******viewload restaurant data \(index)")
            print(" \(data.restaurants[index].name)")
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
                    self.data.restaurants[index].updateInfo(json: jsonVar)
                    cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                    
                    print("*********loading details \(index)")
                    print("Address:  "+self.data.restaurants[index].address)
                    print("Stars:    "+String(self.data.restaurants[index].rating))
                    print(" imageUrl:  \(self.data.restaurants[index].pictures[0])")
                    //cell.IView.image = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
                    //cell.IView.downloadImageFrom(link: self.restaurants[index].pictures[0], contentMode: UIViewContentMode.scaleAspectFit)

                    self.loadPic(index: index, cell: cell)
                 }
            }
        
    }
 
 
    func loadPic(index: Int, cell: CellClass) {
            Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { [unowned self] response in
                //print("*********start load pics")
                //debugPrint(response)
                
                let image = response.result.value
                self.data.restaurants[index].image1 = image
                // print("Image: \(image)")
                print("Printing Restaurants")
                for index in 0...9 {
                    print(self.data.restaurants[index].name)
                }
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
                    self.data.restaurants[index].updateReviews(json: jsonVal)
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
    
    //TODO
    func sortPageByRating(action: UIAlertAction) {
        //filterList()
    }
    /*
     func filterList() { // should probably be called sort and not filter
     tableView.visibleCells.sort() { $0.rating > $1.rating } // sort the fruit by name
     tableView.reloadData(); // notify the table view the data has changed
     }
     */
    
    //TODO
    func sortPageByDistance(action: UIAlertAction) {
        //let url = URL(string: "https://" + action.title!)!
        //webView.load(URLRequest(url: url))
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
        //return data.restaurants
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellClass = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! CellClass

        cell.name1.text = data.restaurantNames[indexPath.row]
        
        //cell.IView.image = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
        //cell.IView.downloadImageFrom(link: restaurants[indexPath.row].pictures[0], contentMode: UIViewContentMode.scaleAspectFit)
        loadRestaurantDetail(index: indexPath.row, cell: cell)
        
        //cell.name2.text = String(repeating: "★", count: Int(restaurants[indexPath.row].rating))
        cell.distanceLabel.text = String(data.restaurantDistances[indexPath.row])
        //cell.IView.image = restaurants[indexPath.row].image1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = data.restaurantNames[indexPath.row]
            print("IMAGE::::   \(data.restaurants[indexPath.row].image1?.images)")
            vc.restDetail = data.restaurants[indexPath.row]
            //vc.pictures[indexPath.row] = data.restaurantDetails["photos"].stringValue
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
