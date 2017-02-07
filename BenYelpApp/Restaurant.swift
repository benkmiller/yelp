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
    
    init() {
        
    }
    
    var name: String = ""
    var pictures: [String] = ["","",""]
    var rating: Int = 0
    var price = ""

    var address: String = ""
    var type = ""
    var phoneNum = ""
    var lat: Double?
    var long: Double?
    var reviewUrl: String = ""
    var distanceToUser: Double?
    
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



