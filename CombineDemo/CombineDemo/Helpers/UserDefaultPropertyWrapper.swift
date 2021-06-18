//
//  UserDefaultPropertyWrapper.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T

  init(_ key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
}

@propertyWrapper
struct UserDefaultJSON<T: Codable> {
  let key: String
  let defaultValue: T

  init(_ key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      guard let data = UserDefaults.standard.data(forKey: key),
            let value = try? JSONDecoder().decode(T.self, from: data) else { return defaultValue }

      return value
    }
    set {
      guard let data = try? JSONEncoder().encode(newValue) else { return }
      UserDefaults.standard.setValue(data, forKey: key)
    }
  }
}
