//
//  Session2.swift
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
class PipelineConcept {
    
    static let data: [Double] = [7, 4, 5, 6, 3, 8, 10]
    
    static func doImparativeCode() {
        
        data.forEach { item in
            print(subtractTen(square(addOne(item))))
        }
    }
    
    static func doDeclarativeCode() {
        print( data.map { addOne($0) }.map { square($0) }.map{ subtractTen($0) } )
    }
    
    
    // MARK: - Handlers
    
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

PipelineConcept.doImparativeCode()
PipelineConcept.doDeclarativeCode()

/*
 At this state it's okay for both codes
 But hang on a minute, if for example in the future
 We get a change request that is we need for example values will arrive to step 3 should only value greater than 20
 
 At this case the editing in declarative code will be much easier like that: -
 
 print(data.map { addOne($0) }.map{ square($0) }.filter { $0 > 70}.map{ subtractTen($0) } )
 
 Otherwise it gonna be a bit harder in imparative
*/

