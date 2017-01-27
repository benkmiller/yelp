//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire

class TitleViewController: UIViewController {
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            tabView.restaurants = self.restaurants
            tabView.data = self.data
            navigationController?.pushViewController(tabView, animated: true)
        }
    }
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UITextField!
    
    var data = YelpData()
    var restaurants = [Restaurant](repeating: Restaurant(), count:10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button.isOpaque = true
        if !TitleLabel.isEditing{
            Button.isOpaque = true
        }
        else{
            Button.isOpaque = false
        }
        //hideButton()
        // Do any additional setup after loading the view.
        loadRestaurantIds()
    }
    
    func hideButton() {
        Button.isOpaque = true
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
                    
                    //debugPrint(responseData)
                    let jsonVar = JSON(responseData.result.value!)
                    
                    self.data.restaurantDetails[index] = jsonVar
                    self.restaurants[index].updateInfo(json: jsonVar)
                    
                    print("*********loading details")
                    print(self.restaurants[index].name)
                    
                    /*
                    self.restaurants[index].name = jsonVar["name"].stringValue
                    self.restaurants[index].pictures = jsonVar["photos"].arrayObject as! [String]
                    self.restaurants[index].rating = jsonVar["rating"].intValue
                    self.restaurants[index].price = jsonVar["price"].stringValue
                    self.restaurants[index].address = jsonVar["location"]["address1"].stringValue
                    self.restaurants[index].type = jsonVar["categories"][0]["title"].stringValue
                    self.restaurants[index].phoneNum = jsonVar["phone"].stringValue
                    self.restaurants[index].lat = jsonVar["latitude"].doubleValue
                    self.restaurants[index].long = jsonVar["longitude"].doubleValue
                    */
                    
                    //if index == 9 {
                    //self.loadPics()
                    //self.tableView.reloadData()
                    //self.loadRestaurantReviews()
                    //for index2 in 0...9{
                   
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
