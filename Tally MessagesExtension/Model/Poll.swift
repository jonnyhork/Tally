//
//  Poll.swift
//  Tally
//
//  Created by Jonny Hork on 1/9/18.
//  Copyright © 2018 G62-Jonny Hork. All rights reserved.
//

import UIKit

struct Poll {
    // list is a dictionary with option title as keys, a set<String> as values, representing votes
    let list : [String:Set<String>]
    var title: String? = nil
    
    func addOption(toPoll optionText: String) -> Poll {
        var listCopy = list
        listCopy[optionText] = Set<String>()
        return Poll(list: listCopy, title: title)
    }
    
    func addVote(to optionText: String, by userName: String) -> Poll {
        var listCopy = list
        listCopy[optionText]?.insert(userName)
        return Poll(list: listCopy, title: title)
    }
    
    func removeVote(from optionText: String, by userName: String) -> Poll {
        var listCopy = list
        listCopy[optionText]?.remove(userName)
        return Poll(list: listCopy, title: title)
    }
    
    func count(votes optionText: String) -> Int {
        return (list[optionText]?.count) ?? 0
    }
    
}


