//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire

class TitleViewController: UIViewController {
    
    var location: String?
    var data = YelpData()
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            //tabView.restaurants = self.restaurants
            //tabView.data = self.data
            if TitleLabel.text != nil && TitleLabel.text != ""{
                data.location = tabView.rewriteString(string: TitleLabel.text!)
            }
            tabView.data = data
            navigationController?.pushViewController(tabView, animated: true)
        }
    }
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Button.backgroundColor = .clear
        Button.layer.cornerRadius = 4
        Button.layer.borderWidth = 1
        Button.layer.borderColor = UIColor.red.cgColor
        
        loadRestaurantIds()
    }
    
    func hideButton() {
        Button.isOpaque = true
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
