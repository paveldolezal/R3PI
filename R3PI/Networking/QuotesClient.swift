//
//  Created by Pavel Dolezal on 11/11/2017.
//  Copyright © 2017 Pavel Dolezal. All rights reserved.
//

import Foundation

class QuotesClient {
    
    private let resultQueue: DispatchQueue
    private let accessKey: String
    
    init(resultQueue: DispatchQueue, accessKey: String) {
        self.resultQueue = resultQueue
        self.accessKey = accessKey
    }
    
    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
    
    func fetchQuotes(base: String, completion: @escaping (Result<Quotes>) -> Void) {
        let accessKeyItem = URLQueryItem(name: "access_key", value: accessKey)
        let sourceItem = URLQueryItem(name: "source", value: base)
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "apilayer.net"
        components.path = "/api/live"
        components.queryItems = [accessKeyItem, sourceItem]
        
        session.dataTask(with: components.url!) { [unowned self] (data, response, error) in
            
            self.resultQueue.async {
                guard let _ = response, let data = data else {
                    completion(.error)
                    return
                }
                
                do {
                    let quotes = try QuotesParser.parse(json: data, baseCurrency: base)
                    completion(.data(quotes))
                } catch {
                    completion(.error)
                }
            }
            
        }.resume()
    }
}


enum Result<T> {
    case data(T)
    case error
}
