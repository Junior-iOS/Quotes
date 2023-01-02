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
    }
    
    private let quoteServiceType: QuoteServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    init(quoteServiceType: QuoteServiceType = QuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .didTapRefreshButton:
                self?.handleFetchRandomQuote()
            }
        }.store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleFetchRandomQuote() {
        quoteServiceType.getRandomQuote(.init(endpoint: .random), expecting: Quote.self).sink { error in
            if case .failure(let error) = error {
                self.output.send(.fetchQuoteFail(error: error))
            }
        } receiveValue: { quote in
            self.output.send(.fetchQuoteSuccess(quote: quote))
        }.store(in: &cancellable)
    }
}
