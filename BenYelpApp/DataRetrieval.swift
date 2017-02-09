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
                    print("ERROR RETRIEVING IDS: \(error.localizedDescription)")
                    //completion(JSON(data: NSData() as Data))
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
                    print("ERROR RETRIEVING DETAILS: \(error.localizedDescription)")
                }
        }
    }
    
    func loadPic(index: Int, cell: CellClass, completion: @escaping (Image) -> ()){
        Alamofire.request(self.data.restaurants[index].pictures[0]).responseImage { response in
            //print("*********start load pics")
            //debugPrint(response)
            if let image = response.result.value{
                switch response.result {
                case .success:
                    completion(image)
                case .failure(let error):
                    print("ERROR RETRIEVING PHOTOS: \(error.localizedDescription)")
                }
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
                print("ERROR RETRIEVING REVIEWS: \(error.localizedDescription)")
                completion(JSON(data: NSData() as Data))
            }
        }
    }
    
    
    
}
