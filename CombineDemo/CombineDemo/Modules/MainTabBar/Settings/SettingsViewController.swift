//
//  SettingsViewController.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {

    private let viewModel: SettingsViewModel

    private var cancellables = Set<AnyCancellable>()

    private let logoutButton = CombineButton()
    private let largeTitleSwitch = CombineSwitch()

    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    private func bind() {
        viewModel.$isLargeTitles
            .removeDuplicates()
            .sink { [unowned self] in
                largeTitleSwitch.isOn = $0
                navigationController?.navigationBar.prefersLargeTitles = $0
            }.store(in: &cancellables)

        logoutButton.tapPublisher
            .sink { [unowned self] in viewModel.logout() }
            .store(in: &cancellables)

        largeTitleSwitch.statePublisher
            .sink { [unowned self] in
                viewModel.setLargeTitles(isOn: $0)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        view.backgroundColor = .white
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        logoutButton.backgroundColor = .red
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.rounded(16)

        view.addSubview(logoutButton, constraints: [
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        let largeTitleLabel = UILabel()
        largeTitleLabel.text = "Large navbar titles"
        let stack = UIStackView(arrangedSubviews: [largeTitleLabel, largeTitleSwitch])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        view.addSubview(stack, constraints: [
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)

        ])
    }

}

import SwiftUI
struct SettingsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SettingsViewController().view)
    }
}
