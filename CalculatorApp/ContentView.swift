//
//  ContentView.swift
//  CalculatorApp
//
//  Created by Süleyman Ayyılmaz on 7.01.2024.
//

import SwiftUI
import Foundation

enum Operation {
    case add, subtract, multiply, divide, square, squareRoot, log, none
}

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    case square = "x²"
    case squareRoot = "√"
    case log = "log"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal, .square, .squareRoot, .log:
            return .yellow
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

struct ContentView: View {
    @State private var value = "0"
    @State var runningNumber = 0
    @State private var currentOperation: Operation = .none

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
        [.square, .squareRoot, .log]
    ]

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Text Display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()

                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 20))
                                    .frame(width: buttonWidth(item: item), height: 50)
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
            } else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Int(self.value) ?? 0

                switch self.currentOperation {
                case .add:
                    self.value = "\(runningValue + currentValue)"
                case .subtract:
                    self.value = "\(runningValue - currentValue)"
                case .multiply:
                    self.value = "\(runningValue * currentValue)"
                case .divide:
                    if currentValue != 0 {
                        self.value = "\(runningValue / currentValue)"
                    } else {
                        // Handle division by zero error
                        self.value = "Error"
                    }
                case .none:
                    break
                case .square:
                    self.value = "\(currentValue * currentValue)"
                case .squareRoot:
                    if currentValue >= 0 {
                        self.value = "\(Int(sqrt(Double(currentValue))))"
                    } else {
                        // Handle square root of a negative number error
                        self.value = "Error"
                    }
                case .log:
                    if currentValue > 0 {
                        self.value = "\(log10(Double(currentValue)))"
                    } else {
                        // Handle logarithm of non-positive number error
                        self.value = "Error"
                    }
                }
            }
            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
        case .decimal, .negative, .percent:
            // Handle other special buttons if needed
            break
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            } else {
                self.value += number
            }
        }
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        return item == .zero ? ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2 : (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
