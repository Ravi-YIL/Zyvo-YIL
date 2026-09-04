
import SwiftUI

struct RangeSlider: View {
    @Binding var minValue: Double
       @Binding var maxValue: Double
       let barData: [Double]
       let range: ClosedRange<Double>
       @State private var isDraggingMin = false
       @State private var isDraggingMax = false

       var body: some View {
           VStack {
               GeometryReader { geometry in
                   RangeSliderContent(
                       width: geometry.size.width,
                       minValue: $minValue,
                       maxValue: $maxValue,
                       isDraggingMin: $isDraggingMin,
                       isDraggingMax: $isDraggingMax,
                       barData: barData,
                       range: range
                   )
               }
               .frame(height: 120)
           }
           .padding()
       }
}

struct RangeSliderContent: View {
    let width: CGFloat
    @Binding var minValue: Double
    @Binding var maxValue: Double
    @Binding var isDraggingMin: Bool
    @Binding var isDraggingMax: Bool
    let barData: [Double]
    let range: ClosedRange<Double>

    private let height: CGFloat = 100

    var body: some View {
        ZStack(alignment: .leading) {
            BarChartView(
                barData: barData,
                width: width,
                height: height,
                minValue: minValue,
                maxValue: maxValue,
                range: range
            )

            SelectionIndicatorView(
                minValue: minValue,
                maxValue: maxValue,
                width: width,
                height: height,
                range: range
            )
            
            MinHandleView(minValue: $minValue, maxValue: maxValue, isDragging: $isDraggingMin, width: width, height: height, range: range)
            MaxHandleView(minValue: minValue, maxValue: $maxValue, isDragging: $isDraggingMax, width: width, height: height, range: range)
        }
    }
}

struct BarChartView: View {
    let barData: [Double]
    let width: CGFloat
    let height: CGFloat
    var minValue: Double
    var maxValue: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<barData.count, id: \.self) { index in
                let totalSpan = range.upperBound - range.lowerBound
                let valueAtBar = range.lowerBound +
                    (Double(index) / Double(max(1, barData.count - 1))) *
                    (totalSpan > 0 ? totalSpan : 1.0)

                let isSelected =
                    valueAtBar >= minValue &&
                    valueAtBar <= maxValue

                Rectangle()
                    .fill(
                        isSelected
                        ? Color.black
                        : Color.gray.opacity(0.3)
                    )
                    .frame(
                        width: barWidth,
                        height: (barData[index] / 100.0) * height
                    )
            }
        }
    }

    private var barWidth: CGFloat {
        (width - CGFloat(barData.count - 1) * 2) / CGFloat(barData.count)
    }
}

struct SelectionBarsView: View {
    let minValue: Double
    let maxValue: Double
    let width: CGFloat
    let height: CGFloat
    
    let range: ClosedRange<Double>

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: leftBarWidth, height: 4)

            Spacer()

            Rectangle()
                .fill(Color.black)
                .frame(width: rightBarWidth, height: 4)
        }
        .offset(y: height / 2 - 2.9)
    }

    private var leftBarWidth: CGFloat {
        let upperBound = range.upperBound > 0 ? range.upperBound : 1.0
        return CGFloat(maxValue / upperBound) * width
    }

    private var rightBarWidth: CGFloat {
        let upperBound = range.upperBound > 0 ? range.upperBound : 1.0
        return CGFloat((upperBound - maxValue) / upperBound) * width
    }
}

struct SelectionIndicatorView: View {
    let minValue: Double
    let maxValue: Double
    let width: CGFloat
    let height: CGFloat
    
    let range: ClosedRange<Double>

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(
                Rectangle()
                    .stroke(Color.clear.opacity(0.3), lineWidth: 2)
            )
            .frame(width: selectionWidth, height: height)
            .offset(x: selectionOffset, y: 0)
    }

    private var selectionWidth: CGFloat {
        let totalSpan = range.upperBound - range.lowerBound
        guard totalSpan > 0 else { return width }
        return CGFloat((maxValue - minValue) / totalSpan) * width
    }

    private var selectionOffset: CGFloat {
        let totalSpan = range.upperBound - range.lowerBound
        guard totalSpan > 0 else { return 0 }
        return CGFloat((minValue - range.lowerBound) / totalSpan) * width
    }
}

struct MinHandleView: View {
    @Binding var minValue: Double
    let maxValue: Double
    @Binding var isDragging: Bool
    let width: CGFloat
    let height: CGFloat
    let range: ClosedRange<Double>

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
            )
            .scaleEffect(isDragging ? 1.2 : 1.0)
            .position(x: handlePosition, y: height / 2 + 55)
            .gesture(dragGesture)
    }

    private var handlePosition: CGFloat {
        let radius: CGFloat = 10
        let totalSpan = range.upperBound - range.lowerBound
        guard totalSpan > 0 else { return radius }
        let fraction = (minValue - range.lowerBound) / totalSpan
        return radius + CGFloat(max(0.0, min(1.0, fraction))) * (width - radius * 2)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let totalSpan = range.upperBound - range.lowerBound
                guard totalSpan > 0 else { return }

                let newValue = max(
                    range.lowerBound,
                    min(
                        maxValue - 1,
                        range.lowerBound +
                        (Double(value.location.x) / Double(width)) * totalSpan
                    )
                )

                minValue = newValue
            }
            .onEnded { _ in
                isDragging = false
            }
    }
}

struct MaxHandleView: View {
    let minValue: Double
    @Binding var maxValue: Double
    @Binding var isDragging: Bool
    let width: CGFloat
    let height: CGFloat
    let range: ClosedRange<Double>

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
            )
            .scaleEffect(isDragging ? 1.2 : 1.0)
            .position(x: handlePosition, y: height / 2 + 55)
            .gesture(dragGesture)
    }

    private var handlePosition: CGFloat {
        let radius: CGFloat = 10
        let totalSpan = range.upperBound - range.lowerBound
        guard totalSpan > 0 else { return width - radius }
        let fraction = (maxValue - range.lowerBound) / totalSpan
        return radius + CGFloat(max(0.0, min(1.0, fraction))) * (width - radius * 2)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let totalSpan = range.upperBound - range.lowerBound
                guard totalSpan > 0 else { return }

                let newValue = min(
                    range.upperBound,
                    max(
                        minValue + 1,
                        range.lowerBound +
                        (Double(value.location.x) / Double(width)) * totalSpan
                    )
                )

                maxValue = newValue
            }
    }
}

