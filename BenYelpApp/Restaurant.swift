//
//  Restaurant.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    
    init(json: JSON, json2: JSON){
        name = json["name"].stringValue
        pictures = json["photos"].arrayObject as! [String]
        rating = json["rating"].intValue
        price = json["price"].stringValue
        address = json["photos"].stringValue
        
        type = json["categories"][0]["title"].stringValue
        phoneNum = json["phone"].stringValue
        lat = json["latitude"].doubleValue
        long = json["longitude"].doubleValue
    }
    
    var name: String = ""
    var pictures: [String] = [""]
    var rating: Int = 0
    var price = ""
    var address: String = ""
    var reviews = ""
    var type = ""
    var phoneNum = ""
    var lat: Double = 0.0
    var long: Double = 0.0

}
