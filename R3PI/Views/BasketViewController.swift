//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var spinnerView: UIActivityIndicatorView!
    @IBOutlet var currencyPickerView: UIPickerView!
    
    var presenter: BasketPresenter!
    
    var products = [ProductModel]() {
        didSet { tableView.reloadData() }
    }
    
    var currencies = [CurrencySymbol]() {
        didSet {
            currencyPickerView.reloadAllComponents()
            currencyPickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = BasketPresenter(view: self)
    }
    
    @IBAction func checkout() {
        presenter.checkout()
    }
}


extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.model = products[indexPath.row]
        cell.delegate = self
        return cell
    }
}


extension BasketViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = currencies[row]
        presenter.select(currency: currency)
    }
}


extension BasketViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
}


extension BasketViewController: ProductCellDelegate {
    func productCellDidIncrement(_ cell: ProductCell) {
        presenter.increment(model: cell.model!)
    }
    
    func productCellDidDecrement(_ cell: ProductCell) {
        presenter.decrement(model: cell.model!)
    }
}


extension BasketViewController: BasketViewProtocol {
    
    func updateList(products: [ProductModel]) {
        self.products = products
    }
    
    func updateCurrencies(symbols: [CurrencySymbol]) {
        currencies = symbols
    }
    
    func setCheckoutButton(enabled: Bool) {
        checkoutButton.isEnabled = enabled
    }
    
    func setSpinner(visible: Bool) {
        if visible {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
    
    func setPrice(visible: Bool) {
        priceLabel.isHidden = !visible
        currencyPickerView.isHidden = !visible
    }
    
    func setPrice(_ price: String) {
        priceLabel.text = price
    }
}
