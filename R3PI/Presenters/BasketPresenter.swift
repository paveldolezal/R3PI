//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

protocol BasketViewProtocol {
    func updateList(products: [ProductModel])
    func updateCurrencies(symbols: [CurrencySymbol])
    func setCheckoutButton(enabled: Bool)
    func setSpinner(visible: Bool)
    func setPrice(visible: Bool)
    func setPrice(_ price: String)
}


class BasketPresenter {
    
    private let baseCurrency = "USD"
    
    private var isCheckingOut = false
    
    private let view: BasketViewProtocol
    
    private let basket = Basket()
    private let quotesClient = QuotesClient(resultQueue: DispatchQueue.main, accessKey: Config.currencyLayerAccessKey)
    private var convertor = CurrencyConvertor(quotes: [:])
    
    init(view: BasketViewProtocol) {
        self.view = view
        view.updateList(products: products)
    }
    
    private var products: [ProductModel] {
        return [.Peas, .Eggs, .Milk, .Beans].map { ProductModel(product: $0, count: basket.number(of: $0)) }
    }
    
    private var currencies: [CurrencySymbol] {
        var result = [baseCurrency]
        result.append(contentsOf: convertor.symbols.sorted())
        return result
    }
    
    func increment(model: ProductModel) {
        guard !isCheckingOut else { return }
        
        basket.add(product: model.product)
        view.updateList(products: products)
        view.setPrice(visible: false)
        view.setCheckoutButton(enabled: true)
    }
    
    func decrement(model: ProductModel) {
        guard !isCheckingOut else { return }
        
        basket.remove(product: model.product)
        view.updateList(products: products)
        view.setPrice(visible: false)
        view.setCheckoutButton(enabled: !basket.isEmpty)
    }
    
    func checkout() {
        view.setCheckoutButton(enabled: false)
        view.setPrice(visible: false)
        view.setSpinner(visible: true)
        
        isCheckingOut = true
        
        quotesClient.fetchQuotes(base: baseCurrency) { [unowned self] (result) in
            switch result {
            case .data(let quotes):
                self.convertor = CurrencyConvertor(quotes: quotes)
            case .error:
                self.convertor = CurrencyConvertor(quotes: [:])
            }
            
            self.view.updateCurrencies(symbols: self.currencies)
            self.displayPrice(inCurrency: self.baseCurrency)
            self.view.setPrice(visible: true)
            
            self.view.setCheckoutButton(enabled: true)
            self.view.setSpinner(visible: false)
            
            self.isCheckingOut = false
        }
    }
    
    private lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }()
    
    private func displayPrice(inCurrency symbol: CurrencySymbol) {
        let price = symbol == baseCurrency ? basket.totalPrice : convertor.convert(price: basket.totalPrice, to: symbol)
        let priceString = currencyFormatter.string(from: price as NSNumber)!
        view.setPrice(priceString)
    }
    
    func select(currency: CurrencySymbol) {
        displayPrice(inCurrency: currency)
    }
    
}


struct ProductModel {
    
    let product: Product
    let count: Int
    
    var canDecrement: Bool {
        return count > 0
    }
    
    let canIncrement = true
    
    var title: String {
        switch product {
        case .Peas: return "Bags of Peas: \(count)"
        case .Eggs: return "Dozens of Eggs: \(count)"
        case .Milk: return "Bottles of Milk: \(count)"
        case .Beans: return "Cans of Beans: \(count)"
        }
    }
}
