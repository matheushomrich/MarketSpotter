//
//  MarketList.swift
//  TerminalChallenge
//
//  Created by Matheus Homrich on 16/03/21.
//

import Foundation

class MarketList {
    var id: Int
    var name: String
    var list: [Product]
    var date: Date
    
    init(id: Int, name: String, list: [Product], date: Date) {
        self.id = id
        self.name = name
        self.list = list
        self.date = date
    }
    
    func addProduct(product: Product) {
        
        list.append(product)
    }
    
    func removeProduct(id: Int) {
        var nameAux: String = ""
        
        for (i, product) in list.enumerated() {
            if product.id == id {
                nameAux = product.name
                list.remove(at: i)
            }
        }

        print("\(nameAux) was SUCCESSFULLY removed from \(name)")
    }
    
    func showList() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        print("Name: \(name) | Date: \(formatter.string(from: date))")
        print("\nProducts:")
        for product in list {
            print(product.toString())
        }
    }
    
    func showFinalPrice() -> Double {
        var finalPrice: Double = 0
        var aux: Double = 0
        
        for product in list {
            aux = 0
            
            if product.quantity ?? 1 > 1 {
                aux = Double(product.quantity ?? 1) * (product.price ?? 0)
            } else {
                aux = (product.price ?? 0)
        }
            
            finalPrice += aux
        }
        
        return finalPrice
    }
    
    func showProductPrice(id: Int) {
        for product in list {
            if product.id == id {
                print(product.toString())
            }
        }
    }
    
    func showProductName(id: Int) -> String {
        var result: String = ""
        for product in list {
            if product.id == id {
                result = product.name
            }
        }
        return result
    }
    
    func emptyList() {
        list.removeAll()
    }
    
    func toString() -> String {
        var productsList: String = ""
        
        for product in list {
            productsList += "\n\(product.toString())"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        return "Id: \(id) | Name: \(name) | Date: \(formatter.string(from: date)) | \nProducts: \(productsList) "
    }
    
}
