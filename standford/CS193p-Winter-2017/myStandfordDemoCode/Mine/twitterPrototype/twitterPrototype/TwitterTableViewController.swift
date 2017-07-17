//
//  TwitterTableViewController.swift
//  twitterPrototype
//
//  Created by 刘恒邑 on 2017/5/14.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//

import UIKit
import Twitter

class TwitterTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBox: UITextField! {
        didSet{
            searchBox.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchBox {
            searchText = searchBox.text
        }
        return true
    }

    private var tweets = Array<Array<Tweet>>()  {   // [[Tweet]]() {
        didSet{
//            print(tweets)
        }
    }
    
    private var oldRequest: Twitter.Request?
    
    public var searchText: String? {
        didSet {
            searchBox.text = searchText
            searchBox.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweet()
            title = searchText
        }
    }
    
    private func searchForTweet() {
        if let request = requestTwitter() {
            oldRequest = request
            request.fetchTweets{ [weak self] (newT) in
                if request == self?.oldRequest {
                    DispatchQueue.main.async {
                        self?.tweets.insert(newT, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    
                }
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        searchText = "#PureMoneyKDC"
    }
    
    private func requestTwitter() -> Twitter.Request? {
        if let text = searchText, !text.isEmpty {
            return Twitter.Request(search: text, count: 50)
        }
        return nil
    }
    
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath)
        
        if let cell = dequeued as? TwitterCell {
            
            cell.tweet = tweets[indexPath.section][indexPath.row]
            
        }
        

        return dequeued
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell at \(indexPath) ")
    }
    
    // MARK: - Seguea
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "cellSegue":
                if let vc = segue.destination as? CellSegueVC,
                    let cell = sender as? TwitterCell,
                    let path = tableView.indexPath(for: cell) {
                    
                    vc.myText = "index path: \(path)"
                }
            default:
                break
            }
        }
    }




}
