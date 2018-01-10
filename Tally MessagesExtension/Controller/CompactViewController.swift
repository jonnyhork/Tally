//
//  CompactViewController.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit
import Messages

protocol CompactViewControllerDelegate {
    func didShowCreatePoll()
}

class CompactViewController: MSMessagesAppViewController {

    var delegate: CompactViewControllerDelegate?
    
    
    @IBAction func createNewPollButtonPressed(_ sender: UIButton) {
        self.delegate?.didShowCreatePoll()
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
