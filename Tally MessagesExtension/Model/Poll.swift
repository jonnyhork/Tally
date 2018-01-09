//
//  Poll.swift
//  Tally
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import Foundation

class Poll {
    // list is a dictionary with option title as keys, a set<String> as values, representing votes
    var list = [String:Set<String>]()
    
    func addOption(toPoll optionText: String) {
        // force optiontext lowercase
        list[optionText.lowercased()] = Set<String>()
    }
    
    func addVote(to optionText: String, by userName: String) {
        // force optionText loewer case
        list[optionText.lowercased()]?.insert(userName)
    }
    
    func removeVote(from optionText: String, by userName: String) {
        list[optionText.lowercased()]?.remove(userName)
    }
    
    func count(votes optionText: String) -> Int {
        return (list[optionText.lowercased()]?.count) ?? 0
    }
}
