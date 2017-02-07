//
//  DataRetrieval.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-02-06.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class DataRetrieval: NSObject {
    
    var data = YelpData()

    func loadRestaurantIds(url: String, completion: @escaping (JSON) -> ())  {
        Alamofire.request(url, headers: data.header).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(data: response.data!)
                    completion(jsonData)
                case .failure(let error):
                    //MExceptionManager.handleNetworkErrors(error)
                    print("Fail")
                    completion(JSON(data: NSData() as Data))
                }
        }
    }
    
    func loadRestaurantDetail(index: Int, cell: CellClass, completion: @escaping (JSON) -> ()){
        Alamofire.request(data.urlDetail+data.restaurantIds[index], headers: data.header).validate().responseJSON { response in
            
            
                //debugPrint(responseData)
                
                switch response.result {
                case .success:
                    let jsonData = JSON(data: response.data!)
                    completion(jsonData)
                case .failure(let error):
                    //MExceptionManager.handleNetworkErrors(error)
                
                    print("FAIL")
                    completion(JSON(data: NSData() as Data))
                }
                
                //let jsonVar = JSON(response.result.value!)
                /*
                let lat = jsonVar["coordinates"]["latitude"].doubleValue
                let long = jsonVar["coordinates"]["longitude"].doubleValue
                
                self.data.restaurantDetails[index] = jsonVar
                //guard lat != 0 && long != 0  else {return}
                
                if let distance = self.locationManager.location?.distance(from: CLLocation(latitude: lat, longitude: long)){
                    let newRestaurant = Restaurant(json: jsonVar, calculatedDistance: distance)
                    self.data.restaurants[index] = newRestaurant
                    cell.distanceLabel.text = String(describing: Int(distance/1000))+"km away"
                    cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                }
                else{
                    let newRestaurant = Restaurant(json: jsonVar, calculatedDistance: 0.0)
                    self.data.restaurants[index] = newRestaurant
                    
                    cell.distanceLabel.text = "nodata"
                    cell.name2.text = String(repeating: "★", count: Int(self.data.restaurants[index].rating))
                }
                */
                //self.loadPic(index: index, cell: cell)
           
        }
    }
    
    func loadPic(index: Int, cell: CellClass, completion: @escaping (Image) -> ()){
        Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { [unowned self] response in
            //print("*********start load pics")
            //debugPrint(response)
            if let image = response.result.value{
                switch response.result {
                case .success:
                    //let jsonData = JSON(data: response.data!)
                    completion(image)
                case .failure(let error):
                    //MExceptionManager.handleNetworkErrors(error)
                    completion(image)
                }
                
                
                
                //let imageToSave = ImageStruct(image:image)
                //self.data.images[index] = imageToSave
                
                //cell.IView.contentMode = UIViewContentMode.scaleAspectFit
                //cell.IView.image = image
                
                //self.loadRestaurantReview(index: index, cell: cell)
            }
            else{
                print("ERROR LOADING PIC")
            }
        }
        
    }
    
    func loadRestaurantReview(index:Int, cell:CellClass, completion: @escaping (JSON) -> ()) {
        Alamofire.request(data.urlDetail+data.restaurantIds[index]+data.urlReview, headers: data.header).responseJSON { response in
            
            switch response.result {
            case .success:
                let jsonData = JSON(data: response.data!)
                completion(jsonData)
            case .failure(let error):
                //MExceptionManager.handleNetworkErrors(error)
                    
                print("FAIL")
                completion(JSON(data: NSData() as Data))
            }
        }
    }
    
    
    
}
