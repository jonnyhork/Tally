//
//  CompactViewController.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

/*
 This VC will allow the user to tap on create new poll button to view the createPollVC
 
 - stretch goal: show a continue poll button if they started making a poll but transitioned to the compact view
    - protocol creates a method to presentVC with identfier "CreatePollViewController", called in the MessagesVC

 */

import UIKit
import Messages
import ChameleonFramework


protocol CompactViewControllerDelegate: class {
    func didPressCreatePoll()
}

class CompactViewController: MSMessagesAppViewController {

  weak var delegate: CompactViewControllerDelegate?
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func createNewPollButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressCreatePoll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 4.0
        self.view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: self.view.frame, colors: [HexColor("FAFAFA"), HexColor("48C0D3")])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
