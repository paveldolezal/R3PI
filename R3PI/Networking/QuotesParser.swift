//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

class QuotesParser {
    class func parse(json: Data, baseCurrency: String) throws -> Quotes {
        let quotesResponse = try JSONDecoder().decode(QuotesResponse.self, from: json)
        return quotesResponse.cleanQuotes(base: baseCurrency)
    }
}


fileprivate struct QuotesResponse: Codable {
    var quotes: Quotes
    
    func cleanQuotes(base: String) -> Quotes {
        var result = Quotes()
        
        for k in quotes.keys {
            let sanitizedKey = String(k[base.endIndex...])
            result[sanitizedKey] = quotes[k]
        }
        
        return result
    }
}
