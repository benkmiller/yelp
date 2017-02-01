//
//  MapViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-29.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    var lat: Double?
    var long: Double?
    var restDetail: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = restDetail?.name
        map.delegate = self
        print("lat=   \(lat!)")
        print("long=   \(long!)")
        centerMap(lat: lat!, long: long!)
        setAnnotation()
        
        

        // Do any additional setup after loading the view.
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lat, longitude: long), 1000, 1000)
        map.setRegion(coordinateRegion, animated: true)
       // mark = CLPlacemark.
        
    }
    
    func setAnnotation(){
        let annotation = MapAnnotation(title: (restDetail?.name)!,
                              locationName: (restDetail?.address)!,coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
        
        map.addAnnotation(annotation)
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
