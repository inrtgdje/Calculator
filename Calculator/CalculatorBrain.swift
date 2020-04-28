//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 汤天明 on 4/28/20.
//  Copyright © 2020 汤天明. All rights reserved.
//

import Foundation




enum CalculatorBrain {
    case left(String)
    case leftOp(left:String,op:CalculatorButtonItem.Op)
    case leftOpRight(left:String,op:CalculatorButtonItem.Op,right:String)
    case error
    
    
    
    var output:String {
        let result:String
        switch self {
            
        case .left(let left):
            result = left
        case .leftOp(left: let left,  _):
            result = left
        case .leftOpRight( _, _, right: let right):
            result = right
        case .error:
            return "Error"
        }
        
        guard let value = Double(result) else { return "Error" }
        
        return formatter.string(from: value as NSNumber)!
    }
    
    @discardableResult
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
 
        switch item {
            
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }

    func apply(num:Int) -> CalculatorBrain {
        switch self {
            
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(left: let left, op: let op):
            return .leftOpRight(left: left, op: op, right: String(num))
        case .leftOpRight(left: let left, op: let op, right: let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
        
    }
    
    func applyDot() ->CalculatorBrain{
        
        switch  self {
            
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(left: let left, op: let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(left: let left, op: let op, right: let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
        
    }
    
    
    func apply(op:CalculatorButtonItem.Op) -> CalculatorBrain {
        
        switch self {
            
        case .left(let left):
            switch op {
            case .add, .minus, .multiply,.divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
            
        case .leftOp(left: let left, let currentOp):
             switch op {
               case .add, .minus, .multiply,.divide:
                   return .leftOp(left: left, op: op)
               case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                }
                return .error
                       }
        case .leftOpRight( let left, let currentOp, let right):
            switch op{
            case .add,.minus,.multiply,.divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                }else{
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    
                    return .left(result)
                }
                return .error
                
            }
            
        case .error:
            return self
        }
    }
    
    
    func apply(command:CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
            
        case .clear:
            return .left("0")
        case .flip:
            switch self {
                
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(left: let left, op: let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(left: let left, op: let op, right: let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
                
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(left: let left, op: let op, right: let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
            
        }
       
       
    }
   
}

var formatter:NumberFormatter =  {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    
    var containDot:Bool {
        return contains(".")
    }
    
    var startWithNegative:Bool{
        return starts(with: "-")
    }
    
    func apply(num:Int) ->String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    
    func applyDot() -> String {
        return containDot ? self : "\(self)."
    }
    
    
    func flipped() ->String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
            
        }else{
            return "-\(self)"
        }
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}


extension  CalculatorButtonItem.Op {
    
    func calculate(l: String, r: String) -> String? {
        guard let left  = Double(l),let right = Double(r) else { return nil }
        let result: Double?
        switch self {
            
        case .add:
            result = left + right
        case .minus:
            result = left - right
        case .multiply:
            result = left * right
        case .divide:
            result =  right == 0 ? nil : left / right
        case .equal:
            
            fatalError()
        }
        
        return result.map { String($0)
        }
    }
}



