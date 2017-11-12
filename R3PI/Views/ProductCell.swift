//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import UIKit

protocol ProductCellDelegate: class {
    func productCellDidIncrement(_ cell: ProductCell)
    func productCellDidDecrement(_ cell: ProductCell)
}


class ProductCell: UITableViewCell {
    
    @IBOutlet var decrementButton: UIButton!
    @IBOutlet var incrementButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var model: ProductModel? {
        didSet {
            guard let model = model else { return }
            decrementButton.isEnabled = model.canDecrement
            incrementButton.isEnabled = model.canIncrement
            titleLabel.text = model.title
        }
    }
    
    weak var delegate: ProductCellDelegate?
    
    @IBAction func decrement() {
        delegate?.productCellDidDecrement(self)
    }
    
    @IBAction func increment() {
        delegate?.productCellDidIncrement(self)
    }
    
}
