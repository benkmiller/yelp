//
//  Data.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire

class YelpData: NSObject {

    let header: HTTPHeaders = [
        "Authorization": "Bearer FjlrPxjxGLStOinnoJ7wGK2W3GRMXXZmA_bPOOwFsktNC7tIMAcujcmUetfsRMY2_vdIanoVdoDS3iHctClh-k1UN_xmaZ_651dgbx9oChpC2U55yj7KRSSOVz6CWHYx"
    ]
    let urlForRestaurantId = "https://api.yelp.com/v3/businesses/search?term=ethiopian&latitude=43.649758&longitude=-79.385868"
    let urlForRestaurantId2 = "https://api.yelp.com/v3/businesses/search?term=ethiopian&location=Tornto"
    let urlDetail = "https://api.yelp.com/v3/businesses/"
    let urlP1 = "https://api.yelp.com/v3/businesses/search?term="
    let urlP2 = "&location="
    let urlReview = "/reviews"
    
    var restaurantIds = ["","","","","","","","","",""]
    var restaurantNames = ["","","","","","","","","",""]
       
    
    
    
    var dat:JSON = [""]
    var restaurantDetails: JSON = [""]
    
    var term = "ethiopian"
    var location = "Toronto"

    
}
