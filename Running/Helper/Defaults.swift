//
//  Defaults.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 03/02/2023.
//

import Foundation

@propertyWrapper
struct Defaults<ValueType> {
    let defaults = UserDefaults.standard
    
    let key: String
    let defaultValue: ValueType
    
    func reset() {
        defaults.set(defaultValue, forKey: key)
    }

    var wrappedValue: ValueType {
        get {
            defaults.object(forKey: key) as? ValueType ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
