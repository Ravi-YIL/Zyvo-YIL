//
//  RangeSliderViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 12/06/25.
//

import SwiftUI
import Combine

class RangeSliderViewModel: ObservableObject {
    @Published var minValue: Double = 0
    @Published var maxValue: Double = 100
}


