//
//  SignUpViewModel.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import Foundation
import Combine

class SignUpViewModel {

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var emailError: String?
    @Published var passwordError: String?

    @Published var isInputValid: Bool = false
    @Published var isOTPNeeded: Bool = false

    @Published var isLoading: Bool = false

    @Published private var isEmailValid: Bool = false
    @Published private var isPasswordValid: Bool = false

    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private(set) lazy var errorMessagePublisher = errorMessageSubject.eraseToAnyPublisher()

    private let otpNeededSubject = PassthroughSubject<Void, Never>()
    private(set) lazy var otpNeededPublisher = otpNeededSubject.eraseToAnyPublisher()

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthServiceImpl()) {
        self.authService = authService
        
        setup()
    }

    func setup() {

        $email
            .dropFirst()
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { isValidEmail($0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)

        $password
            .dropFirst()
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count > 6 }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        $isEmailValid
            .combineLatest($isPasswordValid)
            .map { (isEmailValid, isPasswordValid) -> Bool in
                return isEmailValid && isPasswordValid
            }
//            .map { $0 && $1 }
            .assign(to: \.isInputValid, on: self)
            .store(in: &cancellables)

        $isEmailValid
            .dropFirst()
            .map { $0 ? nil : "Email is invalid" }
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)

        $isPasswordValid
            .dropFirst()
            .map { $0 ? nil : "Password is invalid" }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
    }

    func signUp() {
        isLoading = true
        authService.signUp(email: email, password: password)
            .sink { [unowned self] completion in
                isLoading = false
                switch completion {
                case let .failure(error): errorMessageSubject.send(error.localizedDescription)
                default: break
                }
            } receiveValue: { [unowned self] success in
                if success { otpNeededSubject.send() }
            }
            .store(in: &cancellables)
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
