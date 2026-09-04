//
//  CircularView.swift
//  Zyvo
//
//  Created by ravi on 26/11/24.
//

import UIKit

class CircularView: UIView {
    
    // MARK: - Properties
    private let backgroundCircleColor = UIColor.red
    private let progressCircleColor = UIColor(red: 0.29, green: 0.92, blue: 0.69, alpha: 1.0)
    private let thumbColor = UIColor.white
    private let dotColor = UIColor.black.withAlphaComponent(0.4)
    
    private let circleStrokeWidth: CGFloat = 94
    private let thumbRadius: CGFloat = 33
    private let dotRadius: CGFloat = 10
    private var progressAngle: CGFloat = 5 // Initial progress angle
    private var radius: CGFloat = 0
    private var thumbX: CGFloat = 0
    private var thumbY: CGFloat = 0
    private var progress: Int = 1 // Default progress
    private let maxHours = 13
    private var isTouchingThumb = false
    private var hourDots: [(CGFloat, CGFloat)] = []
    private var initialAngle: CGFloat = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let width = bounds.width
        let height = bounds.height
        let cx = width / 2
        let cy = height / 2
        
        radius = min(width, height) / 2 - circleStrokeWidth / 2
        
        // Draw background circle
        let backgroundCircle = UIBezierPath(arcCenter: CGPoint(x: cx, y: cy),
                                            radius: radius,
                                            startAngle: 0,
                                            endAngle: 2 * .pi,
                                            clockwise: true)
        context.setLineWidth(circleStrokeWidth)
        backgroundCircleColor.setStroke()
        backgroundCircle.stroke()
        
        // Draw progress arc
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (progressAngle * .pi / 180)
        let progressArc = UIBezierPath(arcCenter: CGPoint(x: cx, y: cy),
                                       radius: radius,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: true)
        context.setLineWidth(circleStrokeWidth)
        progressCircleColor.setStroke()
        progressArc.stroke()
        
        // Draw hour dots
        hourDots.removeAll()
        for hour in 0..<maxHours {
            let angle = CGFloat(hour) * 360 / CGFloat(maxHours) - 90
            let radian = angle * .pi / 180
            let dotX = cx + radius * cos(radian)
            let dotY = cy + radius * sin(radian)
            hourDots.append((dotX, dotY))
            
            if CGFloat(hour) * 360 / CGFloat(maxHours) > progressAngle {
                context.setFillColor(dotColor.cgColor)
                context.fillEllipse(in: CGRect(x: dotX - dotRadius / 2,
                                               y: dotY - dotRadius / 2,
                                               width: dotRadius,
                                               height: dotRadius))
            }
        }
        
        // Calculate thumb position
        if progress < hourDots.count {
            thumbX = hourDots[progress].0
            thumbY = hourDots[progress].1
        }
        
        // Draw thumb
        context.setFillColor(thumbColor.cgColor)
        context.fillEllipse(in: CGRect(x: thumbX - thumbRadius / 2,
                                       y: thumbY - thumbRadius / 2,
                                       width: thumbRadius,
                                       height: thumbRadius))
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            if isTouchOnThumb(location) {
                isTouchingThumb = true
                initialAngle = getAngleFromTouch(location)
            } else {
                snapToNearestDot(location)
            }
        case .changed:
            if isTouchingThumb {
                let currentAngle = getAngleFromTouch(location)
                let angleDiff = currentAngle - initialAngle
                progressAngle = (progressAngle + angleDiff).truncatingRemainder(dividingBy: 360)
                updateProgress()
                initialAngle = currentAngle
                setNeedsDisplay()
            }
        case .ended, .cancelled:
            isTouchingThumb = false
        default:
            break
        }
    }
    
    // MARK: - Helper Functions
    private func isTouchOnThumb(_ location: CGPoint) -> Bool {
        let distance = sqrt(pow(location.x - thumbX, 2) + pow(location.y - thumbY, 2))
        return distance <= thumbRadius
    }
    
    private func getAngleFromTouch(_ location: CGPoint) -> CGFloat {
        let dx = location.x - bounds.width / 2
        let dy = location.y - bounds.height / 2
        let angle = atan2(dy, dx) * 180 / .pi
        return (angle + 360).truncatingRemainder(dividingBy: 360)
    }
    
    private func snapToNearestDot(_ location: CGPoint) {
        var nearestDotIndex = 0
        var nearestDistance = CGFloat.greatestFiniteMagnitude
        
        for (index, dot) in hourDots.enumerated() {
            let distance = sqrt(pow(location.x - dot.0, 2) + pow(location.y - dot.1, 2))
            if distance < nearestDistance {
                nearestDistance = distance
                nearestDotIndex = index
            }
        }
        
        progress = nearestDotIndex
        progressAngle = CGFloat(progress) * 360 / CGFloat(maxHours)
        updateProgress()
        setNeedsDisplay()
    }
    
    private func updateProgress() {
        progress = Int((progressAngle / 360) * CGFloat(maxHours))
        progress = min(max(progress, 0), maxHours - 1)
        updateCenterText()
    }
    
    private func updateCenterText() {
        if let parentView = self.superview as? UIView,
           let label = parentView.viewWithTag(101) as? UILabel {
            label.text = "\(progress)"
        }
    }
}

