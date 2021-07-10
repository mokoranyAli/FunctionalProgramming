//
//  Session6 Example.swift
//  
//
//  Created by Mohamed Korany on 7/10/21.
//

import Foundation

/// A system is to be developed to calculate the cost of shipping and order,
/// Proecess goes as follows, the `Order` is used to construct tow documents.
/// This first is an `Invoice`, the second document is an `Availabilty` document that states which
/// Warehouses can provide the products required when would it be available,
/// The invoice document is used to construct the `Shipping` document stating the Shipper
/// Who would make the shipment, and that document is used to calculate the `Freight` cost,
/// The availabilty documenton the other hand is used to calculate
/// The `Shipping Date` at which all products are aggregated at single warehouse and
/// Ready for shipping to customer. The freight cost is `Adjust`with those dates to
/// Calculate the corrected cost because some modifications may be required for
/// Certain days of the week or other circumstances that may induce heavy road traffic
/// Each step in that process have different implementations and the one used is determind
/// Based on configuration of each customer
///
///
/// ```
/// The system should be designed to facilitate adding steps or other
/// Implementation of steps in the process with minimal change to the codebase
///
class Program {
    static func doExample() {
        let invoicePath =  InvoicingPath()
        let availabilityPath = AvailabilityPath()
        let configuration = setConfiguration()
        
        let costOfOrder = calcAdjustedCostofOrder(c: configuration.processConfiguration, invoicePath: invoicePath, availabilityPath: availabilityPath)
        
        print(costOfOrder(configuration.order));
    }
    
    //Setup of the Process Configuration and Data
    public static func setConfiguration() -> (order: Order, processConfiguration: ProcessConfiguration) {
        
        let customer = Customer()
        let order = Order(customer: customer, date: Date(), cost: 2000)
        
        let processConfiguration =  ProcessConfiguration(invoiceChoice: .inv3, shippingChoice: .sh2, freightChoice: .fr3, availabilityChoice: .av2, shippingDateChoice: .sd2)
        return (order, processConfiguration);
    }
    
    //Adjusted Cost for Order
    public static func calcAdjustedCostofOrder(c: ProcessConfiguration, invoicePath: InvoicingPath , availabilityPath: AvailabilityPath) -> (Order) -> Double {
        return {
            adjustCost(r: $0, calcFreigt: invoicePathFunc(c: c, fpl: invoicePath), calcShippingDate: availabilityPathFunc(c: c, spl: availabilityPath))
        }
    }
    
    //Adjusted Cost
    public static func adjustCost(r: Order, calcFreigt: (Order) -> Freight , calcShippingDate: (Order) -> ShippingDate) -> Double {
        
        let f = calcFreigt(r)
        let s = calcShippingDate(r);
        print("\n\nDay of Shipping :  \(s.date) ")
        let components = Calendar.current.dateComponents([.weekday], from: s.date)
        let cost = components.weekday == 2 ? f.cost + 1000 : f.cost + 500 // if today is monday or not
        
        ///Finall Cost
        return cost
    }
    
    /// Return InvoicePath Composed Function
    public static func invoicePathFunc(c: ProcessConfiguration, fpl: InvoicingPath) -> (Order) -> Freight {
        
        guard let calcInvoice = fpl.invoiceFunctions.filter({ $0.invoiceChoice == c.invoiceChoice }).map({ $0.calcInvoice }).first,
              let calcShipping = fpl.shippingFunctions.filter({ $0.shippingChoose == c.shippingChoice }).map({ $0.calcShipping }).first,
              let calcFrieght = fpl.frieghtFunctions.filter({ $0.freightChoose == c.freightChoice }).map({ $0.calcFrieght }).first else { fatalError() }
        
        let freightFromOrder = compose(func1: calcInvoice, func2: compose(func1: calcShipping, func2: calcFrieght))
        
        return freightFromOrder
    }
    
    ///  Return AvailabilityPath Composed Funcrtion
    public static func availabilityPathFunc(c: ProcessConfiguration, spl: AvailabilityPath) ->  (Order) -> ShippingDate {
        guard let availabilty = spl.availabilityFunctions.filter({ $0.availabilityChoose == c.availabilityChoice }).map({ $0.calcAvailability }).first ,
              let shipping = spl.shippingDateFunctions.filter({ $0.shippingDateChoose == c.shippingDateChoice }).map({ $0.calcShippingDate }).first else { fatalError() }
        let shippingDate = compose(func1: availabilty, func2: shipping)
        
        
        return shippingDate
    }
}

