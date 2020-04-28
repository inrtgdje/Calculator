//
//  ContentView.swift
//  Calculator
//
//  Created by 汤天明 on 2020/4/27.
//  Copyright © 2020 汤天明. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private  var brain: CalculatorBrain = .left("0")
    var body: some View {
        VStack(alignment: .trailing, spacing: 18) {
            Spacer()
            Text(brain.output).font(.system(size: 78))
                .minimumScaleFactor(0.5)
                .padding(.trailing,20)
            .lineLimit(1)
                .frame(minWidth:0,maxWidth: .infinity,alignment: .trailing)
           
            CalcultorButtonPad(brain: $brain)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            
            ContentView()
         
        }
    }
}

struct CalculatorButton: View {
    let font: Font = .system(size: 38)
    let title:String
    let size:CGSize
    let foreground:Color
    let background:Color
    let action: () ->Void
  
    var body: some View {
        Button.init(action: action) {
            
            Text(title)
                .font(font)
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(background)
                .cornerRadius(size.width/2)
        }
    }
}

struct CalculatorButtonRow: View {
    @Binding var brain:CalculatorBrain
    let row:[CalculatorButtonItem]
    var body: some View {
        HStack(){
            
            ForEach(row,id: \.self){  item in
                
                CalculatorButton(title: item.title, size: item.size,foreground: .white, background: Color.init(item.colorName)){
                    self.brain = self.brain.apply(item: item)
                }
                
            }
        }
    }
}


struct CalcultorButtonPad: View {
    @Binding var brain:CalculatorBrain
    let pad:[[CalculatorButtonItem]] = [
    [.command(.clear), .command(.flip),
    .command(.percent), .op(.divide)],
    [.digit(7), .digit(8), .digit(9), .op(.multiply)],
    [.digit(4), .digit(5), .digit(6), .op(.minus)],
    [.digit(1), .digit(2), .digit(3), .op(.add)],
    [.digit(0), .dot, .op(.equal)]
    ]

   
    var body: some View {
        VStack(spacing:8){
            ForEach(pad,id: \.self){
                row in
                CalculatorButtonRow(brain: self.$brain, row: row)
            }
        }
    }
    
    
}
