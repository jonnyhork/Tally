//
//  VotingViewController.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

/*
 This VC will allow the user to view the current options and then tap the one they want to vote on.
    - it needs to know what the status of the current poll is
        - Choices
        - Current number of votes
 
 do I need to pass this VC the current state of poll?
 */

import UIKit
import Messages
import ChameleonFramework

protocol votingViewControllerDelegate: class {
    func addVoteToPoll(userChoice: String, instance: VotingViewController)
    func sendUpdatedPoll()
}


class VotingViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var votingTableView: UITableView!
    
    @IBOutlet weak var pollTitle: UILabel!
    
    var poll: Poll? {
        didSet {
            votingTableView?.reloadData()
        }
    }
    
    var currentConversation: MSConversation?
    weak var delegate: votingViewControllerDelegate?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: self.view.frame, colors: [HexColor("FAFAFA"), HexColor("48C0D3")]) // "3B5998"
        //TODO: Set yourself as the delegate and datasource here:
        votingTableView.delegate = self
        votingTableView.dataSource = self
        pollTitle.text = poll?.title ?? "make your choice 👇"
        
        //TODO: Register your MessageCell.xib file here:
        votingTableView.register(UINib(nibName: "VotingCell", bundle: nil), forCellReuseIdentifier: "CustomVotingCell")
    }
    

    //MARK: - TableView DataSource Methods
/////////////////////////////////////////////////////////////////////

    // Triggered when the table view looks to find something to display
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomVotingCell", for: indexPath) as! CustomVotingCell
        
        var pollArray : [(String, Set<String>)] = []
        
        for (key, value) in (poll?.list)! {
            pollArray.append((key, value))
        }
        
        votingTableView.frame.size.height = (cell.frame.size.height * CGFloat((poll?.list.count)!))
       
        let (key, value) = pollArray[indexPath.row]
        cell.configure(option: key, tally: value.count)

        return cell
    }
    
    // determines how many cells to render based on the number options in the poll
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (poll?.list.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedCell = votingTableView.cellForRow(at: indexPath) as! CustomVotingCell
        guard let option = selectedCell.option else { return }
        
        // make a call to add a vote to the option
        self.delegate?.addVoteToPoll(userChoice: option, instance: self)
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.delegate?.sendUpdatedPoll()
        self.dismiss()
    }
}
