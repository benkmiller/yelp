//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UITextField!
    @IBOutlet weak var butView: UIView!
    @IBOutlet weak var Button: UIButton!
    
    
    
    @IBAction func SubmitTapped(_ sender: Any) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {

            navigationController?.pushViewController(tabView, animated: true)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //hideButton()
        // Do any additional setup after loading the view.
    }
    
    func hideButton() {
        butView.isOpaque = true
        Button.isOpaque = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
