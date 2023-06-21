//
//  UserDefaultsService.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import UIKit

protocol LocalStorageService {
    func setObject<T: Codable>(_ object: T,  forKey key: UserDefaults.Key)
    func getObject<T: Codable>(forKey key: UserDefaults.Key) -> T?
    
    func setPrimitive(_ object: Any?,  forKey key: UserDefaults.Key)
    func getPrimitive<T: Codable>(forKey key: UserDefaults.Key) -> T?
    
    func remove(key: UserDefaults.Key)
}

class UserDefaultsService: LocalStorageService {
    
    // MARK: - Set/Get Object
    
    func setObject<T: Codable>(_ object: T,  forKey key: UserDefaults.Key) {
        guard let encoded = try? JSONEncoder().encode(object) else { return }
        UserDefaults.standard.set(encoded, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getObject<T: Codable>(forKey key: UserDefaults.Key) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    
    // MARK: - Set/Get Any?
    
    func setPrimitive(_ object: Any?,  forKey key: UserDefaults.Key) {
        UserDefaults.standard.set(object, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getPrimitive<T: Codable>(forKey key: UserDefaults.Key) -> T? {
        UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    // MARK: - Set/Get Object
    
    func setObjectInSuite<T: Codable>(_ object: T,  forKey key: UserDefaults.Key) {
        let sharedDefault = UserDefaults(suiteName: "group.com.au.edbreak.prod")!
        guard let encoded = try? JSONEncoder().encode(object) else { return }
        sharedDefault.set(encoded, forKey: key.rawValue)
        sharedDefault.synchronize()
    }
    
    func getObjectFromSuite<T: Codable>(forKey key: UserDefaults.Key) -> T? {
        let sharedDefault = UserDefaults(suiteName: "group.com.au.edbreak.prod")!
        guard let data = sharedDefault.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func setPrimitiveInSuite(_ object: Any?,  forKey key: UserDefaults.Key) {
        let sharedDefault = UserDefaults(suiteName: "group.com.au.edbreak.prod")!
        sharedDefault.set(object, forKey: key.rawValue)
        sharedDefault.synchronize()
    }
    
    func getPrimitiveFromSuite<T: Codable>(forKey key: UserDefaults.Key) -> T? {
        let sharedDefault = UserDefaults(suiteName: "group.com.au.edbreak.prod")!
        return sharedDefault.object(forKey: key.rawValue) as? T
    }
    
    
    // MARK: - Remove
    
    func remove(key: UserDefaults.Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
