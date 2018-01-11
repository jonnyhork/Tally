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

class CreatePollViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // TODO: Add some variable to collect the tableview values?
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var createPollTableView: UITableView!
    
    var optionsArray: [String] = []
    var optionNumber = 0
    weak var delegate: CreatePollViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        createPollTableView.delegate = self
        createPollTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        
        
        
        //TODO: Set the tapGesture here:
        
        
        
        //TODO: Register your MessageCell.xib file here:
        createPollTableView.register(UINib(nibName: "CreatePollCell", bundle: nil), forCellReuseIdentifier: "CustomCreatePollCell")
        
    }
    
    //MARK: - TableView DataSource Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //TODO: Declare cellForRowAtIndexPath here: triggered when the table view looks to find something to display
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCreatePollCell", for: indexPath) as! CustomCreatePollCell
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    //TODO: Declare tableViewTapped here:
    
    
    
    //TODO: Declare configureTableView here:
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        //TODO: Send the poll options and package the message
        self.delegate?.newPollCreated(pollOptions: optionsArray)
        self.dismiss()
    }
  

}
