//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by 김경호 on 2017. 3. 5..
//  Copyright © 2017년 kyungh kim. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentOfURL = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentOfURL {
                            self.tweetImage.image = UIImage(data: imageData as Data)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}
