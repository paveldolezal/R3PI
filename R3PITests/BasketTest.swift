//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import XCTest
@testable import R3PI

class BasketTest: XCTestCase {
    
    var basket: Basket!
    
    override func setUp() {
        super.setUp()
        
        basket = Basket()
    }
    
    func testAddingToBasket() {
        basket.add(product: .Beans)
        basket.add(product: .Eggs)
        basket.add(product: .Eggs)
        basket.add(product: .Milk)
        basket.add(product: .Peas)
        
        XCTAssertEqual(7.18, basket.totalPrice, accuracy: 0.00001)
    }
    
    func testRemovingFromBasket() {
        basket.add(product: .Peas)
        basket.remove(product: .Peas)
        
        XCTAssertEqual(0, basket.totalPrice)
    }
    
    func testRemovingNonExistentItemsFromBasket() {
        basket.remove(product: .Peas)
        
        XCTAssertEqual(0, basket.totalPrice)
    }
    
    func testCountingProducts() {
        basket.add(product: .Beans)
        basket.add(product: .Beans)
        basket.add(product: .Eggs)
        
        XCTAssertEqual(2, basket.number(of: .Beans))
    }
    
    func testEmptyBasket() {
        basket.add(product: .Eggs)
        XCTAssertFalse(basket.isEmpty)
        
        basket.remove(product: .Eggs)
        XCTAssertTrue(basket.isEmpty)
    }
}
