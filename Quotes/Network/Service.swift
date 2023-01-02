//
//  Service.swift
//  Quotes
//
//  Created by Junior Silva on 01/01/23.
//

import Foundation
import Combine

protocol QuoteServiceType {
    func getRandomQuote<T: Codable>(_ request: QuoteRequest, expecting type: T.Type) -> AnyPublisher<Quote, Error>
}

final class QuoteService: QuoteServiceType {
    func getRandomQuote<T: Codable>(_ request: QuoteRequest, expecting type: T.Type) -> AnyPublisher<Quote, Error> {
//        guard let url = URL(string: "https://api.quotable.io/random") else { fatalError("Unsupported") }
        guard let url = request.url else { fatalError("Could not find URL") }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = request.httpMethod
        
        return URLSession.shared.dataTaskPublisher(for: url).catch { error in
            return Fail(error: error).eraseToAnyPublisher()
        }.map({ $0.data })
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

final class Service {
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedParsingData
    }
    
    static let shared = Service()
    
    private init(){}
    
    public func execute<T: Codable>(_ request: QuoteRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(ServiceError.failedParsingData))
            }
        }.resume()
    }
}
