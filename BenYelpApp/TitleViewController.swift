//
//  TitleViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-24.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if let tabView = storyboard?.instantiateViewController(withIdentifier: "Table") as? ViewController {
            
            navigationController?.pushViewController(tabView, animated: true)
        }
    }
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button.isOpaque = true
        if !TitleLabel.isEditing{
            Button.isOpaque = true
        }
        else{
            Button.isOpaque = false
        }
        //hideButton()
        // Do any additional setup after loading the view.
    }
    
    func hideButton() {
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
