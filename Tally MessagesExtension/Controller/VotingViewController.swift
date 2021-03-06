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
 */

import UIKit
import Messages
import ChameleonFramework

protocol votingViewControllerDelegate: class {
    func addVoteToPoll(userChoice: String, instance: VotingViewController)
    func sendUpdatedPoll()
}


class VotingViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {
    let cellHeight: CGFloat = 45
    var biggestVote: Int = 0

    @IBOutlet weak var votingTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pollTitle: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var poll: Poll? {
        didSet {
            votingTableView?.reloadData()
        }
    }
    
    var currentConversation: MSConversation?
    weak var delegate: votingViewControllerDelegate?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the SendButton
        sendButton.layer.cornerRadius = 4.0
        sendButton.layer.shadowColor = UIColor.flatBlueColorDark().cgColor
        sendButton.layer.shadowOpacity = 1
        sendButton.layer.shadowOffset = CGSize.init(width: 5.0, height: 5.0)
        sendButton.layer.shadowRadius = 10
        
        self.view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: self.view.frame, colors: [HexColor("FAFAFA"), HexColor("48C0D3")]) // "3B5998"
        
        // Set yourself as the delegate and datasource here:
        votingTableView.delegate = self
        votingTableView.dataSource = self
        pollTitle.text = poll?.title ?? "What's The Tally❓"
        
        // change shape of tableview
        votingTableView.layer.cornerRadius = 4.0
        votingTableView.clipsToBounds = true
        votingTableView.layer.borderColor = UIColor.gray.cgColor
        votingTableView.layer.borderWidth = 0.5
        
        // Register your MessageCell.xib file here:
        votingTableView.register(UINib(nibName: "VotingCell", bundle: nil), forCellReuseIdentifier: "CustomVotingCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewHeightConstraint.constant = (cellHeight * CGFloat((poll?.list.count)!))
        view.layoutIfNeeded()
    }
    
    func highestNumberOfVotes( _ array :[(String, Set<String>)]) -> Int {
        var num:Int = 0
       
        for element in array {
            if element.1.count > num {
                num = element.1.count
            }
        }
        return num
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
        
        biggestVote = highestNumberOfVotes(pollArray)
        
        let (key, value) = pollArray[indexPath.row]
        
        cell.configure(option: key, tally: value.count)
      
        // need to send the biggest vote along with the poll in order to not reset biggestVote

            if value.count != 0, value.count >= biggestVote {
                print("YES!")
                cell.totalVotesLabel.backgroundColor = HexColor("2ecc71") // green

            } else {
                cell.totalVotesLabel.backgroundColor = HexColor("F61666") // red
            }

        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.delegate?.sendUpdatedPoll()
        self.dismiss()
    }
}
