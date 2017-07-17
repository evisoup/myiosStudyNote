//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 김경호 on 2017. 4. 5..
//  Copyright © 2017년 kyungh. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: (calculator: Double?, description: String?)
    
    private var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    private var currentPrecedence = Precedence.high
    
    private enum Precedence: Int {
        case low = 0, high
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, Precedence)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, { "√(\($0))" }),
        "cos" : Operation.unaryOperation(cos, { "cos(\($0))" }),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0 }, { "(\($0))⁻¹" }),
        "x²" : Operation.unaryOperation({ $0 * $0 }, { "(\($0))²" }),
        "±" : Operation.unaryOperation({ -$0 }, { Double($0)! > 0 ? "-\($0)" : "\($0)" }),
        "×" : Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }, Precedence.high),
        "÷" : Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }, Precedence.high),
        "+" : Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }, Precedence.low),
        "-" : Operation.binaryOperation({ $0 - $1 }, { "\($0) - \($1)" }, Precedence.low),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator.calculator = value
                accumulator.description = symbol
            case .unaryOperation(let calculatorFunction, let descriptionFunction):
                if accumulator.calculator != nil && accumulator.description != nil {
                    accumulator.calculator = calculatorFunction(accumulator.calculator!)
                    accumulator.description = descriptionFunction(accumulator.description!)
                }
            case .binaryOperation(let calculaorFunction, let descriptionFunction, let precedence):
                performPendingBinaryOperation()
                if currentPrecedence.rawValue < precedence.rawValue {
                    accumulator.description = "(\(accumulator.description!))"
                }
                currentPrecedence = precedence
                if accumulator.calculator != nil && accumulator.description != nil {
                    pendingBinaryOperation = PendingBinaryOperation(binaryFunction: calculaorFunction, firstOprand: accumulator.calculator!, descriptionFunction: descriptionFunction, firstDescription: accumulator.description!)
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator.calculator != nil {
            accumulator.calculator = pendingBinaryOperation?.performCalculator(with: accumulator.calculator!)
            accumulator.description = pendingBinaryOperation?.performDescription(with: accumulator.description!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let binaryFunction: (Double, Double) -> Double
        let firstOprand: Double
        let descriptionFunction: (String, String)-> String
        let firstDescription: String
        
        func performCalculator(with secondOperand: Double) -> Double {
            return binaryFunction(firstOprand, secondOperand)
        }
        
        func performDescription(with secondDescription: String) -> String {
            return descriptionFunction(firstDescription, secondDescription)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator.calculator = operand
        if operand.truncatingRemainder(dividingBy: 1.0) == 0 {
            accumulator.description = String(Int(operand))
        } else {
            accumulator.description = String(operand)
        }
    }
    
    mutating func clear() {
        accumulator.calculator = nil
        accumulator.description = nil
        pendingBinaryOperation = nil
        currentPrecedence = .high
    }
    
    var calculatorResult: Double? {
        get {
            return accumulator.calculator
        }
    }
    
    var descriptionResult: String? {
        get {
            if resultIsPending {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.firstDescription, pendingBinaryOperation!.firstDescription != accumulator.description ? accumulator.description! : "") + " ..."
            } else {
                return accumulator.description! + " ="
            }
        }
    }
}
