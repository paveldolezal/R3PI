//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import XCTest
@testable import R3PI

class CurrencyConvertorTest: XCTestCase {
    
    func testConversion() {
        let convertor = CurrencyConvertor(quotes: ["CZK": 21.91])
        
        let targetCurrencyPrice = convertor.convert(price: 4, to: "CZK")
        XCTAssertEqual(87.64, targetCurrencyPrice, accuracy: 0.00001)
    }
}
