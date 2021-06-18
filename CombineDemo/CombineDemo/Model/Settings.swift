//
//  Settings.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import Foundation

struct Settings: Codable {
    var largeTitleIsOn: Bool

    static let `default`: Settings = .init(largeTitleIsOn: true)
}
