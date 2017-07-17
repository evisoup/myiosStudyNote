//
//  GraphViewController.swift
//  Calculator
//
//  Created by 김경호 on 2017. 5. 13..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, graphViewDataSource {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.pinchZoom(recognizer:))))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.move(recognizer:))))
            let recognizer = UITapGestureRecognizer(target: graphView, action: #selector(graphView.doubleTap(recognizer:)))
            recognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(recognizer)
        }
    }
    
    func getBounds() ->CGRect {
        return navigationController?.view.bounds ?? view.bounds
    }
    
    func getYCoordinate(x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        return nil
    }
    
    var function: ((CGFloat) -> Double)?
}
