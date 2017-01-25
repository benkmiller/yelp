//
//  DetailViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-23.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var reviewView: UITextView!
    
    
    @IBOutlet weak var ReviewTable: UITableView!
    
    
    var pictures: [String] = ["","","","","","","","","",""]
    var restDetail: Restaurant = Restaurant()
    var reviewString: String = ""
    var temp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...2 {
            //reviewString.append(other: "Author: "+restDetail.reviews["reviews"][index]["user"]["name"].stringValue+"\n")
            //reviewString.append(contentsOf: "Time Created: "+restDetail.reviews["reviews"][index]["time_created"].stringValue+"\n")
            //reviewString.append(contentsOf: restDetail.reviews["reviews"][index]["rating"].stringValue)
            //reviewString.append(contentsOf: restDetail.reviews["reviews"][index]["text"].stringValue)

            reviewString = "Author: "+restDetail.reviews["reviews"][index]["user"]["name"].stringValue+"\n"+"Time Created: "+restDetail.reviews["reviews"][index]["time_created"].stringValue+"\n"+"Rating: "+restDetail.reviews["reviews"][index]["rating"].stringValue+"/5 Stars\n\n"+restDetail.reviews["reviews"][index]["text"].stringValue+"\n\n"+"--------------------------\n\n"
        
            temp = reviewString
            reviewString = temp + reviewString
            
            
        }
        print(reviewString)
        reviewView.text = reviewString
        
        print(restDetail.reviews["reviews"][0]["text"].stringValue)
        
        
        for index in 0...2 {
            reviewView.text = restDetail.reviews["reviews"][0]["text"].stringValue
        }
        
        
        //reviewView.text = restDetail.reviews["reviews"][0]["text"].stringValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
