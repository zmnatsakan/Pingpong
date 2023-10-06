//
//  GameConfiguration.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

struct GameConfiguration {
    var time: Int? = nil             // nil if no timer is needed
    var hitTarget: Int? = nil        // nil if no hit target is set
    var goalTarget: Int? = nil       // nil if no goal target is set
    var hasObstacles: Bool = false   // true if obstacles should be added
    var hasBoostFields: Bool = false // true if boost fields should be added
}
