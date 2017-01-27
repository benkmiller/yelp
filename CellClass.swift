//
//  CellClass.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-01-27.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var IView: UIImageView!
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
