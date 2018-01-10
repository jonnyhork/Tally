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


protocol CompactViewControllerDelegate {
    func didPressCreatePoll()
}

class CompactViewController: MSMessagesAppViewController {

    var delegate: CompactViewControllerDelegate?
    
    
    @IBAction func createNewPollButtonPressed(_ sender: UIButton) {
        self.delegate?.didPressCreatePoll()
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
