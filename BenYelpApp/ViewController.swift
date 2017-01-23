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
    
    
    let header: HTTPHeaders = [
        "Authorization": "Bearer FjlrPxjxGLStOinnoJ7wGK2W3GRMXXZmA_bPOOwFsktNC7tIMAcujcmUetfsRMY2_vdIanoVdoDS3iHctClh-k1UN_xmaZ_651dgbx9oChpC2U55yj7KRSSOVz6CWHYx"
    ]

    let urlForRestaurantId = "https://api.yelp.com/v3/businesses/search?term=ethiopian&latitude=43.649758&longitude=-79.385868"
    let urlForRestaurantId2 = "https://api.yelp.com/v3/businesses/search?term=ethiopian&location=Tornto"
    
    let urlDetail = "https://api.yelp.com/v3/businesses/"
    
    let urlP1 = "https://api.yelp.com/v3/businesses/search?term="
    let urlP2 = "&location="
    
    
   
   
    //let totalUrl = urlP1// + urlP2 + "&latitude=" + urlP3 + "&longitude" + urlP4
    //var restaurantIds = [String]
    var restaurantIds = ["","","","","","","","","",""]
    var restaurantNames = ["","","","","","","","","",""]
    
    var term = "ethiopian"
    var location = "Toronto"
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        if searchField.text != nil || searchField.text != "" {
            term = searchField.text!
        }
        loadRestaurantIds()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var restaurantIds: Any
        loadRestaurantIds()
        //loadRestaurantDetail()
        //getToken()
        //searchField.
 
    }
   
    
    func loadRestaurantIds()  {
        
        Alamofire.request(urlP1+term+urlP2+location, headers: header).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                for index in 0...9 {
                    self.restaurantIds[index] = swiftyJsonVar["businesses"][index]["id"].stringValue
                    self.restaurantNames[index] = swiftyJsonVar["businesses"][index]["name"].stringValue
                   
                }
                print(self.restaurantIds)
                print(self.restaurantNames)
                //self.tblJSON.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
    func loadResaurantInfo() {
        
    }
    
    func loadRestaurantReview() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let restaurantName = restaurantNames[indexPath.row]
        cell.textLabel?.text = restaurantNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        //let vc = DetailViewController()
        //navigationController?.pushViewController(vc, animated: true)
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

