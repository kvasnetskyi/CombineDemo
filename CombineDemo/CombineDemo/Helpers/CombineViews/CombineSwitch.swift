//
//  CombineSwitch.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import UIKit
import Combine

class CombineSwitch: UISwitch {

    private(set) lazy var statePublisher = stateSubject.eraseToAnyPublisher()
    private let stateSubject = PassthroughSubject<Bool, Never>()

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(stateChanged(_:)), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func stateChanged(_ sender: UISwitch) {
        stateSubject.send(sender.isOn)
    }
}
