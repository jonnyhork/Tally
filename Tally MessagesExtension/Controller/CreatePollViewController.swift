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
    func newPollCreated(currentPoll: Poll)
}

class CreatePollViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var createPollTableView: UITableView!
    
    
    var optionCount = 2
    var bottomTextField: UITextField?
    var poll: Poll!
    
    weak var delegate: CreatePollViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        createPollTableView.delegate = self
        createPollTableView.dataSource = self
        
        
        //TODO: Register your MessageCell.xib file here:
        createPollTableView.register(UINib(nibName: "CreatePollCell", bundle: nil), forCellReuseIdentifier: "CustomCreatePollCell")
        
    }
    
    //MARK: - TableView DataSource Methods
/////////////////////////////////////////////////////////////////////

    // Declare cellForRowAtIndexPath here: Triggered when the table view looks to find something to display
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCreatePollCell", for: indexPath) as! CustomCreatePollCell
        
//        cell.optionTextField.layer.cornerRadius = 7.0
        
        cell.optionTextField.delegate = self
        cell.selectionStyle = .none
        cell.optionTextField.placeholder = "Option \(createPollTableView.visibleCells.count + 1)"
        bottomTextField = cell.optionTextField
        
        return cell
    }
    
    // Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCount
    }

    func addNewCell() {
        createPollTableView.beginUpdates()
        optionCount += 1
        createPollTableView.insertRows(at: [IndexPath(row: createPollTableView.visibleCells.count, section: 0)], with: .top)
        createPollTableView.endUpdates()
    }
/////////////////////////////////////////////////////////////////////
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        // Send the poll options and package the message
        for cell in createPollTableView.visibleCells  {
            guard let myCell = cell as? CustomCreatePollCell else {continue}
            
            // if the textfield is empty then don't add it to the poll
            if let optionText = myCell.optionTextField.text, optionText.isEmpty == false {
                poll = poll.addOption(toPoll: optionText)
            }
        }
        self.delegate?.newPollCreated(currentPoll: poll)
        self.dismiss()
    }
  
} // end of class

//MARK: - TextField Delegate Methods
extension CreatePollViewController: UITextFieldDelegate {
    
    // build up poll in real time?
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.text
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bottomTextField?.becomeFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        textField.backgroundColor = .lightGray
        if textField === bottomTextField, textField.text?.isEmpty == true {
            bottomTextField = nil
            addNewCell()
        }
        return true
    }
}
