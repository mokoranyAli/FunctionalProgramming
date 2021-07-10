//
//  Session7 Example.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

/// ``` Problem is
/// ``` We wanna calculate empoloyees salaries in a company
/// employee divided in 3 categories
/// basic salary is 1000, 2000 or 3000 based on category
/// Tax is constant 0.2 of basic salary
/// bonus is changing for each employee

class SalaryCalculator {
    
    static let segmenWithBasicSalaryList = [("a", 1000), ("b", 2000), ("c", 3000)]
    
    static func doExample() {
        let grossSalaryCalculators = segmenWithBasicSalaryList.map { return (segment: $0.0, calculator: grossSalaryCalculator(basicSalary: Double($0.1))) }
        print(grossSalaryCalculators[0].calculator(80))
        print(grossSalaryCalculators[1].calculator(90))
        print(grossSalaryCalculators.filter { $0.segment == "c"}.first!.calculator(100))
    }
    
    static func grossSalaryCalculator(basicSalary: Double) -> (Double) -> Double {
        
        // we set tax here to send just basic salary
        // we have some state here to reduce number of parameters
        let tax = 0.2 * basicSalary
        return { bouns in
            // We are closing over tax here
            return bouns + tax + basicSalary
        }
    }
}


SalaryCalculator.doExample()


// If we didn't do that
// Then we should send basic salary everytime for each category
// so we reduce number of parameters
