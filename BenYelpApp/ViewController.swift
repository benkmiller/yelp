//
//  ViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-20.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    var data = YelpData()
    
    
 
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        if searchField.text != nil || searchField.text != "" {
            data.term = searchField.text!
        }
        loadRestaurantIds()
        //loadRestaurantReviews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var restaurantIds: Any
        loadRestaurantIds()
         
    }
   
    func loadRestaurantIds()  {
        Alamofire.request(data.urlP1+data.term+data.urlP2+data.location, headers: data.header).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                for index in 0...9 {
                    self.data.restaurantIds[index] = swiftyJsonVar["businesses"][index]["id"].stringValue
                    self.data.restaurantNames[index] = swiftyJsonVar["businesses"][index]["name"].stringValue
                    self.data.dat = swiftyJsonVar;
                }
                print(self.data.restaurantIds)
                print(self.data.restaurantNames)
                self.loadRestaurantDetails()
                self.tableView.reloadData()
            }
        }
    }
    
    func loadRestaurantDetails() {
        for index in 0...9 {
            Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swifty = JSON(responseData.result.value!)
                    self.data.restaurantDetails[index] = swifty
                    
                    /*
                    self.data.restaurants[index].name = swifty["name"].stringValue
                    self.data.restaurants[index].pictures = swifty["photos"].arrayObject as! [String]
                    self.data.restaurants[index].rating = swifty["rating"].intValue
                    self.data.restaurants[index].price = swifty["price"].stringValue
                    self.data.restaurants[index].address = swifty["photos"].stringValue
                    self.data.restaurants[index].type = swifty["categories"][0]["title"].stringValue
                    self.data.restaurants[index].lat = swifty["latitude"]
                    self.data.restaurants[index].long = swifty["longitude"]
                    */
                    
                    //let reviewCount = swifty["review_count"].stringValue
                    //print("dfSDFSDFSDF\(index)")
                    //print(reviewCount)
                    //self.tblJSON.reloadData()
                    //self.tableView.reloadData()
                }
                
            }
        }

    }
    
    func loadRestaurantReviews() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let restaurantName = restaurantNames[indexPath.row]
        cell.textLabel?.text = data.restaurantNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.title = data.restaurantNames[indexPath.row]
            //vc.pictures[indexPath.row] = data.restaurantDetails["photos"].stringValue
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
 
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        //vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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

    

}

