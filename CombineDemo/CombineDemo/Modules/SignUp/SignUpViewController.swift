//
//  SignUpViewController.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    private let viewModel: SignUpViewModel

    private let didFinishSubject = PassthroughSubject<Void, Never>()
    lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()

    private var cancellables = Set<AnyCancellable>()

    private let emailTextField = UITextField()
    private let emailErrorLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordErrorLabel = UILabel()
    private let signUpButton = CombineButton()

    private let loadingView = UIView()

    init(viewModel: SignUpViewModel = SignUpViewModel()) {
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
        setupBindings()
    }

    private func setupBindings() {
        emailTextField.textPublisher
//            .sink { [unowned self] in viewModel.email = $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        signUpButton.tapPublisher
            .sink { [unowned self] in viewModel.signUp() }
            .store(in: &cancellables)

        viewModel.$emailError
            .assign(to: \.text, on: emailErrorLabel)
            .store(in: &cancellables)

        viewModel.$passwordError
            .assign(to: \.text, on: passwordErrorLabel)
            .store(in: &cancellables)

        viewModel.$isInputValid
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellables)

        viewModel.$isLoading
            .map { !$0 }
            .assign(to: \.isHidden, on: loadingView)
            .store(in: &cancellables)

        viewModel.errorMessagePublisher
            .sink { [unowned self] in showErrorAlert(errorMessage: $0) }
            .store(in: &cancellables)

        viewModel.otpNeededPublisher
            .sink { [unowned self] in
                let otpVC = SignUpOTPViewController()
                otpVC.didFinish
                    .subscribe(didFinishSubject)
                    .store(in: &cancellables)
                present(otpVC, animated: true, completion: nil)
            }
            .store(in: &cancellables)

    }

    private func setupUI() {
        view.backgroundColor = .white

        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none

        emailErrorLabel.textColor = .red
        emailErrorLabel.font = .systemFont(ofSize: 14)

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect

        passwordErrorLabel.textColor = .red
        passwordErrorLabel.font = .systemFont(ofSize: 14)

        signUpButton.backgroundColor = .blue
        signUpButton.rounded(16)
        signUpButton.setTitle("Sign Up", for: .normal)

        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    private func setupLayout() {
        let emailStackView = UIStackView(arrangedSubviews: [emailTextField, emailErrorLabel])
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailStackView.axis = .vertical
        emailStackView.alignment = .fill
        emailStackView.distribution = .fill
        emailStackView.spacing = 8

        let passwordStackView = UIStackView(arrangedSubviews: [passwordTextField, passwordErrorLabel])
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordStackView.axis = .vertical
        passwordStackView.alignment = .fill
        passwordStackView.distribution = .fill
        passwordStackView.spacing = 8

        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16

        view.addSubview(stackView, constraints: [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])

        view.addSubview(signUpButton, constraints: [
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        loadingView.addSubviewToCenter(activityIndicator)
        view.addSubview(loadingView, withEdgeInsets: .zero)
    }
}

import SwiftUI
struct SignUpViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SignUpViewController().view)
    }
}
