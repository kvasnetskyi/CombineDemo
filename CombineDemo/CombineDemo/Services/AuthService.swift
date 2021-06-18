//
//  AuthService.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import Foundation
import Combine

enum AuthError: Error {
    case incorrectPassword
    case wrongOTP
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectPassword: return "Email or password is incorrect"
        case .wrongOTP: return "Wrong OTP code"
        }
    }
}

protocol AuthService {
    func signUp(email: String, password: String) -> AnyPublisher<Bool, AuthError>
    func verifyOTP(code: String) -> AnyPublisher<Bool, Never>
}

class AuthServiceImpl: AuthService {
    func signUp(email: String, password: String) -> AnyPublisher<Bool, AuthError> {
        Future<Bool, AuthError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if password == "Password1" {
                    promise(.success(true))
                } else {
                    promise(.failure(.incorrectPassword))
                }

            }
        }.eraseToAnyPublisher()
    }

    func verifyOTP(code: String) -> AnyPublisher<Bool, Never> {
        return Just(true).eraseToAnyPublisher()
    }
}
