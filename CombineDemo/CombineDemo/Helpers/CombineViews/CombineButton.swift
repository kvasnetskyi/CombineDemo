//
//  CombineButton.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import UIKit
import Combine

class CombineButton: UIButton {

    override var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1 : 0.5 }
    }

    private(set) lazy var tapPublisher = tapSubject.eraseToAnyPublisher()
    private let tapSubject = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapped() {
        tapSubject.send()
    }
}
