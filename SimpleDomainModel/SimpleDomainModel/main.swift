//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    /*
        0: USD
        1: GBP
        2: CAN
        3: EUR
    */
    private let conversions : [String: [String: Double]] = ["USD": ["USD": 1.0, "GBP": 0.5, "CAN": 1.25, "EUR": 1.5],
                                                            "GBP": ["USD": 2.0, "GBP": 1.0, "CAN": 1.74, "EUR": 1.14],
                                                            "EUR": ["USD":1.24, "GBP": 0.88, "CAN": 1.53, "EUR": 1.0],
                                                            "CAN": ["USD":0.81, "GBP": 0.58, "CAN": 1.0, "EUR": 0.65]
                                                   ]
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        verifyCurrency(currency)
    }
    
    func verifyCurrency(_ to: String) {
        let currencies = ["USD", "GBP", "EUR", "CAN"]
        assert(currencies.contains(to))
    }
    
    // TODO: Check if we can change the method header
    public func convert(_ to: String) -> Money {
        verifyCurrency(to)
        let factor : Double = conversions[self.currency]![to]!
        let temp : Money = Money(amount: Int(Double(self.amount) * factor), currency: to)
        return temp
    }
    
    public func add(_ to: Money) -> Money {
        verifyCurrency(to.currency)
        let temp: Money = to.convert(self.currency)
        return Money(amount: self.amount + temp.amount, currency: self.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        verifyCurrency(from.currency)
        let temp: Money = from.convert(self.currency)
        return Money(amount: temp.amount - self.amount, currency: self.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
    }
    
    open func raise(_ amt : Double) {
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { }
        set(value) {
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { }
        set(value) {
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
    }
    
    open func haveChild(_ child: Person) -> Bool {
    }
    
    open func householdIncome() -> Int {
    }
}





