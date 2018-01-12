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
    func addVoteToPoll(with: String)
}


class VotingViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var votingTableView: UITableView!
    
    var poll: Poll?
    var currentConversation: MSConversation?
    weak var delegate: votingViewControllerDelegate?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Set yourself as the delegate and datasource here:
        votingTableView.delegate = self
        votingTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        votingTableView.register(UINib(nibName: "VotingCell", bundle: nil), forCellReuseIdentifier: "CustomVotingCell")
    }
    

    //MARK: - TableView DataSource Methods
/////////////////////////////////////////////////////////////////////

    //TODO: Declare cellForRowAtIndexPath here: triggered when the table view looks to find something to display
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomVotingCell", for: indexPath) as! CustomVotingCell
        
        var pollArray : [(String, Set<String>)] = []
        
        for (key, value) in (poll?.list)! {
            pollArray.append((key, value))
        }
        
        let (key, value) = pollArray[indexPath.row]
        cell.votingOptionLabel.text = key
        cell.totalVotesLabel.text = String(value.count)

    
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (poll?.list.count)!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = votingTableView.cellForRow(at: indexPath) as! CustomVotingCell
        guard let selectedOption = selectedCell.votingOptionLabel.text else {fatalError("no slected optption")}
        
        // make a call to add a vote to the option
        self.delegate?.addVoteToPoll(with: selectedOption)
        /*
         var voteAction: (Poll) -> Void = { _ in }
         then call the action when needed: voteAction(self.poll!)
         */

//        poll?.addVote(to: selectedOption, by: <#T##String#>)
        
        /*
         this is what I'd like to do but I cant seem to pass the currentConversation: MSConversation to the votingVC to use the UUID:
            poll?.addVote(to: sender.currentTitle!, by: (currentConversation?.localParticipantIdentifier.uuidString)!)
        */
        
        // make sure the only vote one thing, remove the previous vote before added to the new vote
        print(selectedCell.votingOptionLabel.text!)
    }

}
