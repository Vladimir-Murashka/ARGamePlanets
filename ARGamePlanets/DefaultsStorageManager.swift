//
//  StorageManager.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 21.07.2022.
//

import Foundation

protocol DefaultsStoragable {
    func saveObject(_ value: Any, for key: DefaultsKey)
    func fetchObject<T>(type: T.Type, for key: DefaultsKey) ->T?
    func deleteObject(for key: DefaultsKey)
}

final class DefaultsStorage {
    
    private let defaults = UserDefaults.standard
    
}

extension DefaultsStorage: DefaultsStoragable {
    
    func saveObject(_ value: Any, for key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func fetchObject<T>(type: T.Type, for key: DefaultsKey) ->T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    func deleteObject(for key: DefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}

enum DefaultsKey: String {
    case isVibrationOn
    case isMusicOn
    case isSoundEffect
}
