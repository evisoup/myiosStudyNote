//
//  demoCell.swift
//  Table&Login
//
//  Created by 刘恒邑 on 2017/5/29.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//

import UIKit

class demoCell: UITableViewCell {

    @IBOutlet weak var lotName: UILabel!
    @IBOutlet weak var details: UILabel!
    
    
    
    var parkingLot: ParkingLot? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let lot = parkingLot else {
            lotName.text = "GG"
            details.text = "GG TOO"
            return
        }
        
        lotName.text = lot.name
        details.text = lot.details
        
        //need to fix about photo
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
