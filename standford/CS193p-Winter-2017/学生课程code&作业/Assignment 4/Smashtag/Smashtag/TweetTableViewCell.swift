//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by 김경호 on 2017. 5. 15..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        tweetTextLabel?.attributedText = getColorfulTextLabel(tweet)
        tweetUserLabel?.text = tweet?.user.description
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private struct Color {
        static let userMention = UIColor.orange
        static let hashtag = UIColor.blue
        static let url = UIColor.brown
        
    }
    
    private func getColorfulTextLabel(_ tweet: Twitter.Tweet?) -> NSAttributedString? {
        if let tweet = tweet {
            let attributedText = NSMutableAttributedString(string: tweet.text)
            for userMention in tweet.userMentions {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.userMention, range: userMention.nsrange)
            }
            for hashtag in tweet.hashtags {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.hashtag, range: hashtag.nsrange)
            }
            for url in tweet.urls {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.url, range: url.nsrange)
            }
            return attributedText
        }
        return nil
    }
}
