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
    
    private let conversions : [String: [String: Double]] = ["USD": ["USD": 1.0, "GBP": 0.5, "CAN": 1.25, "EUR": 1.5],
                                                            "GBP": ["USD": 2.0, "GBP": 1.0, "CAN": 1.74, "EUR": 1.14],
                                                            "EUR": ["USD": 2/3, "GBP": 0.88, "CAN": 1.53, "EUR": 1.0],
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
    
    public func convert(_ to: String) -> Money {
        verifyCurrency(to)
        let factor : Double = conversions[self.currency]![to]!
        let temp : Money = Money(amount: Int(Double(self.amount) * factor), currency: to)
        return temp
    }
    
    public func add(_ to: Money) -> Money {
        verifyCurrency(to.currency)
        let temp : Money = convert(to.currency)
        return Money(amount: to.amount + temp.amount, currency: to.currency)
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
        switch self.type {
        case .Hourly(let rate) :
            return Int(Double(hours) * rate)
        case .Salary(let amount) :
            return Int(amount)
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let rate) :
            self.type = JobType.Hourly(amt + rate)
        case .Salary(let salary) :
            self.type = JobType.Salary(salary + Int(amt))
        }
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
        get {
            return self._job
        }
        set(value) {
            if self.age > 16 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return self._spouse
        }
        set(value) {
            if self.age > 18 {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.title ?? "nil") spouse:\(self.spouse?.firstName ?? "nil")]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members.count > 0 && (members[0].age > 21 || members[1].age > 21) {
            members.append(child)
            return true
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var householdIncome : Int = 0
        for person in members {
            if person.age >= 16 && person.job != nil {
                let salary = person.job!.calculateIncome(2000)
                householdIncome += salary
            }
        }
        return householdIncome
    }
}





