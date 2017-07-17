//
//  GraphView.swift
//  Calculator
//
//  Created by 김경호 on 2017. 5. 13..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import UIKit

protocol graphViewDataSource {
    func getBounds() -> CGRect
    func getYCoordinate(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    @IBInspectable
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    private let axesDrawer = AxesDrawer(color: UIColor.black)
    var dataSource: graphViewDataSource?
    
    func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        guard let data = dataSource else {
            return path
        }
        
        var pathIsEmpty = true
        var point = CGPoint()
        
        let width = Int(bounds.size.width * scale)
        for pixel in 0...width {
            point.x = CGFloat(pixel) / scale
            
            if let y = data.getYCoordinate(x: (point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    pathIsEmpty = true
                    continue
                }
                
                point.y = origin.y - y * scale
                
                if pathIsEmpty {
                    path.move(to: point)
                    pathIsEmpty = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
        
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        axesDrawer.drawAxes(in: dataSource?.getBounds() ?? bounds, origin: origin, pointsPerUnit: scale)
        pathForFunction().stroke()
    }
    
    func pinchZoom(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func move(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }
    
    func doubleTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            origin = recognizer.location(in: self)
        default:
            break
        }
    }
}
