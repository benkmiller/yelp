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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        centerMap(lat: lat!, long: long!)
        print("lat=   \(lat!)")
        print("long=   \(long!)")

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
