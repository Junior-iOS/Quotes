//
//  QuoteViewModel.swift
//  Quotes
//
//  Created by Junior Silva on 02/01/23.
//

import Foundation
import Combine

final class QuoteViewModel {
    
    enum Input {
        case viewDidAppear
        case didTapRefreshButton
    }
    
    enum Output {
        case fetchQuoteFail(error: Error)
        case fetchQuoteSuccess(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }
    
    private let quoteServiceType: QuoteServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    
    init(quoteServiceType: QuoteServiceType = QuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return output.eraseToAnyPublisher()
    }
}
