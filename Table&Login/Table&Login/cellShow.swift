//
//  cellShow.swift
//  Table&Login
//
//  Created by 刘恒邑 on 2017/5/29.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//

import UIKit

class cellShow: UIViewController {

    
    
    
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var detailsLable: UILabel!
    
    var name: String?
    var details: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLable.text = name
        detailsLable.text = details
    }


}
