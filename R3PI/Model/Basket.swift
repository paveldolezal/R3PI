//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

class Basket {
    
    private var products = [Product: Int]()
    
    func add(product: Product) {
        products[product] = number(of: product) + 1
    }
    
    func remove(product: Product) {
        products[product] = max(0, number(of: product) - 1)
    }
    
    func number(of product: Product) -> Int {
        return products[product] ?? 0
    }
    
    var isEmpty: Bool {
        for (_, number) in products {
            if 0 < number {
                return false
            }
        }
        
        return true
    }
    
    var totalPrice: Double {
        return products.reduce(0) { (result, item) in
            return result + item.key.price * Double(item.value)
        }
    }
    
}
