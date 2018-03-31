//: Playground - noun: a place where people can play

import UIKit

precedencegroup OrPrecedence {
    higherThan: AdditionPrecedence
    associativity: left
}

infix operator ?? : AdditionPrecedence
infix operator || : OrPrecedence

func || <T>(lhs: T, rhs: T) -> (T,T) {
    return (lhs, rhs)
}

func ?? <T: Equatable>(left: inout T, results: (T,T)) {
    if left == results.0 {
        left = results.1
    } else {
        left = results.0
    }
}

var color = UIColor.lightGray
color = (color == UIColor.lightGray) ? UIColor.white : UIColor.lightGray

color = (color == UIColor.lightGray) ? UIColor.white : UIColor.lightGray

color = (color == UIColor.lightGray) ? UIColor.white : UIColor.lightGray

color ?? (UIColor.lightGray || UIColor.white)

color ?? UIColor.lightGray || UIColor.white
