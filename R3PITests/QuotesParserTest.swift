//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import XCTest
@testable import R3PI

class QuotesParserTest: XCTestCase {
    
    func testParsing() {
        let json = """
{
  "success": true,
  "terms": "https://currencylayer.com/terms",
  "privacy": "https://currencylayer.com/privacy",
  "timestamp": 1510417752,
  "source": "USD",
  "quotes": {
    "USDAED": 3.67,
    "USDAFN": 68.55,
    "USDALL": 114,
    "USDAMD": 486.79,
    "USDANG": 1.7803,
    "USDAOA": 165.097,
    "USDARS": 17.4790
  }
}
""".data(using: .utf8)!
        
        guard let quotes = try? QuotesParser.parse(json: json, baseCurrency: "USD") else {
            XCTFail("Could not parse quotes JSON")
            return
        }
        
        XCTAssertEqual(7, quotes.count)
        XCTAssertEqual(68.55, quotes["AFN"])
    }
}

