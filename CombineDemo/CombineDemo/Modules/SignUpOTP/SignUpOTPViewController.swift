//
//  SignUpOTPViewController.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import UIKit
import Combine

class SignUpOTPViewController: UIViewController {

    let viewModel: SignUpOTPViewModel

    private let otpCodeTextField = UITextField()
    private let sendButton = CombineButton()
    private let resendButton = CombineButton()

    lazy var didFinish = viewModel.didFinishPublisher

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SignUpOTPViewModel = SignUpOTPViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otpCodeTextField.becomeFirstResponder()
    }

    private func bind() {
        otpCodeTextField.textPublisher
            .assign(to: \.otpCode, on: viewModel)
            .store(in: &cancellables)

        viewModel.$isOTPFormatValid
            .assign(to: \.isEnabled, on: sendButton)
            .store(in: &cancellables)

        viewModel.$isResendButtonAvailable
            .assign(to: \.isEnabled, on: resendButton)
            .store(in: &cancellables)

        viewModel.$resendButtonText
            .sink { [unowned self] text in resendButton.setTitle(text, for: .normal) }
            .store(in: &cancellables)

        resendButton.tapPublisher
            .sink { [unowned self] in viewModel.resend() }
            .store(in: &cancellables)

        sendButton.tapPublisher
            .sink { [unowned self] in viewModel.send() }
            .store(in: &cancellables)
    }

    private func setupUI() {
        view.backgroundColor = .white

        otpCodeTextField.textAlignment = .center
        otpCodeTextField.keyboardType = .numberPad
        otpCodeTextField.font = .systemFont(ofSize: 32, weight: .bold)

        sendButton.backgroundColor = .blue
        sendButton.rounded(16)
        sendButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        sendButton.setTitle("Send", for: .normal)

        resendButton.setTitle("Resend code", for: .normal)
        resendButton.setTitleColor(.blue, for: .normal)
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [otpCodeTextField, sendButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])

        view.addSubview(resendButton, constraints: [
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ])
    }

}


import SwiftUI
struct SignUpOTPViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SignUpOTPViewController().view)
    }
}
