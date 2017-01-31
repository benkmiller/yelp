//
//  Restaurant.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import MapKit

class Restaurant: NSObject {
  
    func updateInfo(json: JSON){
        name = json["name"].stringValue
        pictures = json["photos"].arrayObject as! [String]
        rating = json["rating"].intValue
        price = json["price"].stringValue
        address = json["location"]["address1"].stringValue
        //distanceTo = coordinate.distance(from: RestaurantCoordinate)
        type = json["categories"][0]["title"].stringValue
        phoneNum = json["phone"].stringValue
        lat = json["latitude"].doubleValue
        long = json["longitude"].doubleValue
    }
    
    func updateReviews(json: JSON){
        reviews = json
    }
    
    var name: String = ""
    var pictures: [String] = ["","",""]
    var rating: Int = 0
    var price = ""
    var distanceTo: Double?
    var address: String = ""
    var reviews: JSON = [:]
    var type = ""
    var phoneNum = ""
    var lat: Double?
    var long: Double?
    var reviewUrl: String = ""
    //var image1 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    //var image2 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    //var image3 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    var image1: UIImage?
    var image2: UIImage?
    var image3: UIImage?
    

}
