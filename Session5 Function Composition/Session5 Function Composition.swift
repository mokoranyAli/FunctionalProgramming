//
//  Session5 Function Composition.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

///``` Problem: We have list of doubles and we need specific result with specific steps on each element
/// First Step need to add one
/// Second step need to square the number for rsult from step 1
/// Final step need to sub 10 from the result from step 2
///

/// Wee need to make it with function composition
///
class FunctionComposition {
    
    static let data: [Double] = [3, 5, 7, 8]
    
    static func doFunctionCompostion() {
        
        // Here we use FP but we need to reduce maps
        print( data.map { addOne($0) }.map { square($0) }.map { subtractTen($0) } )
        
        // Here we reduced maps but we need to compose calling functions in one funtion
        print(data.map { subtractTen(square(addOne($0))) } )
        
        // Here we make a composite funtion to make one function behave rather than 3 ones but this is only take double and return double .. we neet it generic
        let myDomposeFunctionWithDouble = composeFunctionWithDouble(f1: addOne, f2: square, f3: subtractTen)
        print(data.map { myDomposeFunctionWithDouble($0) } )
        
        // Here we are
        print(data.map { addOneSquareSubtractTen()($0) } )
    }
    
    
    
    static func composeFunctionWithDouble(f1: @escaping (Double) -> Double,
                                          f2: @escaping (Double) -> Double,
                                          f3: @escaping(Double) -> Double) -> (Double) -> Double {
        return { x in
           return f3(f2(f1(x)))
        }
    }
    
    /// This is a compsition process that behave forwarding
    /// T1 + T2 ---> T3
    /// T3 + Anything ---> Something new
    ///
    static func compose<T1, T2, T3>(func1: @escaping (T1) -> T2, func2: @escaping ((T2) -> T3)) -> (T1) -> T3 {
        return { x in
         return func2(func1(x))
        }
    }
    
    static func addOneSquareSubtractTen() -> (Double) -> Double {
        let q1 = addOne
        let q2 = square
        let q3 = subtractTen
        
        let result = compose(func1: compose(func1: q1, func2: q2), func2: q3)
        return result
    }
    
    static func addOne(_ input: Double) -> Double {
        return input + 1
    }
    
    static func square(_ input: Double) -> Double {
        return input * input
    }
    
    static func subtractTen(_ input: Double) -> Double {
        return input - 10
    }
}

FunctionComposition.doFunctionCompostion()


/// FRF -> function returns function
class FRFExample {
    static func doFRF() {
        let myFunc = test()
        
        print(myFunc(4))
    }
    
    static func test() -> (Double) -> Double {
        return { $0 + 1 }
    }
}

FRFExample.doFRF() // should return func return 5
