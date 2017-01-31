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
    
    @IBOutlet weak var PhotoButton1: UIButton!
    //@IBOutlet weak var PhotoButton2: UIButton!
    //@IBOutlet weak var PhotoButton3: UIButton!
    
    @IBOutlet weak var MapsButton: UIButton!
    @IBOutlet weak var ReviewButton: UIButton!
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var reviewView: UITextView!
    
    var webView: WKWebView?

    var pictures: [String] = ["","","","","","","","","",""]
    //var restDetail: Restaurant?
    
    /*
    init (restDetailNew: Restaurant, imagesNew: ImageStruct, reviewsNew: Reviews){
        restDetail = restDetailNew
        images = imagesNew
        reviews = reviewsNew
        super.init(nibName: nil, bundle: nil)
    }
    */
    
    
 
    
    var restDetail: Restaurant?
    var images: ImageStruct?
    var reviews: Reviews?

    
    
    var totalString: String = ""
    var temp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let url = URL(string: restDetail.reviews["url"].stringValue)!
        //webView.load(URLRequest(url: url))
        //webView.allowsBackForwardNavigationGestures = true
        
        configureContent()
        setPics()
        setReviews()
        setDetails()
        
    
    }
    
    func configureContent(){
        PhotoButton1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //PhotoButton2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //PhotoButton3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        PhotoButton1.layer.cornerRadius = 4
        //PhotoButton2.layer.cornerRadius = 4
        //PhotoButton3.layer.cornerRadius = 4
        
        MapsButton.backgroundColor = .clear
        MapsButton.layer.cornerRadius = 4
        MapsButton.layer.borderWidth = 1
        MapsButton.layer.borderColor = UIColor(netHex:0xFF8E79).cgColor
        ReviewButton.backgroundColor = UIColor(netHex:0xFF8E79)
        ReviewButton.layer.cornerRadius = 4
        reviewView.layer.cornerRadius = 4
        Details.layer.masksToBounds = true
        Details.layer.cornerRadius = 4
    }
    
    func setPics() {
        //print("Image1: \(restDetail.image1)   ************")
        PhotoButton1.setImage(images?.image1, for: .normal)
        //PhotoButton2.setImage(restDetail.image2, for: .normal)
        //PhotoButton3.setImage(restDetail.image3, for: .normal)
    }
    
    func setReviews() {
        for index in 0...2 {
            let authorString = "Author: "+(reviews?.reviews["reviews"][index]["user"]["name"].stringValue)!+"\n"
            
            let timeString = "Time Created: "+(reviews?.reviews["reviews"][index]["time_created"].stringValue)!+"\n"
            let ratingString = "Rating: "+(reviews?.reviews["reviews"][index]["rating"].stringValue)!+"/5 Stars\n\n"
            let reviewString = (reviews?.reviews["reviews"][index]["text"].stringValue)!+"\n\n"+"--------------------------\n\n"
            
            totalString = authorString+timeString+ratingString+reviewString
            /*
            TotalString = "Author: "+reviews.reviews["reviews"][index]["user"]["name"].stringValue+"\n"+"Time Created: "+reviews.reviews["reviews"][index]["time_created"].stringValue+"\n"+"Rating: "+reviews.reviews["reviews"][index]["rating"].stringValue+"/5 Stars\n\n"+reviews.reviews["reviews"][index]["text"].stringValue+"\n\n"+"--------------------------\n\n"
            */
            temp += reviewString
        }
        print("Author"+(reviews?.reviews["reviews"][0]["user"]["name"].stringValue)!)
        print(temp)
        reviewView.text = temp

    }
    
    func setDetails(){
        let catLine = " Category: "+(restDetail?.type)!+"\n"
        let addLine = " Address: "+(restDetail?.address)!+"\n"
        let priceLine = " Price: "+(restDetail?.price)!+"\n"
        let ratLine = " Avg Rating: "+String(repeating: "★", count: Int((restDetail?.rating)!))+"\n"
        let revLine = " Phone Number: "+(restDetail?.phoneNum)!
        Details.text = catLine+addLine+priceLine+ratLine+revLine
    }

    @IBAction func MapsButtonPressed(_ sender: Any) {
        if let mapView2 = storyboard?.instantiateViewController(withIdentifier: "mapView2") as? MapViewController {
            //tabView.restaurants = self.restaurants
            //tabView.data = self.data
            print("I WA PRESSED")
            mapView2.lat = restDetail?.lat
            mapView2.long = restDetail?.long
            // mapView.
            navigationController?.pushViewController(mapView2, animated: true)
        }
        
    }
    
    //@IBAction func ReviewButtonPressed(_ sender: Any) {
        //loadView()
        
    //}
    /*
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "yelp.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: restDetail.reviews[0]["url"].stringValue)!
        webView?.load(URLRequest(url: url))
    }
    */
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


