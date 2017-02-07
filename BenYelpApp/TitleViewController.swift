//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class TitleViewController: UIViewController {
    
    var location: String?
    //var data = YelpData()
    var dataRetrieve = DataRetrieval()
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        Button.backgroundColor = .clear
        Button.layer.cornerRadius = 4
        Button.layer.borderWidth = 1
        Button.layer.borderColor = UIColor.red.cgColor
        //self.hideKeyboardWhenTappedAround()
        //authenticateUser()
        //loadRestaurantIds()
        
        let url = dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location
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
        
        
        //authenticateUser{ (responseObject, error) in
        //    print(responseObject ?? nil)
        //}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            /*
            if TitleLabel.text != nil && TitleLabel.text != ""{
                dataRetrieve.data.location = tabView.rewriteString(string: TitleLabel.text!)
                dataRetrieve.loadRestaurantIds(url: dataRetrieve.data.urlP1+dataRetrieve.data.term+dataRetrieve.data.urlP2+dataRetrieve.data.location){ response in
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
            */
 
            tabView.dataRetrieve = dataRetrieve
            tabView.dataRetrieve.data = dataRetrieve.data
            navigationController?.pushViewController(tabView, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
 */
