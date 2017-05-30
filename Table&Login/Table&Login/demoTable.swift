//
//  demoTable.swift
//  Table&Login
//
//  Created by 刘恒邑 on 2017/5/29.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//

import UIKit

class demoTable: UITableViewController {
    
    var lots = [ParkingLot]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchInfo()
    }
    
    private func fetchInfo() {
        
        let url = URL(string: "https://api.uwaterloo.ca/v2/parking/watpark.json?key=95e206951aff0f6b6093b0a340c3185f")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let result = data else {
                return
            }
            //顺序： dictionary -> array -> dictionary
            
            if let resultDict = try? JSONSerialization.jsonObject(with: result) as? [String: Any] {
                
                 //print(resultDict?.value(forKey: "actors"))
                
                guard let dataDict = resultDict?["data"] as? [Any] else { //resultDict?.value(forKey: "data") as? [Any] else {
                    return
                }
                
                //print(dataDict)
                
                for lot in dataDict.flatMap({ $0 as? [String: Any] }) {
                    if let name = lot["lot_name"] as? String,
                        let cap = lot["capacity"] as? Int,
                        let cnt = lot["current_count"] as? Int,
                        let pct = lot["percent_filled"] as? Int {
                        let detail = String(pct) + "% " + String(cnt)+"/"+String(cap)
                        
//                      two ways: append or insert at head
//                     self?.lots.append(ParkingLot(name: name + String(" at:  + \(self?.lots.count)"), details: detail))
                       self?.lots.insert( ParkingLot(name: name, details: detail), at: 0)
                        
//                      two ways: add individually or reload table
                        
//                        DispatchQueue.main.async {
//                            if let section = self?.lots.count  {
//                                self?.lots.append(ParkingLot(name: name, details: detail))
//                                self?.tableView.insertRows(at: [IndexPath(row: section, section: 0)], with: UITableViewRowAnimation.fade ) //insertSections([section + 1], with: .fade)
//                                
//                            }
//                        }

                    }
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }

                
            }
        }
        
        task.resume()
        
    }
    
    /// MARK:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dequeued = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
        
        if let cell = dequeued as? demoCell {
            cell.parkingLot = lots[indexPath.row]
        }
        
        return dequeued
    }

    @IBAction func refreshTable(_ sender: UIRefreshControl) {
        
        fetchInfo()
    }

    
    /// MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch  id {
            case "cellShow":
                if let cell = sender as? demoCell,
                    let path = tableView.indexPath(for: cell),
                    let destination = segue.destination as? cellShow {
                    
                    destination.details = lots[path.row].details
                    destination.name = lots[path.row].name
                    
                }
            default:
                break
            }
        }
    }

}
