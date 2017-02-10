//
//  MapAnnotation.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-31.
//  Copyright © 2017 Ben Miller. All rights reserved.
//
import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        //self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }

}
