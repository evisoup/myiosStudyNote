//
//  RecentTableViewController.swift
//  Smashtag
//
//  Created by 김경호 on 2017. 3. 7..
//  Copyright © 2017년 kyungh kim. All rights reserved.
//

import UIKit

class RecentTableViewController: UITableViewController {
    
    // MARK: - Model
    
    var recentQueries: [String] {
        return Recent.queries
    }
    
    private struct Storyboard {
        static let RecentCell = "Recent Cell"
        static let TweetsSegue = "Show Recent"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentQueries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.RecentCell, for: indexPath)
        cell.textLabel?.text = recentQueries[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Storyboard.TweetsSegue {
            if let ttvc = segue.destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    ttvc.searchText = cell.textLabel?.text
                }
            }
        }
    }
}
