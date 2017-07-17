//
//  CellSegueVC.swift
//  twitterPrototype
//
//  Created by 刘恒邑 on 2017/5/29.
//  Copyright © 2017年 Hengyi Liu. All rights reserved.
//

import UIKit

class CellSegueVC: UIViewController {

    var myText: String?
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(myText)
        myLabel.text = myText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