// Compose Function

/// This is a compsition process that behave forwarding
/// T1 + T2 ---> T3
/// T3 + Anything ---> Something new
///
func compose<T1, T2, T3>(func1: @escaping (T1) -> T2, func2: @escaping ((T2) -> T3)) -> (T1) -> T3 {
    return { x in
        return func2(func1(x))
    }
}

public class InvoicingPath {
    let invoiceFunctions: [(invoiceChoice: InvoiceChoice, calcInvoice: (Order) -> Invoice)]
    let shippingFunctions: [(shippingChoose: ShippingChoice, calcShipping: (Invoice) -> Shipping)]
    let frieghtFunctions: [(freightChoose: FreightChoice, calcFrieght: (Shipping) -> Freight)]
    
    public init() {
        invoiceFunctions = [
            (.inv1,calcInvoice1),
            (.inv2,calcInvoice2),
            (.inv3,calcInvoice3),
            (.inv4,calcInvoice4),
            (.inv5,calcInvoice5)]
        
        frieghtFunctions = [
            (.fr1,calcFreightCost1),
            (.fr2,calcFreightCost2),
            (.fr3,calcFreightCost3),
            (.fr4,calcFreightCost4),
            (.fr5,calcFreightCost5),
            (.fr6,calcFreightCost6)
        ]
        
        shippingFunctions = [
            (.sh1,calcShipping1),
            (.sh2,calcShipping2),
            (.sh3,calcShipping3)
        ]
    }
}

public class AvailabilityPath {
    
    var availabilityFunctions: [(availabilityChoose: AvailabilityChoice, calcAvailability: (Order) -> Availability)]
    var shippingDateFunctions: [(shippingDateChoose: ShippingDateChoice, calcShippingDate: (Availability) -> ShippingDate)]
    
    public init ()
    {
        availabilityFunctions = [(.av1,calcAvailability1),
                                 (.av2,calcAvailability2),
                                 (.av3,calcAvailability3),
                                 (.av4,calcAvailability4)]
        
        shippingDateFunctions = [(.sd1,calcShippingDate1),
                                 (.sd2,calcShippingDate2),
                                 (.sd3,calcShippingDate3),
                                 (.sd4,calcShippingDate4),
                                 (.sd5,calcShippingDate5),]
    }
}

func calcInvoice1(order: Order) -> Invoice {
    print("Invoice 1");
    var invoice = Invoice()
    invoice.cost = order.cost * 1.2
    return invoice;
}
func calcInvoice2(order: Order) -> Invoice {
    print("Invoice 2");
    var invoice = Invoice()
    invoice.cost = order.cost * 1.2
    return invoice;
}
func calcInvoice3(order: Order) -> Invoice {
    print("Invoice 3");
    var invoice = Invoice()
    invoice.cost = order.cost * 1.3
    return invoice;
}
func calcInvoice4(order: Order) -> Invoice {
    print("Invoice 4");
    var invoice = Invoice()
    invoice.cost = order.cost * 1.4
    return invoice;
}
func calcInvoice5(order: Order) -> Invoice {
    print("Invoice 5");
    var invoice = Invoice()
    invoice.cost = order.cost * 1.5
    return invoice;
}

func calcShipping1(invoice: Invoice) -> Shipping {
    print("Shipping 1");
    let shippingID = invoice.cost > 1000 ? 1 : 2
    let shipping = Shipping(cost: invoice.cost, shipperID: shippingID)
    return shipping
}

func calcShipping2(invoice: Invoice) -> Shipping {
    print("Shipping 2");
    let shippingID = invoice.cost > 1100 ? 1 : 2
    let shipping = Shipping(cost: invoice.cost, shipperID: shippingID)
    return shipping
}
func calcShipping3(invoice: Invoice) -> Shipping {
    print("Shipping 3");
    let shippingID = invoice.cost > 1200 ? 1 : 2
    let shipping = Shipping(cost: invoice.cost, shipperID: shippingID)
    return shipping
}

