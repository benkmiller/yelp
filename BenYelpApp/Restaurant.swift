//
//  Restaurant.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import MapKit

struct Restaurant{
    
    
    init (json: JSON, calculatedDistance: Double){
        name = json["name"].stringValue
        pictures = json["photos"].arrayObject as! [String]
        rating = json["rating"].intValue
        price = json["price"].stringValue
        address = json["location"]["address1"].stringValue
        type = json["categories"][0]["title"].stringValue
        phoneNum = json["phone"].stringValue
        lat = json["coordinates"]["latitude"].doubleValue
        long = json["coordinates"]["longitude"].doubleValue
        distanceToUser = calculatedDistance
    }
    
    

    /*
    func updateReviews(json: JSON){
        reviews = json
    }
     */
    
    init() {
        
    }
    
    var name: String = ""
    var pictures: [String] = ["","",""]
    var rating: Int = 0
    var price = ""

    var address: String = ""
    //var reviews: JSON = [:]
    var type = ""
    var phoneNum = ""
    var lat: Double?
    var long: Double?
    var reviewUrl: String = ""
    var distanceToUser: Double?
    //var image1 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    //var image2 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    //var image3 = UIImage(named: "Screen Shot 2017-01-23 at 8.19.32 PM")
    ///var image1: UIImage?
    ///var image2: UIImage?
    ///var image3: UIImage?
    
    
}

struct Reviews {
    init (json: JSON) {
        reviews = json
    }
    init(){
        
    }
    var reviews: JSON = [:]
}
//chain requests for 3 images!!!!!
struct ImageStruct {
    init(image: UIImage){
        image1 = image
    }
    init(){
        
    }
    var image1: UIImage?
    
}



