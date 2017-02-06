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
    var data = YelpData()
    
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
        
        loadRestaurantIds(){ response in
            print(response.stringValue)
            print("Starting DEBUG RESPONSE #@#@!@##$@")
            debugPrint(response)
            //let jsonVar = JSON(response.result.value!)
            for index in 0...9 {
                self.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                self.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                self.data.dat = response;
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
            if TitleLabel.text != nil && TitleLabel.text != ""{
                data.location = tabView.rewriteString(string: TitleLabel.text!)
                loadRestaurantIds(){ response in
                    print(response.stringValue)
                    print("Starting DEBUG RESPONSE #@#@!@##$@")
                    debugPrint(response)
                    //let jsonVar = JSON(response.result.value!)
                    for index in 0...9 {
                        self.data.restaurantIds[index] = response["businesses"][index]["id"].stringValue
                        self.data.restaurantNames[index] = response["businesses"][index]["name"].stringValue
                        self.data.dat = response;
                    }
                }
            }
            tabView.data = data
            navigationController?.pushViewController(tabView, animated: true)
        }
    }
    
    func loadRestaurantIds(completion: @escaping (JSON) -> ())  {
        Alamofire.request(data.urlP1+data.term+data.urlP2+data.location, headers: data.header).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(data: response.data!)
                    completion(jsonData)
                case .failure(let error):
                    //MExceptionManager.handleNetworkErrors(error)
                    completion(JSON(data: NSData() as Data))
                }
        }
    }
    
    
    /*
    
    func loadRestaurantIds()  {
        Alamofire.request(data.urlP1+data.term+data.urlP2+data.location, headers: data.header).responseJSON { [unowned self] (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonVar = JSON(responseData.result.value!)
                for index in 0...9 {
                    self.data.restaurantIds[index] = jsonVar["businesses"][index]["id"].stringValue
                    self.data.restaurantNames[index] = jsonVar["businesses"][index]["name"].stringValue
                    self.data.dat = jsonVar;
                }
                //print("Load Rest Ids:\(self.data.restaurantNames)")
                //self.loadRestaurantDetails()
                
            }
            //self.loadRestaurantDetails()
        }
    }
 */
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
