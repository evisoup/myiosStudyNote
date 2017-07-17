//
//  Recent.swift
//  Smashtag
//
//  Created by 김경호 on 2017. 3. 7..
//  Copyright © 2017년 kyungh kim. All rights reserved.
//

import Foundation

struct Recent {
    private static let defaults = UserDefaults()
    
    private struct Constants {
        static let Key = "RecentQueries"
        static let limit = 100
    }
    
    static var queries: [String] {
        return (defaults.object(forKey: Constants.Key) as? [String]) ?? []
    }
    
    static func add(term: String) {
        var newArray = queries // .filter({ term.caseInsensitiveCompare($0) != .orderedSame })
        newArray.insert(term, at: 0)
        while newArray.count > Constants.limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey: Constants.Key)
    }
}

