//
//  SettingsViewModel.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import Foundation
import Combine
import UIKit

class SettingsViewModel {

    @Published var isLargeTitles = true

    private let settingsService: SettingsService

    private var cancellables = Set<AnyCancellable>()

    init(settingsService: SettingsService = SettingsServiceImpl()) {
        self.settingsService = settingsService
        setup()
    }

    private func setup() {
        settingsService.settingsPublisher
            .sink { [unowned self] settingsModel in
                isLargeTitles = settingsModel.largeTitleIsOn
            }
            .store(in: &cancellables)
    }

    func setLargeTitles(isOn: Bool) {
        settingsService.settings.largeTitleIsOn = isOn
    }

    func logout() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

extension NSNotification.Name {
    static let logout = Notification.Name("Logout")
}