func calcFreightCost1(s: Shipping) -> Freight {
    print("Freight 1");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.25 : s.cost * 0.5;
    return f
}
func calcFreightCost2(s: Shipping) -> Freight {
    
    print("Freight 2");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.28 : s.cost * 0.52;
    return f
}
func calcFreightCost3(s: Shipping) -> Freight {
    
    print("Freight 3");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.3 : s.cost * 0.6;
    return f
}
func calcFreightCost4(s: Shipping) -> Freight {
    
    print("Freight 4");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.35 : s.cost * 0.65;
    return f
}
func calcFreightCost5(s: Shipping) -> Freight {
    
    print("Freight 5");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.15 : s.cost * 0.2;
    return f
}
func calcFreightCost6(s: Shipping) -> Freight {
    
    print("Freight 6");
    var f = Freight()
    f.cost = s.shipperID == 1 ? s.cost * 0.1 : s.cost * 0.15;
    return f
}

func calcAvailability1(o: Order) -> Availability {
    print("Availability 1")
    let date = o.date.addDays(3)
    let a = Availability(date: date)
    return a
}
func calcAvailability2(o: Order) -> Availability {
    print("Availability 2")
    let date = o.date.addDays(2)
    let a = Availability(date: date)
    return a
}
func calcAvailability3(o: Order) -> Availability {
    print("Availability 3")
    let date = o.date.addDays(1)
    let a = Availability(date: date)
    return a
}
func calcAvailability4(o: Order) -> Availability {
    print("Availability 4")
    let date = o.date.addDays(4)
    let a = Availability(date: date)
    return a
}

func calcShippingDate1(availability: Availability) -> ShippingDate {
    print("ShippingDate 1");
    let date = availability.date.addDays(1);
    let shippingDate = ShippingDate(date: date)
    return shippingDate
}
func calcShippingDate2(availability: Availability) -> ShippingDate {
    print("ShippingDate 2");
    let date = availability.date.addDays(2);
    let shippingDate = ShippingDate(date: date)
    return shippingDate
}
func calcShippingDate3(availability: Availability) -> ShippingDate {
    print("ShippingDate 3");
    let date = availability.date.addDays(14);
    let shippingDate = ShippingDate(date: date)
    return shippingDate
}
func calcShippingDate4(availability: Availability) -> ShippingDate {
    print("ShippingDate 4");
    let date = availability.date.addDays(20);
    let shippingDate = ShippingDate(date: date)
    return shippingDate
}
func calcShippingDate5(availability: Availability) -> ShippingDate {
    print("ShippingDate 5");
    let date = availability.date.addDays(10);
    let shippingDate = ShippingDate(date: date)
    return shippingDate
}


public class ProcessConfiguration {
    internal init(invoiceChoice: InvoiceChoice,
                  shippingChoice: ShippingChoice,
                  freightChoice: FreightChoice,
                  availabilityChoice: AvailabilityChoice,
                  shippingDateChoice: ShippingDateChoice) {
        self.invoiceChoice = invoiceChoice
        self.shippingChoice = shippingChoice
        self.freightChoice = freightChoice
        self.availabilityChoice = availabilityChoice
        self.shippingDateChoice = shippingDateChoice
    }
    
    let invoiceChoice: InvoiceChoice
    let shippingChoice: ShippingChoice
    let freightChoice: FreightChoice
    let availabilityChoice: AvailabilityChoice
    let shippingDateChoice: ShippingDateChoice
    
}


public struct Customer {
    
}
public struct Order {
    let customer: Customer
    let date: Date
    let cost: Double
}
public struct Invoice {
    var cost: Double
    public init() {
        cost = 0
    }
}
public struct Shipping {
    
    let cost: Double
    let shipperID: Int
}
public struct Freight {
    
    var cost: Double
    
    init() {
        cost = 0
    }
}
public struct Availability {
    let date: Date
}

public struct ShippingDate {
    let date: Date
}

public enum InvoiceChoice: Int {
    case inv1 = 0
    case inv2 = 1
    case inv3 = 2
    case inv4 = 3
    case inv5 = 4
}

public enum FreightChoice {
    case fr1
    case fr2
    case fr3
    case fr4
    case fr5
    case fr6
}
public enum AvailabilityChoice {
    case av1
    case av2
    case av3
    case av4
}
public enum ShippingDateChoice {
    case sd1
    case sd2
    case sd3
    case sd4
    case sd5
}
public enum ShippingChoice {
    case sh1
    case sh2
    case sh3
}

private extension Date {
    
    func addDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

Program.doExample()
