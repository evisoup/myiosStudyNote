//
//  ViewController.swift
//  Calculator
//
//  Created by 김경호 on 2017. 4. 3..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
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
        displayValue = 0.0
        descriptionLabel.text = " "
        userIsInTheMiddleOfTyping = false
        brain.clear()
    }
    
    @IBAction private func backspace() {
        let textCurrentlyInDisplay = display.text!
        if textCurrentlyInDisplay != "0" && textCurrentlyInDisplay.characters.count != 1 {
            display.text = textCurrentlyInDisplay.substring(to: textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex))
        } else {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        }
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
        if let result = brain.calculatorResult {
            displayValue = result
        }
        descriptionLabel.text = brain.descriptionResult
    }
}

