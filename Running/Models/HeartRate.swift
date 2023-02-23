//
//  HeartRate.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 23/02/2023.
//

import SwiftUI
import Foundation

class HeartRate: Dimension {
    static let beatsPerMinute = HeartRate(symbol: "bpm", converter: UnitConverterLinear(coefficient: 1.0/60.0))
    
    override class func baseUnit() -> Self {
        return beatsPerMinute as! Self
    }
}
