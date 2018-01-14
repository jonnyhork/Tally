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
    
    func addOption(toPoll optionText: String) -> Poll {
        // force optiontext lowercase
        var listCopy = list
        listCopy[optionText.lowercased()] = Set<String>()
        return Poll(list: listCopy)
    }
    
    func addVote(to optionText: String, by userName: String) -> Poll {
        // force optionText loewer case
        var listCopy = list
        listCopy[optionText.lowercased()]?.insert(userName)
        return Poll(list: listCopy)
    }
    
    func removeVote(from optionText: String, by userName: String) -> Poll {
        var listCopy = list
        listCopy[optionText.lowercased()]?.remove(userName)
        return Poll(list: listCopy)
    }
    
    func count(votes optionText: String) -> Int {
        return (list[optionText.lowercased()]?.count) ?? 0
    }
}

//extension Poll: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let currentlySelected = self.currentlySelectedOption {
//            currentlySelectedOption = indexPath.row
//        }
//    }
//}

