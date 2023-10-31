//
//  ArrayExtension.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import Foundation

extension Array where Element == SkinCodable {
    func save(to key: String) {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding SkinCodable array: \(error)")
        }
    }
    
    static func load(from key: String) -> [SkinCodable]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            let skinCodables = try JSONDecoder().decode([SkinCodable].self, from: data)
            return skinCodables
        } catch {
            print("Error decoding SkinCodable array: \(error)")
            return nil
        }
    }
}
