//
//  Session7 Closures.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

func testClosure(number: Double) -> (Double) -> Double {

   
    let x1 = number + 10
    
    // the returned function is NOT pure cause it depends on x1
    // It takes some states from another scope
    
    return {
        return x1 + $0
    }
}

// funcTesa10 is the result of closing over x1 (10)
let funcTest10 = testClosure(number: 10)
print(funcTest10(4)) // print 24 - > 10 + 10 + 4

 
let funcTest20 = testClosure(number: 20)
print(funcTest20(4)) // print 34 - > 20 + 10 + 4

// x1 is out of scope of returned function
// if we call testClosure so x1 must be exist
// when return our function then x1 will be with the new returned function

/// ``` SO we can say that : -
/// - Closure is encapsulation of FP
/// - CClosure is a function with state
/// - Closure is a function factory like funcTest10 and funcTest20
/// - Closures an object with a single function for example we can say we made object that has x1 and we set it equal 10
