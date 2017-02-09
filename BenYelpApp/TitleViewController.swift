//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class TitleViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D?
    var locationManager =  CLLocationManager()
    
    var dataRetrieve = DataRetrieval()
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        configure()
        locationAuthStatus()
        
        let url = dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location
        //Start loading data
        dataRetrieve.loadRestaurantIds(url: url){ response in
            print(response.stringValue)
            print("Starting DEBUG RESPONSE #@#@!@##$@")
            debugPrint(response)
            //let jsonVar = JSON(response.result.value!)
            for index in 0...9 {
                self.dataRetrieve.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                self.dataRetrieve.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                self.dataRetrieve.data.dat = response;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configure() {
        Button.backgroundColor = .clear
        Button.layer.cornerRadius = 4
        Button.layer.borderWidth = 1
        Button.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            if TitleLabel.text != nil && TitleLabel.text != ""{
                dataRetrieve.data.location = tabView.rewriteString(string: TitleLabel.text!)
                dataRetrieve.loadRestaurantIds(url: dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location){ [unowned self] response in
                    
                    //let jsonVar = JSON(response.result.value!)
                    for index in 0...9 {
                        self.dataRetrieve.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                        self.dataRetrieve.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                        self.dataRetrieve.data.dat = response;
                    }
                    tabView.userLocation = self.userLocation
                    tabView.locationManager = self.locationManager
                    tabView.dataRetrieve = self.dataRetrieve
                    tabView.dataRetrieve.data = self.dataRetrieve.data
                    self.navigationController?.pushViewController(tabView, animated: true)
                }
            }
            else {
                tabView.userLocation = userLocation
                tabView.locationManager = locationManager
                tabView.dataRetrieve = dataRetrieve
                tabView.dataRetrieve.data = dataRetrieve.data
                navigationController?.pushViewController(tabView, animated: true)
            }
        }
    }
    
    ///LOCATION METHODS
    override func viewDidAppear(_ animated: Bool) {
        //self.hideKeyboardWhenTappedAround()
        //locationAuthStatus()
        
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //map.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            
        }
        else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


