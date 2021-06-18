//
//  SignUpOTPViewModel.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import Foundation
import Combine

class SignUpOTPViewModel {

    @Published var otpCode: String = ""
    @Published var isOTPFormatValid: Bool = false
    @Published var isResendButtonAvailable: Bool = true
    @Published var resendButtonText: String = "Resend code"

    @Published private var resendTimout: Int = 0

    private let didFinishSubject = PassthroughSubject<Void, Never>()
    lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()

    private var cancellables = Set<AnyCancellable>()

    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let authService: AuthService

    init(authService: AuthService = AuthServiceImpl()) {
        self.authService = authService
        
        setup()
    }

    private func setup() {
        $otpCode
            .map { $0.count == 4 }
            .assign(to: \.isOTPFormatValid, on: self)
            .store(in: &cancellables)

        timerPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.resendTimout == 0 { return }
                self.resendTimout -= 1
            }
            .store(in: &cancellables)

        $resendTimout
            .sink { [unowned self] secondsLeft in
                isResendButtonAvailable = secondsLeft == 0
                resendButtonText = secondsLeft == 0
                    ? "Resend code"
                    : "Resend code (00:\(secondsLeft < 10 ? "0" : "")\(secondsLeft))"
            }
            .store(in: &cancellables)
    }

    func send() {
        authService.verifyOTP(code: otpCode)
            .filter { $0 }
            .sink { [unowned self] _ in didFinishSubject.send() }
            .store(in: &cancellables)
    }

    func resend() {
        resendTimout = 10
    }

}
