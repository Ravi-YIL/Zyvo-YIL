//
//  RangeSliderContainer.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 12/06/25.
//

import Foundation
import SwiftUI

struct RangeSliderContainer: View {
    @ObservedObject var viewModel: RangeSliderViewModel
       let barData: [Double]
       let range: ClosedRange<Double>

       var body: some View {
           RangeSlider(
               minValue: $viewModel.minValue,
               maxValue: $viewModel.maxValue,
               barData: barData,
               range: range
           )
           .padding()
       }

}

