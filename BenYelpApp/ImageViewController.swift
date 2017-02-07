//
//  ImageViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-02-02.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var _Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _Image.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
