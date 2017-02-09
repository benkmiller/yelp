//
//  MapViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-29.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    var lat: Double?
    var long: Double?
    var restDetail: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = restDetail?.name
        map.delegate = self
        centerMap(lat: lat!, long: long!)
        setAnnotation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMap(lat: Double, long: Double){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lat, longitude: long), (restDetail?.distanceToUser)!*2.5, (restDetail?.distanceToUser)!*2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func setAnnotation(){
        let annotation = MapAnnotation(title: (restDetail?.name)!,
                              locationName: (restDetail?.address)!,coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
        map.addAnnotation(annotation)
    }

}

extension MapViewController: MKMapViewDelegate {
    
}
