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

//protocol votingViewControllerDelegate: class {
//    func instantiateVotingVC(with: Poll) -> UIViewController
//}


class VotingViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var votingTableView: UITableView!
    
    var poll: Poll?
    var currentConversation: MSConversation?
//    weak var delegate: votingViewControllerDelegate?
  
    /*
     var voteAction: (Poll) -> Void = { _ in } // Worth's vote action
     then call the action when needed: voteAction(self.poll!)
    */
    
    
    
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
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    // User taps their choice and adds a vote
  @objc func userChoiceButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
        poll?.addVote(to: sender.currentTitle!, by: (currentConversation?.localParticipantIdentifier.uuidString)!)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
