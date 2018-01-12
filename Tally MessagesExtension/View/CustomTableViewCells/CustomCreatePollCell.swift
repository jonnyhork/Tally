//
//  CustomCreatePollCell.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/11/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit

protocol CreatePollCellDelegate: class {
    func addNewCell()
}

class CustomCreatePollCell: UITableViewCell {
   
  weak var delegate: CreatePollCellDelegate?
    
    @IBOutlet weak var optionTextField: UITextField!
    
    @IBAction func detailButton(_ sender: UIButton) {
        self.delegate?.addNewCell()
        print("detailButton Pressed")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
