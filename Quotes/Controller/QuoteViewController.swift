//
//  QuoteViewController.swift
//  Quotes
//
//  Created by Junior Silva on 01/01/23.
//

import UIKit
import Combine

class QuoteViewController: UIViewController {

    private let viewModel = QuoteViewModel()
    
    private let quoteView: QuoteView = {
        let view = QuoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let input: PassthroughSubject<QuoteViewModel.Input, Never> = .init()
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        setupView()
        bind()
    }
    
    private func setupView() {
        view.addSubview(quoteView)
        
        NSLayoutConstraint.activate([
            quoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            quoteView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            quoteView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            quoteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            switch event {
            case .fetchQuoteFail(let error):
                self?.quoteView.quoteLabel.text = error.localizedDescription
            case .fetchQuoteSuccess(let quote):
                self?.quoteView.quoteLabel.text = "\(quote.content)\n\n- \(quote.author)"
            }
        }.store(in: &cancellable)
    }
    
    @objc private func didTapRefreshButton() {
        input.send(.didTapRefreshButton)
    }
}
