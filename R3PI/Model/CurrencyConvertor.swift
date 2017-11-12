//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

class CurrencyConvertor {
    
    private let table: Quotes
    
    init(quotes: Quotes) {
        table = quotes
    }
    
    var symbols: [CurrencySymbol] {
        return Array(table.keys)
    }
    
    func convert(price: Double, to targetCurrency: CurrencySymbol) -> Double {
        let rate = table[targetCurrency]!
        
        return price * rate
    }
    
}
