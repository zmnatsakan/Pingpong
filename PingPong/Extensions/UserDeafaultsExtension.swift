//
//  UserDeafaultsExtension.swift
//  PingPong
//
//  Created by  admin on 08.11.2023.
//

import Foundation

extension UserDefaults {
    func resetDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach({self.removeObject(forKey: $0)})
    }
}
