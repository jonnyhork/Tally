//
//  MessagesViewController.swift
//  Tally MessagesExtension
//
//  Created by Jonny Hork on 1/8/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit
import Messages
import ChameleonFramework

class MessagesViewController: MSMessagesAppViewController, CompactViewControllerDelegate, CreatePollViewControllerDelegate, votingViewControllerDelegate {
    

    var session: MSSession?
    var currentConversation: MSConversation?
    var poll = Poll()
    
    // MARK: - Message Construction
/////////////////////////////////////////////////////////////////////

    func prepareURL() -> URL {
        
        var components = URLComponents()

        components.queryItems = poll.list.map { option in
            URLQueryItem(name: option.key , value: option.value.joined(separator: ","))
        }
        
        return components.url!
    }
    
    func decodeURL(with url: URL) {
    
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("There are no components in the message")
        }
        
        for choice in components.queryItems! {
            poll.addOption(toPoll: choice.name)
            
            choice.value?.split(separator: ",").forEach { voter in
                poll.addVote(to: choice.name, by: String(voter))
            }
        }
        dump(poll, name: "Sate of Poll in decodeURL", indent: 2)
    }
    
    func prepareMessage(with url: URL) {
        
        if let conversation: MSConversation = activeConversation {
            
            if session == nil {
                session = MSSession()
            }
            
            let layout = MSMessageTemplateLayout()
                layout.caption = "Test IM App!"
                layout.subcaption = "Go Jonny"
            
            let message = MSMessage(session: session!)
                message.layout = layout
                message.url = url
            
            conversation.insert(message, completionHandler: { (error: NSError?) in
                print(error!)
                } as? (Error?) -> Void)
        }
    }
    
    
    //  MARK: - Delegate Methods
/////////////////////////////////////////////////////////////////////
    
    // CompactVC delegate method
    func didPressCreatePoll() {
        requestPresentationStyle(.expanded)
    }
    
    // CreatePollVC delegate method
    func newPollCreated(pollOptions: [String]) {
        // build up the poll obj with the choices passed in
        for option in pollOptions {
            poll.addOption(toPoll: option)
        }
        let url = prepareURL()
        prepareMessage(with: url)
        dump(poll, name: "Sate of Poll in newPollCreated", indent: 2)
    }
    
    func addVoteToPoll(with: String) {
        let currentUser = activeConversation?.localParticipantIdentifier.uuidString
        
        print("The \(currentUser) wants to vote on \(with)")
    }
    
 
    // MARK: - View Controller Selection
/////////////////////////////////////////////////////////////////////

    func presentViewController(for conversation: MSConversation, for presentationStyle: MSMessagesAppPresentationStyle) {
        
        var controller: UIViewController!
        
        // Display the correct view controller
        if presentationStyle == .compact {
            controller = instantiateCompactVC()
        } else if (conversation.selectedMessage != nil) && presentationStyle == .expanded {
            controller = instantiateVotingVC(with: poll)
        } else {
            controller = instantiateCreatePollVC()
        }
        
        // remove any existing controllers
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        addChildViewController(controller)
        
        // constraints and view setup
        controller.view.frame = self.view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
   


    // MARK: - Instantiate VC Methods
    // Methods for instantiating a specific View Controller
/////////////////////////////////////////////////////////////////////

    private func instantiateCompactVC() -> UIViewController {
        guard let compactVC = self.storyboard?.instantiateViewController(withIdentifier: "CompactViewController") as? CompactViewController else {
            fatalError("Can't instantiate CompactViewController")
        }
        compactVC.delegate = self
        return compactVC
    }
    
    private func instantiateCreatePollVC() -> UIViewController {
        guard let createPollVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollViewController") as? CreatePollViewController else {
            fatalError("Can'instantiate CreatePollViewController")
        }
        createPollVC.delegate = self
        return createPollVC
    }
    
    private func instantiateVotingVC(with: Poll) -> UIViewController {
        guard let votingVC = self.storyboard?.instantiateViewController(withIdentifier: "VotingViewController") as? VotingViewController else {
            fatalError("Can'instantiate VotingViewController")
        }
            votingVC.delegate = self
            votingVC.poll = poll
            votingVC.currentConversation = activeConversation // TODO: currentconversation might be nil at this point
        
        /*
         this is worth's do code to handle adding a vote. 
        votingVC.voteAction = { [weak self] newPoll in
            // do thing with poll
        }
        */
        return votingVC
    }
    
    // MARK: - ViewDidLoad
/////////////////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
/////////////////////////////////////////////////////////////////////

    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        if let messageURL = conversation.selectedMessage?.url {
            decodeURL(with: messageURL)
            session = conversation.selectedMessage?.session
        }
       presentViewController(for: conversation, for: self.presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        guard let conversation = self.activeConversation else {
            fatalError("No conversation found")
        }
        
        presentViewController(for: conversation, for: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
