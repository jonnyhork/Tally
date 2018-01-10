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


class VotingViewController: MSMessagesAppViewController {

    // MARK: Updating the UI Methods
/**************************************************************************************************************************/
    func makeButton(choice: String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = UIColor.flatMint()
        button.setTitle(choice, for: .normal)
        button.setTitleColor(UIColor.flatPlumColorDark(), for: .normal)
        button.addTarget(self, action: #selector(userChoiceButtonPressed), for: .touchUpInside)
        
        return button
    }
    
    // User taps their choice and adds a vote
  @objc func userChoiceButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
//        newPoll.addVote(to: sender.currentTitle!, by: (currentConvo?.localParticipantIdentifier.uuidString)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
