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
    
    //var userLocation: CLLocationCoordinate2D?
    //var locationManager =  CLLocationManager()
    
    var dataRetrieve = DataRetrieval()
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var button: UIButton!
    
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
        button.backgroundColor = .clear
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            if locationLabel.text != nil && locationLabel.text != ""{
                dataRetrieve.data.location = tabView.rewriteString(string: locationLabel.text!)
                dataRetrieve.loadRestaurantIds(url: dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location){ [unowned self] response in
                    
                    //let jsonVar = JSON(response.result.value!)
                    for index in 0...9 {
                        self.dataRetrieve.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                        self.dataRetrieve.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                        self.dataRetrieve.data.dat = response;
                    }
                    tabView.dataRetrieve = self.dataRetrieve
                    self.navigationController?.pushViewController(tabView, animated: true)
                }
            }
            else {
                tabView.dataRetrieve = dataRetrieve
                navigationController?.pushViewController(tabView, animated: true)
            }
        }

    }
    
    
    /*
    @IBAction func buttonTapped(_ sender: Any) {
       performSegue(withIdentifier: "goToTableView", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTableView" {
            if let tabView = segue.destination as? ViewController {
                if locationLabel.text != nil && locationLabel.text != ""{
                    dataRetrieve.data.location = tabView.rewriteString(string: locationLabel.text!)
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
                    }
                }
                else {
                    tabView.userLocation = userLocation
                    tabView.locationManager = locationManager
                    tabView.dataRetrieve = dataRetrieve
                    tabView.dataRetrieve.data = dataRetrieve.data
                }
            }
        }
    }
    */
    ///LOCATION METHODS
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //map.showsUserLocation = true
            dataRetrieve.data.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            dataRetrieve.data.locationManager.startUpdatingLocation()
        }
        else {
            dataRetrieve.data.locationManager.requestWhenInUseAuthorization()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


