//
//  StorageService.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation

protocol StorageService {
    @discardableResult
    func save<T>(encodable: T, key: String) -> Bool where T: Encodable
    
    @discardableResult
    func load<T>(key: String) -> T? where T: Decodable
}

typealias DefaultStorageService = UserDefaultStorage

class UserDefaultStorage: StorageService {
    
    private var container = UserDefaults.standard
    
    init() {}
    
    convenience init(container: UserDefaults) {
        self.init()
        self.container = container
    }
    
    @discardableResult
    func save<T>(encodable: T, key: String) -> Bool where T: Encodable {
        guard let encoding = try? PropertyListEncoder().encode(encodable) else {
            return false
        }
        self.container.set(encoding, forKey: key)
        self.container.synchronize()
        return true
    }
    
    @discardableResult
    func load<T>(key: String) -> T? where T: Decodable {
        if let data = self.container.object(forKey: key) as? Data {
            return try? PropertyListDecoder().decode(T.self, from: data)
        }
        
        return nil
    }
}
