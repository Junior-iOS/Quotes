//
//  QuoteRequest.swift
//  Quotes
//
//  Created by Junior Silva on 01/01/23.
//

import Foundation

final class QuoteRequest {
    private let endpoint: Endpoint
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    private struct Constants {
        static let baseUrl = "https://api.quotable.io"
    }
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
}
