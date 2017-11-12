//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

enum Product {
    case Peas
    case Eggs
    case Milk
    case Beans
    
    var price: Double {
        switch self {
        case .Peas: return 0.95
        case .Eggs: return 2.1
        case .Milk: return 1.3
        case .Beans: return 0.73
        }
    }
}

