//
//  TwitterCell.swift
//  twitterPrototype
//
//  Created by 刘恒邑 on 2017/5/14.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//
import UIKit
import Twitter

class TwitterCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!    
    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let tweet = tweet else {
            tweeter.text = nil
            tweetText.text = nil
            creationDate.text = nil
            profilePhoto.image = nil
            return
        }
        
       
        tweeter?.text = tweet.user.description
        tweetText?.text = tweet.text
        
        let formatter = DateFormatter()
        if Date().timeIntervalSince(tweet.created) > 24*60*60 {
            formatter.dateStyle = .short
        }
        else {
            formatter.timeStyle = .short
        }
        creationDate?.text = formatter.string(from: tweet.created)
        
        //profile pic blocks main thread
        if let imgUrl = tweet.user.profileImageURL, let data = try? Data(contentsOf: imgUrl) {
             profilePhoto?.image = UIImage(data: data)
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
