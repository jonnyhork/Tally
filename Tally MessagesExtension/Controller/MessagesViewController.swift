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

enum AppState {
    case voting(Poll)
    case createPoll(Poll)
    case canCreatePoll(Poll?)
    case unknown
}

class MessagesViewController: MSMessagesAppViewController, CompactViewControllerDelegate, CreatePollViewControllerDelegate, votingViewControllerDelegate {
    


    var session: MSSession?
    var currentVote: String?
    var pollTitle: String? 
    var appState = AppState.unknown

    
    // MARK: - Message Construction
/////////////////////////////////////////////////////////////////////

    func prepareURL(from poll: Poll) -> URL {
        
        var components = URLComponents()

        components.queryItems = poll.list.map { option in
            URLQueryItem(name: option.key , value: option.value.joined(separator: ","))
        }
        
        components.queryItems?.append(URLQueryItem(name: "USER_TITLE", value: pollTitle))
        
        return components.url!
    }
    
    func decodeURL(with url: URL) -> Poll {
        var poll = Poll(list: [:], title: nil)
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("There are no components in the message")
        }
        
        for choice in components.queryItems! {
            if choice.name == "USER_TITLE" {
                poll.title = choice.value
            } else {
                poll = poll.addOption(toPoll: choice.name)
                
                choice.value?.split(separator: ",").forEach { voter in
                    poll = poll.addVote(to: choice.name, by: String(voter))
                }
            }
        }
        
        dump(poll, name: "SATE OF POLL IN DecodeURL\n", indent: 2)
        
        return poll
    }
    
    func prepareMessage(with url: URL) {
        
        if let conversation: MSConversation = activeConversation {
            
//            if session == nil {
//                session = MSSession()
//            }
            
            let layout = MSMessageTemplateLayout()
                layout.caption = "What's the Tally?"
                layout.subcaption = pollTitle ?? "make your choice 👆"
//                layout.image = UIImage(named: "tally-logo")
            
            let message = MSMessage() //session: session! add this as an argument
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
    /// state affecting
    func didPressCreatePoll() {
        
        appState = .createPoll(Poll(list: [:], title: nil ))
        requestPresentationStyle(.expanded)
    }
    
    // CreatePollVC delegate method
    /// state affecting
    func newPollCreated(currentPoll: Poll) {
        
        appState = .createPoll(currentPoll)
        pollTitle = currentPoll.title
        let url = prepareURL(from: currentPoll)
        prepareMessage(with: url)
        dump(appState, name: "SATE OF POLL IN NewPollCreated\n", indent: 2)
    }
    
    func sendUpdatedPoll() {
        guard case .voting(let poll) = appState else { return }
        
        newPollCreated(currentPoll: poll)
    }
    
    // MARK: - Update Poll State
///////////////////////////////////////////////////////////////////////
    
    func addVoteToPoll(userChoice: String, instance: VotingViewController) {
        guard case .voting(var poll) = appState else { return }
        
        guard let currentUser = activeConversation?.localParticipantIdentifier.uuidString else { return }
        
        if currentVote != nil {
            poll = poll.removeVote(from: currentVote!, by: currentUser)
        }
        
        poll = poll.addVote(to: userChoice, by: currentUser)
        currentVote = userChoice
        // make sure the only vote one thing, remove the previous vote before added to the new vote
        
        appState = .voting(poll)
        instance.poll = poll
        print("The \(currentUser) wants to vote on \(userChoice)")
    }
    
 
    // MARK: - View Controller Selection
/////////////////////////////////////////////////////////////////////

    var currentlyPresentedVC: UIViewController?
    
    /// Resizes the controller constraints to fit the screen
    fileprivate func addControllerToView(_ controller: UIViewController) {
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
    
    func presentViewController(for conversation: MSConversation, for presentationStyle: MSMessagesAppPresentationStyle) {
        
        let controller: UIViewController
        
        switch presentationStyle {
        case .compact:
            controller = instantiateCompactVC()
        case .expanded:
            switch appState {
            case .voting(let poll):
                controller = instantiateVotingVC(with: poll)
            case .createPoll(let poll):
                controller = instantiateCreatePollVC(poll: poll)
            case .canCreatePoll:
                controller = instantiateCompactVC()
            case .unknown:
                fatalError("no state")
            }
        default:
            fatalError("unsupported")
        }
        
        // remove any existing controllers
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        addControllerToView(controller)
        currentlyPresentedVC = controller
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
    
    private func instantiateCreatePollVC(poll: Poll) -> UIViewController {
        guard let createPollVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePollViewController") as? CreatePollViewController else {
            fatalError("Can'instantiate CreatePollViewController")
        }
        
        createPollVC.poll = poll
        createPollVC.delegate = self
        return createPollVC
    }
    
    private func instantiateVotingVC(with poll: Poll) -> UIViewController {
        guard let votingVC = self.storyboard?.instantiateViewController(withIdentifier: "VotingViewController") as? VotingViewController else {
            fatalError("Can'instantiate VotingViewController")
        }
            votingVC.delegate = self
            votingVC.poll = poll
        
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
       
        // This is the starting point for a conversation.
        
        if let messageURL = conversation.selectedMessage?.url {
            let votingPoll = decodeURL(with: messageURL)
            appState = .voting(votingPoll)
            session = conversation.selectedMessage?.session
        } else {
            appState = .canCreatePoll(nil)
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
