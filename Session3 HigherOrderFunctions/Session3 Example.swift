//
//  Session3.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

struct Order {
    let orderID: Int
    let productIndex: Int
    let quantity: Double
    let unitPrice: Double
}

enum ProductType {
    case food
    case beverage
    case rawMatrial
}


///``` Problem: We need to calculate discount for product
/// Discount depends on 2 parameters
/// Those parameters depend on product type
///
class DiscountHandler {
  
    static var product: ProductType = .food
    private static var foodParams = productParameterFood
    private static var beverageParams = productParameterBeverage
    private static var rawMaterialParams = productParametersRawMatrials
    private static var order = Order(orderID: 10, productIndex: 100, quantity: 20, unitPrice: 4)
    
    static var parametersHandler: (Int) -> (param1: Double, param2: Double) = product == .food ? foodParams : product == .beverage ? beverageParams : rawMaterialParams
    
    static func doDiscount() {
        print(calculateDiscount(calculalteProductParameter: parametersHandler, order: order))
    }
    
    // MARK: - Handlers
    
    static func calculateDiscount(calculalteProductParameter: (_ productIndex: Int) -> (param1: Double, param2: Double), order: Order) -> Double {
        let parameters = calculalteProductParameter(order.productIndex)
        return parameters.param1 * order.quantity + parameters.param2 * order.unitPrice
    }
    
    static func productParametersRawMatrials(productIndex: Int) -> (Double, Double) {
        
        return (Double(productIndex) / Double((productIndex + 400)), Double(productIndex) /  Double((productIndex + 700)))
    }
    
    static func productParameterBeverage(productIndex: Int) -> (Double, Double) {
        return (Double(productIndex) / Double((productIndex + 300)), Double(productIndex) /  Double((productIndex + 400)))
    }
    
    static func productParameterFood(productIndex: Int) -> (Double, Double) {
        return (Double(productIndex) / Double((productIndex + 100)), Double(productIndex) /  Double((productIndex + 300)))
    }
}

// Here we apply discount with FP
// We achived Purity principle in FP
// Every function dosn't read or write in the enviroment
// This is just a sequenece of functions performed in a specific way to get our needs
DiscountHandler.doDiscount()

