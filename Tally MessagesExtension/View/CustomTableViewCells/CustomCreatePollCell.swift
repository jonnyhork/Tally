//
//  CustomCreatePollCell.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/11/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit

class CustomCreatePollCell: UITableViewCell {

    @IBOutlet weak var optionTextField: UITextField!
    
    
    @IBAction func detailButton(_ sender: UIButton) {
        print("detailButton Pressed")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
