//
//  CustomVotingCell.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/11/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit

class CustomVotingCell: UITableViewCell {

    private(set) var option: String?
    private(set) var numberOfVotes: Int?
    
    @IBOutlet private weak var votingOptionLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        totalVotesLabel.layer.cornerRadius = totalVotesLabel.frame.width/2
        totalVotesLabel.clipsToBounds = true
        
    }

    func configure(option: String, tally: Int) {
       
//        if numberOfVotes != tally {
            UIView.animate(withDuration: 0.5, animations: {
                self.totalVotesLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { _ in
                self.totalVotesLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
//        }
        
        self.option = option
        self.numberOfVotes = tally
        
        votingOptionLabel.text = option
        totalVotesLabel.text = "\(tally)"
    }
    
}
