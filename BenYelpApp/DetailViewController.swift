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
//import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var photoButton2: UIButton!
    @IBOutlet weak var photoButton3: UIButton!
    @IBOutlet weak var photoButton1: UIButton!
    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var reviewView: UITextView!
    
    var restDetail: Restaurant?
    var image1: ImageStruct?
    var image2: UIImage?
    var image3: UIImage?
    var reviews: Reviews?

    var totalString: String = ""
    var temp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContent()
        loadPic()
        setPics()
        setReviews()
        setDetails()
    }
    
    //set text view to top
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reviewView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func loadPic(){
        for index in 1...2 {
        
            Alamofire.request((restDetail?.pictures[index])!).responseImage { [weak self] response in
                guard let viewController = self else {
                    return
                }
                
                if let image = response.result.value{
                    if index == 1 {
                        viewController.image2 = image
                        viewController.photoButton2.setImage(viewController.image2, for: .normal)
                    }
                    if index == 2 {
                        viewController.image3 = image
                        viewController.photoButton3.setImage(viewController.image3, for: .normal)
                    }
                }
                else{
                    print("ERROR LOADING PIC")
                }
            }
        }
        
    }
    
    func configureContent(){
        photoButton1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        photoButton2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        photoButton3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        photoButton1.layer.cornerRadius = 4
        photoButton2.layer.cornerRadius = 4
        photoButton3.layer.cornerRadius = 4
        
        mapsButton.backgroundColor = .clear
        mapsButton.layer.cornerRadius = 4
        mapsButton.layer.borderWidth = 1
        mapsButton.layer.borderColor = UIColor(netHex:0xFF8E79).cgColor
        
        reviewButton.backgroundColor = UIColor(netHex:0xFF8E79)
        reviewButton.layer.cornerRadius = 4
        
        reviewView.layer.cornerRadius = 4
        
        details.layer.masksToBounds = true
        details.layer.cornerRadius = 4
    }
    
    func setPics() {
        photoButton1.setImage(image1?.image1, for: .normal)
        //PhotoButton2.setImage(restDetail.image2, for: .normal)
        //PhotoButton3.setImage(restDetail.image3, for: .normal)
    }
    
    func setReviews() {
        for index in 0...2 {
            let authorString = "Author: "+(reviews?.reviews["reviews"][index]["user"]["name"].stringValue)!+"\n"
            
            let timeString = "Time Created: "+(reviews?.reviews["reviews"][index]["time_created"].stringValue)!+"\n"
            let ratingString = "Rating: "+String(repeating: "★", count: Int((reviews?.reviews["reviews"][index]["rating"].stringValue)!)!)+"\n\n"
            
            let reviewString = (reviews?.reviews["reviews"][index]["text"].stringValue)!+"\n\n"+"--------------------------------------------\n\n"
            
            totalString = authorString+timeString+ratingString+reviewString
            temp += totalString
        }
        print("Author"+(reviews?.reviews["reviews"][0]["user"]["name"].stringValue)!)
        print(temp)
        reviewView.text = temp

    }
    
    func setDetails(){
        let catLine = " Category: \((restDetail?.type)!)+\n"
        let addLine = " Address: "+(restDetail?.address)!+"\n"
        let priceLine = " Price: "+(restDetail?.price)!+"\n"
        let ratLine = " Avg Rating: "+String(repeating: "★", count: Int((restDetail?.rating)!))+"\n"
        let revLine = " Phone Number: "+(restDetail?.phoneNum)!
        details.text = catLine+addLine+priceLine+ratLine+revLine
    }
    
    
    @IBAction func photo1Tapped(_ sender: Any) {
        if let photoView = storyboard?.instantiateViewController(withIdentifier: "PhotoView") as? ImageViewController {
            if let image = image1?.image1 {
                photoView.image = image
            }
            navigationController?.pushViewController(photoView, animated: true)
        }
    }
    
    @IBAction func photo2Pressed(_ sender: Any) {
        if let photoView = storyboard?.instantiateViewController(withIdentifier: "PhotoView") as? ImageViewController {
            photoView.image = image2
            navigationController?.pushViewController(photoView, animated: true)
        }

    }

        
    @IBAction func photo3Tapped(_ sender: Any) {
        if let photoView = storyboard?.instantiateViewController(withIdentifier: "PhotoView") as? ImageViewController {
            photoView.image = image3
            navigationController?.pushViewController(photoView, animated: true)
        }
    }
    
    
    @IBAction func mapsButtonPressed(_ sender: Any) {
        if let mapView2 = storyboard?.instantiateViewController(withIdentifier: "mapView2") as? MapViewController {
            mapView2.lat = restDetail?.lat
            mapView2.long = restDetail?.long
            mapView2.restDetail = restDetail
            navigationController?.pushViewController(mapView2, animated: true)
        }
    }
    
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        let vc = WebViewController()
        
        vc.urlToLoad = reviews?.reviews["reviews"][0]["url"].stringValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
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
