//
//  SettingsService.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 07.06.2021.
//

import Foundation
import Combine

protocol SettingsService: class {
    var settings: Settings { get set }
    var settingsPublisher: AnyPublisher<Settings, Never> { get }
}

class SettingsServiceImpl: SettingsService {

    lazy var settingsPublisher = settingsSubject.eraseToAnyPublisher()
    private lazy var settingsSubject = CurrentValueSubject<Settings, Never>(settings)

    @UserDefaultJSON("settingsKey", defaultValue: .default)
    var settings: Settings {
        didSet { settingsSubject.send(settings) }
    }

}
