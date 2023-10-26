//
//  HapticManager.swift
//  PingPong
//
//  Created by Mnatsakan Work on 23.10.23.
//

import UIKit
import SwiftUI

final class HapticManager {
    @AppStorage("haptic") var isHavticOn: Bool = true
    static let shared = HapticManager()
    
    func lightFeedback() {
        guard isHavticOn else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func mediumFeedback() {
        guard isHavticOn else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func heavyFeedback() {
        guard isHavticOn else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func errorFeedback() {
        guard isHavticOn else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    func successFeedback() {
        guard isHavticOn else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
