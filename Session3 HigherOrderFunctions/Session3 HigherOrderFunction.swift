//
//  Session3 HigherOrderFunction.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

/// Sample to demonstrate higher order function invokation, delegate function invokation and normal function invokation
///
class HigherOrderFunction {
    
    static let dlgtTest1 = test1
    static let dlgtTest2 = test2
    
    static let dlgtList: [(Double) -> Double] = [dlgtTest1, dlgtTest2]
    
    static func doDemoExample() {
        
        // This is a normal method invokation
        // For example the first one, compiler see test 1 as double
        // This is not a higher order function invokation
        print(test2(test1(5)))
        print(test1(test2(5)))
        
        // This is a delegate invokation
        // We use list to get the delegate to get the function
        // This is not a higher order function
        print(dlgtList[0](5))
        print(dlgtList[1](5))
        
        // This is a higher order function invokation
        // we pass a function to a function
        print(test3(func: test1(_:), input: 5))
        print(test3(func: test2(_:), input: 5))
    }
    
    
    // MARK: - Handlers
    
    static func test1(_ input: Double) -> Double {
        return input / 2
    }
    
    static func test2(_ input: Double) -> Double {
        return input / 4 + 1
    }
    
    // MARK: - Higher order function
    
    static func test3(func: (Double) -> Double, input: Double) -> Double {
        
        return `func`(input) + input
    }
}

HigherOrderFunction.doDemoExample()
