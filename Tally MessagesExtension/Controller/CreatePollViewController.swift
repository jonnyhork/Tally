//
//  CreatePollViewController.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

/*
 This VC will allow the user to add more options to the poll and then press send.
 
 -- Dynamically generate a new text field, should it need to be a collection of UITextField type?
 -- when send is pressed the list of options will be sent to the MessagesVC
    + a new poll obj will be generated
    + prepareURL
    + prepareMessage
 
 */

import UIKit
import Messages
import ChameleonFramework


protocol CreatePollViewControllerDelegate: class {
    func newPollCreated(pollOptions: [String])
}

class CreatePollViewController: MSMessagesAppViewController, UITableViewDelegate {
    
    // TODO: Add some variable to collect the tableview values?
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var createPollTableView: UITableView!
    
    var optionsArray: [String] = []
    var optionNumber = 0
    weak var delegate: CreatePollViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.delegate?.newPollCreated(pollOptions: optionsArray)
        self.dismiss()
    }
  

}
