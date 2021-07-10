//
//  Session4 An Example.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

///``` Problem: We have list of orders
/// Wee need to set discount for each order based on specific rules
/// Any order may have more than one rule
/// For example order has expiration date in this month or order more than 1000$
/// If order has more than 3 rules then sort it and take first 3 rules then discount will be the average of these 3 rules

/*
 • Calculate Discount for list of orders
 • Each order has only one product
 • There aare servral rules to calculate discount
 • An order should qualify to criteria in order for its associated rule to apply
 • Sevral rules may qualify to same order
 • This discount is the average of the lowest three discounts
 • The system should allow adding other rules and qualifying criteria in the future without much difficulty
 **/
class OrderDiscountWithRules {
    
    static var orderList: [Order] = []
    
    
    static func getOrderWithDiscount(order: Order, rules: [(qualificaionCondition: (Order) -> Bool, getDiscount: (Order) -> Double)] ) -> Order {
        
        let orderDiscountList =  rules.filter { $0.qualificaionCondition(order) }.map { $0.getDiscount(order) }.sorted().prefix(3)
        let discount = orderDiscountList.reduce(0, +) / Double(orderDiscountList.count)
        var newOrder = Order(order: order) // This is not the best solution cause of immutability
        newOrder.discount = discount // We violate immutability
        return newOrder
    }
    
    func getDiscountRules() -> [(qualifyingCondition: (Order) -> Bool, getDiscount: (Order) -> Double)] {
        
        return [(isAQualified, ruleADiscount),
                (isBQualified, ruleBDiscount),
                (isCQualified, ruleCDiscount)]
    }
    
    
    func isAQualified(order: Order) -> Bool {
        return true
    }
    
    func ruleADiscount(order: Order) -> Double {
        return 1.0;
    }
    
    func isBQualified(order: Order) -> Bool {
        return true
    }
    
    func ruleBDiscount(order: Order) -> Double {
        return 1.0;
    }
    func isCQualified(order: Order) -> Bool {
        return true
    }
    
    func ruleCDiscount(order: Order) -> Double {
        return 1.0;
    }
    
    /// ``` NOTE: If we need to add another rule just need to add two methods such as isRuleQualified(order: Order) and ruleDiscount(order: Order) to get the discount for this new rule

}

struct Order {
    
    init(order: Order) {
        self = order
    }
    var discount: Double
}

