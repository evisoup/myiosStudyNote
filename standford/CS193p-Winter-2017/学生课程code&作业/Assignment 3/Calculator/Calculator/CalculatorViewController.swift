//
//  ViewController.swift
//  Calculator
//
//  Created by 김경호 on 2017. 4. 3..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if secondaryViewController.contents as? GraphViewController != nil {
                return true
            }
        }
        return false
    }
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var MLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    private func updateUI() {
        displayValue = brain.calculatorResult ?? 0.0
        if brain.descriptionResult! == "  =" {
            descriptionLabel.text = " "
        } else {
            descriptionLabel.text = brain.descriptionResult
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != "." || (textCurrentlyInDisplay.range(of: ".") == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction private func clear() {
        userIsInTheMiddleOfTyping = false
        brain.clear()
        updateUI()
    }
    
    @IBAction private func backspace() {
        let textCurrentlyInDisplay = display.text!
        if userIsInTheMiddleOfTyping {
            if textCurrentlyInDisplay != "0" && textCurrentlyInDisplay.characters.count != 1 {
                display.text = textCurrentlyInDisplay.substring(to: textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex))
            } else {
                display.text = "0"
                userIsInTheMiddleOfTyping = false
            }
        } else {
            brain.undo()
            updateUI()
        }
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        brain.variableValues["M"] = displayValue
        userIsInTheMiddleOfTyping = false
        brain.program = brain.program
        
        if displayValue.truncatingRemainder(dividingBy: 1.0) == 0 {
            MLabel.text = " M " + String(Int(displayValue)) + " "
        } else {
            MLabel.text = " M \(displayValue) "
        }
        updateUI()
    }
    
    @IBAction func getVariable(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        userIsInTheMiddleOfTyping = false
        updateUI()
    }

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if newValue.truncatingRemainder(dividingBy: 1.0) == 0 {
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard !brain.resultIsPending else {
            return
        }
        
        let destinationVC = segue.destination.contents
        
        if let graphVC = destinationVC as? GraphViewController {
            graphVC.navigationItem.title = brain.descriptionResult
            graphVC.function = {
                (x: CGFloat) -> Double in
                self.brain.variableValues["M"] = Double(x)
                self.brain.program = self.brain.program
                return self.brain.calculatorResult!
            }
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

