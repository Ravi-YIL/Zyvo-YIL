//
//  TimeSlot.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//


import Foundation
struct TimeSlot {
    let hour: Int   // 0...23

    var display: String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let p = hour < 12 ? "AM" : "PM"
        return "\(p)\n\(String(format: "%02d:00", h))"
    }
}


