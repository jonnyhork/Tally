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


protocol CreatePollViewControllerDelegate {
    func newPollCreated(pollOptions: [UITextField])
}

class CreatePollViewController: MSMessagesAppViewController {
    
    var optionsArray: [UITextField] = []
    let xPos: CGFloat = 50
    var yPos: CGFloat = 20
    var optionNumber = 0
    var delegate: CreatePollViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTextField()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.delegate?.newPollCreated(pollOptions: optionsArray)
    }
  
    
    @IBAction func addOptionButtonPressed(_ sender: UIButton) {
        createTextField()
    }
    
    func createTextField () {
        optionNumber += 1
        let textField = UITextField()
        yPos += 40
        textField.frame = CGRect(x: xPos, y: yPos, width: 210, height: 30)
        textField.backgroundColor = UIColor.flatWhite()
        textField.borderStyle = UITextBorderStyle.line
        textField.placeholder = "Option \(optionNumber)"
        
        optionsArray.append(textField)
        
        self.view.addSubview(textField)
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
