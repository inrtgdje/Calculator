//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by 汤天明 on 2020/4/27.
//  Copyright © 2020 汤天明. All rights reserved.
//

import UIKit

enum CalculatorButtonItem {
    
    enum Op:String {
        case add = "+"
        case minus = "-"
        case multiply = "x"
        case divide  = "÷"
        case equal = "="
    }
    
    
    enum Command:String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
        
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}


extension CalculatorButtonItem {
    
    var title:String {
        switch self {
        case .digit( let value):
            return String(value)
        case .dot:
            return "."
        case .command(let command):
            return command.rawValue
        case .op(let op):
            return op.rawValue
        
        }
    }
    
    var size:CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
      return CGSize(width: 88, height: 88)
    }
    
    var colorName:String{
        switch self {
        
        case .digit(_),.dot:
          return  "Gray"
        case .op(_):
            return  "Orange"
        case .command(_):
          return  "LightGray"
        }
    }
    
}

extension CalculatorButtonItem:Hashable{}
