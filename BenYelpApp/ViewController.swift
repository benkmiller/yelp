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


class ViewController: UITableViewController {
    var dataRetrieve =  DataRetrieval()
    //var userLocation: CLLocationCoordinate2D?
    //var locationManager: CLLocationManager?
    var reloadTableForSort = false
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dataRetrieve.data.locationManager.delegate = self
        self.searchField.delegate = self
    }
    
    @IBAction func goTapped(_ sender: Any) {
        if searchField.hasText == true {
            reloadTableForSort = false
            dataRetrieve.data.term = rewriteString(string: searchField.text!)
            let url = dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location
            dataRetrieve.loadRestaurantIds(url: url){ [unowned self] response in
                
                for index in 0...9 {
                    self.dataRetrieve.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                    self.dataRetrieve.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                    self.dataRetrieve.data.dat = response;
                }
                self.tableView.reloadData()
            }
        }
    }
    
   
    @IBAction func nearMeTapped(_ sender: Any) {
        let usrLat = self.dataRetrieve.data.locationManager.location?.coordinate.latitude
        let usrLong = self.dataRetrieve.data.locationManager.location?.coordinate.longitude
        
        let url = dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP1A+String(describing: usrLat!)+dataRetrieve.data.urlP2A+String(describing: usrLong!)
        
        dataRetrieve.loadRestaurantIds(url: url){ [unowned self] response in
            //let jsonVar = JSON(response.result.value!)
            for index in 0...9 {
                self.dataRetrieve.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                self.dataRetrieve.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                self.dataRetrieve.data.dat = response;
            }
            self.tableView.reloadData()
        }

    }
    
    
    @IBAction func sortTapped(_ sender: Any) {
        reloadTableForSort = true
        let ac = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rating", style: .default, handler: sortPageByRating))
        ac.addAction(UIAlertAction(title: "Distance", style: .default, handler: sortPageByDistance))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func sortPageByRating(action: UIAlertAction) {
        reloadTableForSort = true
        dataRetrieve.data.restaurants.sort() { $0.rating > $1.rating }
        for index in 0...9 {
            print(dataRetrieve.data.restaurants[index].rating)
        }
        tableView.reloadData()
    }
    
    func sortPageByDistance(action: UIAlertAction) {
        for index in 0...9{
            guard dataRetrieve.data.restaurants[index].distanceToUser != nil else {return}
        }
        reloadTableForSort = true
        dataRetrieve.data.restaurants.sort() { $0.distanceToUser! < $1.distanceToUser! }
        tableView.reloadData()
    }

    func rewriteString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


////DELEGATE METHODS
////DELEGATE METHODS
////DELEGATE METHODS
extension ViewController: UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellClass = tableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! CellClass
        
        cell.name1.text = dataRetrieve.data.restaurantNames[indexPath.row]
        
        if reloadTableForSort == false {
            dataRetrieve.loadRestaurantDetail(index: indexPath.row, cell: cell){ response in
                
                let lat = response["coordinates"]["latitude"].doubleValue
                let long = response["coordinates"]["longitude"].doubleValue
                
                self.dataRetrieve.data.restaurantDetails[indexPath.row] = response
                //guard lat != 0 && long != 0  else {return}
                
                if let distance = self.dataRetrieve.data.locationManager.location?.distance(from: CLLocation(latitude: lat, longitude: long)){
                    let newRestaurant = Restaurant(json: response, calculatedDistance: Double(distance))
                    self.dataRetrieve.data.restaurants[indexPath.row] = newRestaurant
                    cell.distanceLabel.text = String(describing: Int(distance/1000))+"km away"
                }
                else {
                    let newRestaurant = Restaurant(json: response, calculatedDistance: 1000.0)
                    self.dataRetrieve.data.restaurants[indexPath.row] = newRestaurant
                    cell.distanceLabel.text = String(describing: "no data")
                    
                }
                
                cell.name2.text = String(repeating: "★", count: Int(self.dataRetrieve.data.restaurants[indexPath.row].rating))
                
                self.dataRetrieve.loadPic(index: indexPath.row, cell: cell){ image in
                    let imageToSave = ImageStruct(image:image)
                    self.dataRetrieve.data.images[indexPath.row] = imageToSave
                    
                    cell.IView.contentMode = UIViewContentMode.scaleAspectFit
                    cell.IView.image = image
                    
                    self.dataRetrieve.loadRestaurantReview(index: indexPath.row, cell: cell){ jsonVal in
                        //let jsonVal = JSON(responseData.result.value!)
                        let newReview = Reviews(json: jsonVal)
                        self.dataRetrieve.data.reviews[indexPath.row] = newReview
                    }
                }
            }
        }
            
        else {
            cell.name1.text = dataRetrieve.data.restaurants[indexPath.row].name
            cell.name2.text = String(repeating: "★", count: Int(self.dataRetrieve.data.restaurants[indexPath.row].rating))
            cell.distanceLabel.text = String(describing: Int(dataRetrieve.data.restaurants[indexPath.row].distanceToUser!/1000))+"km away"
            cell.IView.contentMode = UIViewContentMode.scaleAspectFit
            cell.IView.image = dataRetrieve.data.images[indexPath.row].image1
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = dataRetrieve.data.restaurantNames[indexPath.row]
            vc.restDetail = dataRetrieve.data.restaurants[indexPath.row]
            vc.reviews = dataRetrieve.data.reviews[indexPath.row]
            vc.image1 = dataRetrieve.data.images[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
        tap.cancelsTouchesInView = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

