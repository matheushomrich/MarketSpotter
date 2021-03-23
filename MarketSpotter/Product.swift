//
//  Product.swift
//  TerminalChallenge
//
//  Created by Matheus Homrich on 16/03/21.
//

import Foundation

class Product {
    var id: Int
    var name: String
    var price: Double?
    var quantity: Int?
    
    init(id: Int, name: String, price: Double?, quantity: Int?) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    func createProduct(id: Int, name: String, price: Double, quantity: Int) {
        
    }
    
    func toString() -> String {
        return "Name: \(name) | Price: $ \(price ?? 0) | Quantity: \(quantity ?? 1)"
    }
    
    func toStringId() -> String {
        return "Id: \(id) | Name: \(name) | Price: $ \(price ?? 0) | Quantity: \(quantity ?? 1)"
    }
}
