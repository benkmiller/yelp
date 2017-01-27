//
//  DetailViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-23.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import WebKit

class DetailViewController: UIViewController, UITableViewDelegate, WKNavigationDelegate {
   // @IBOutlet weak var Img3: UIImageView!
   // @IBOutlet weak var Img2: UIImageView!
   // @IBOutlet weak var Img1: UIImageView!
    @IBOutlet weak var But1: UIButton!
    @IBOutlet weak var But2: UIButton!
    @IBOutlet weak var But3: UIButton!
    
    

    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var reviewView: UITextView!
    
    @IBOutlet weak var ReviewTable: UITableView!
    
    
    
    var webView: WKWebView!

    var pictures: [String] = ["","","","","","","","","",""]
    var restDetail: Restaurant = Restaurant()
    var reviewString: String = ""
    var temp = ""
    //var image1: UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //In viewDidLoad, set button.imageView.contentMode to UIViewContentMode.ScaleAspectFill.
        
        But1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        But2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        But3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        let catLine = " Category: "+restDetail.type+"\n"
        let addLine = " Address: "+restDetail.address+"\n"
        let priceLine = " Price: "+restDetail.price+"\n"
        let ratLine = " Avg Rating: "+String(restDetail.rating)+"\n"
        let revLine = " Phone Number: "+restDetail.phoneNum
        
        //let url = URL(string: restDetail.reviews["url"].stringValue)!
        //webView.load(URLRequest(url: url))
        //webView.allowsBackForwardNavigationGestures = true
        
        //Details Text
        Details.text = catLine+addLine+priceLine+ratLine+revLine
        
        //Review Text
        for index in 0...2 {
            reviewString = "Author: "+restDetail.reviews["reviews"][index]["user"]["name"].stringValue+"\n"+"Time Created: "+restDetail.reviews["reviews"][index]["time_created"].stringValue+"\n"+"Rating: "+restDetail.reviews["reviews"][index]["rating"].stringValue+"/5 Stars\n\n"+restDetail.reviews["reviews"][index]["text"].stringValue+"\n\n"+"--------------------------\n\n"
        
            temp += reviewString
        }
        print(temp)
        reviewView.text = "Reviews (3): \n\n"+temp
        
        setPics()
        //loadPics()
        //Img1.image = image1
        
    }
    
    func setPics() {
        self.But1.setImage(restDetail.image1, for: .normal)
        self.But2.setImage(restDetail.image2, for: .normal)
        self.But3.setImage(restDetail.image3, for: .normal)
    }
    
    /*
    func loadPics() {
        for index in 0...self.restDetail.pictures.count - 1 {
            Alamofire.request(self.restDetail.pictures[index]).responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
            
                let image = response.result.value
                if index == 0 {
                    self.But1.setImage(image!, for: .normal) //= image!
                }
                if index == 1 {
                    self.But2.setImage(image!, for: .normal)
                }
                if index == 2 {
                    self.But3.setImage(image!, for: .normal)
                }
                
            }
        }
    }
    */
    /*
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "yelp.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: restDetail.reviews["url"].stringValue)!
        webView.load(URLRequest(url: url))
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
