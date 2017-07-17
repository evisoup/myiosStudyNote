//
//  DetailTableViewController.swift
//  Smashtag
//
//  Created by 김경호 on 2017. 3. 5..
//  Copyright © 2017년 kyungh kim. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewController: UITableViewController {

    // MARK: - Model
    
    private var detailDatas = [DetailData]()
    
    private struct DetailData {
        var title: String
        var data: [DetailDataItem]
    }
    
    private enum DetailDataItem {
        case img(NSURL, Double)
        case keyWord(String)
    }

    var tweet: Twitter.Tweet? {
        didSet {
            title = tweet?.user.screenName
            
            if let media = tweet?.media, !media.isEmpty {
                detailDatas.append(DetailData(title: SectionTitle.Images, data: media.map {DetailDataItem.img($0.url as NSURL, $0.aspectRatio)}))
            }
            if let hashtags = tweet?.hashtags, !hashtags.isEmpty {
                detailDatas.append(DetailData(title: SectionTitle.Hashtags, data: hashtags.map {DetailDataItem.keyWord($0.keyword)}))
            }
            if let urls = tweet?.urls, !urls.isEmpty {
                detailDatas.append(DetailData(title: SectionTitle.Urls, data: urls.map {DetailDataItem.keyWord($0.keyword)}))
            }
            if let users = tweet?.userMentions, !users.isEmpty {
                detailDatas.append(DetailData(title: SectionTitle.Users, data: users.map {DetailDataItem.keyWord($0.keyword)}))
            }
        }
    }
    
    private struct Storyboard {
        static let KeywordCellIdentifier = "Keyword Cell"
        static let ImageCellIdentifier = "Image Cell"
        static let KeywordSegue = "Search Keyword"
        static let ImageSegue = "Show Image"
        static let SafariSegue = "Show URL"
    }
    
    private struct SectionTitle {
        static let Images = "Images"
        static let Hashtags = "Hashtags"
        static let Urls = "URLs"
        static let Users = "Users"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return detailDatas.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailDatas[section].data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = detailDatas[indexPath.section].data[indexPath.row]
        switch detail {
        case .img(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ImageCellIdentifier, for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageURL = url
            }
            return cell
        case .keyWord(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.KeywordCellIdentifier, for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let detail = detailDatas[indexPath.section].data[indexPath.row]
        switch detail {
        case .img(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        case .keyWord:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailDatas[section].title
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.KeywordSegue {
                if let ttvc = segue.destination as? TweetTableViewController {
                    if let text = (sender as? UITableViewCell)?.textLabel?.text {
                        ttvc.searchText = text
                    }
                }
            } else if identifier == Storyboard.ImageSegue {
                if let imagevc = segue.destination as? ImageViewController {
                    let url = (sender as? ImageTableViewCell)?.imageURL
                    imagevc.imageURL = url
                    imagevc.title = title
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.KeywordSegue {
            if let cell = sender as? UITableViewCell {
                if let text = cell.textLabel?.text {
                    if text.hasPrefix("http") {
                        let url = NSURL(string: text)
                        UIApplication.shared.open(url as! URL)
                        return false
                    }
                }
            }
        }
        return true
    }
}
