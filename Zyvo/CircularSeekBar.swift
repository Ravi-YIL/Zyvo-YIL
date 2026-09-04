//
//  CircularSeekBar.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//



import Foundation
import UIKit

protocol CircularSeekBarDelegate: AnyObject {
    func circularSeekBarDidStartDragging()
    func circularSeekBarDidEndDragging()
    func didUpdateCenterLabel(Hours:String)
   
}

class CircularSeekBar: UIView {
    
    weak var delegate: CircularSeekBarDelegate?
    
    private let backgroundCircleColor = UIColor(red: 255,green: 255, blue: 255, alpha: 1)
    private let progressColor = UIColor(red: 74/255, green: 238/255, blue: 177/255, alpha: 1.0)
    private let thumbColor = UIColor.white
    private let dotColor = UIColor.lightGray.withAlphaComponent(0.6)
    
    private var radius: CGFloat = 0.0
    private var thumbX: CGFloat = 0.0
    private var thumbY: CGFloat = 0.0
    private var progressAngle: CGFloat = 28.8
    private var progress = 0 // Start progress at 0 (0 hours)
    private let maxHours = 24
    private var isTouchingThumb = false
    private var hourDots: [(CGFloat, CGFloat)] = []
    private var initialTouchAngle: CGFloat = 0.0
    private var initialProgressAngle: CGFloat = 0.0
    private let centerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        centerLabel.textAlignment = .center
//        centerLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        centerLabel.textColor = .black
        addSubview(centerLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerLabel.frame = CGRect(x: bounds.width / 2 - 50, y: bounds.height / 2 - 50, width: 100, height: 100)
        
        updateCenterText()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = bounds.width
        let height = bounds.height
        radius = min(width, height) / 2 - 40
        
        let center = CGPoint(x: width / 2, y: height / 2)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw the background circle
//        context.setShadow(offset: CGSize(width: 0, height: 0), blur: 40)
        context.setShadow(offset: CGSize(width: 0, height: 0), blur: 20, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor)
        context.setLineWidth(50)
        context.setFillColor(backgroundCircleColor.cgColor)
        context.setStrokeColor(backgroundCircleColor.cgColor)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.setLineCap(.round)
        context.strokePath()
     
        // Draw the progress arc
        context.setStrokeColor(progressColor.cgColor)
        let endAngle = (-.pi / 2) + (.pi * 2 * progressAngle / 360)
        context.addArc(center: center, radius: radius, startAngle: -.pi / 2, endAngle: endAngle, clockwise: false)
        context.strokePath()
        
        // Draw the hour dots

        hourDots.removeAll()

        for hour in 0..<maxHours {
            let angle = CGFloat(hour) * 360 / CGFloat(maxHours)
            
            // ❗ Skip dots inside progress
            if angle <= progressAngle {
                continue
            }
            
            let radian = (angle - 90) * .pi / 180
            let dotX = center.x + radius * cos(radian)
            let dotY = center.y + radius * sin(radian)
            
            hourDots.append((dotX, dotY))
            
            context.setFillColor(dotColor.cgColor)
            context.addArc(center: CGPoint(x: dotX, y: dotY),
                           radius: 5,
                           startAngle: 0,
                           endAngle: .pi * 2,
                           clockwise: true)
            context.fillPath()
        }
        
        // Draw the thumb (draggable circle)
        thumbX = center.x + radius * cos((progressAngle - 90) * .pi / 180)
        thumbY = center.y + radius * sin((progressAngle - 90) * .pi / 180)
        
        // Add shadow back for the thumb
        context.setFillColor(thumbColor.cgColor)
        context.addArc(center: CGPoint(x: thumbX, y: thumbY), radius: 20, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.fillPath()
    }

    private func updateCenterText() {
        print(progressAngle,"")
       // let hours = Int((progressAngle / 360) * CGFloat(maxHours))
      //  let hours = Int(floor((progressAngle / 360) * CGFloat(maxHours)))
        
        let hours = max(1, Int(round((progressAngle / 360) * CGFloat(maxHours))))

        let displayHour = (hours == 0 ? 00 : hours) // Map 0 to 12
        // Update the center label text with the current hour
        centerLabel.numberOfLines = 0
        centerLabel.text = "\(displayHour) \nHours"
        // Create the attributed text
        let attributedString = NSMutableAttributedString(string: centerLabel.text ?? "")

        // Set font size 52 for "3"
        if let range = centerLabel.text?.range(of: "\(displayHour)") {
            let nsRange = NSRange(range, in: centerLabel.text ?? "")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 52, weight: .medium), range: nsRange)
        }

        // Set font size 18 for "Hours"
        if let range = centerLabel.text?.range(of: "Hours") {
            let nsRange = NSRange(range, in: centerLabel.text ?? "")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .regular), range: nsRange)
        }

        // Assign the attributed string to the label
        
        if progressAngle >= 350 || progressAngle <= 31.071459058558048{
            progressAngle = 31.071459058558048 
            setupView()
        }
        centerLabel.attributedText = attributedString
        // Notify the delegate
        delegate?.didUpdateCenterLabel(Hours: "\(displayHour)")
//        print("\(progress == maxHours ? maxHours : progress) Hours")
//        centerLabel.text = "\(progress == maxHours ? maxHours : progress) Hours"
    }
    
    public func isTouchOnThumb(_ x: CGFloat, _ y: CGFloat) -> Bool {
        print("I m pressed")
        let thumbRadius: CGFloat = 25.0
        let distance = sqrt((x - thumbX).pow(2) + (y - thumbY).pow(2))
        return distance <= thumbRadius
    }
    
    private func snapToNearestDot(_ x: CGFloat, _ y: CGFloat) {
        print("I m pressed again")
        var nearestDotIndex = 0
        var nearestDistance = CGFloat.greatestFiniteMagnitude
        
        for (i, dot) in hourDots.enumerated() {
            let distance = sqrt((x - dot.0).pow(2) + (y - dot.1).pow(2))
            if distance < nearestDistance {
                nearestDistance = distance
                nearestDotIndex = i
            }
        }
        
        progress = nearestDotIndex
        progressAngle = CGFloat(progress) * 360 / CGFloat(maxHours)
        updateCenterText()
        setNeedsDisplay()
    }
    
    private func getAngleFromTouch(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        let cx = bounds.width / 2
        let cy = bounds.height / 2
        let angle = atan2(y - cy, x - cx).toDegrees()
        return (angle + 360).truncatingRemainder(dividingBy: 360)
    }
 
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        let location = touch.location(in: self)
//
//        if isTouchOnThumb(location.x, location.y) {
//
//            isTouchingThumb = true
//
//            // Disable scroll only when thumb is touched
//            parentScrollView()?.isScrollEnabled = false
//
//            initialTouchAngle = getAngleFromTouch(location.x, location.y)
//            initialProgressAngle = progressAngle
//
//            delegate?.circularSeekBarDidStartDragging()
//
//        } else {
//
//            // Not touching thumb -> allow scrollview to handle it
//            isTouchingThumb = false
//        }
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        if isTouchOnThumb(location.x, location.y) {

            isTouchingThumb = true

            parentScrollView()?.isScrollEnabled = false

            initialTouchAngle = getAngleFromTouch(location.x, location.y)
            initialProgressAngle = progressAngle

            delegate?.circularSeekBarDidStartDragging()

        } else {

            // User tapped somewhere on circle
            updateHourFromTap(location)
        }
    }
    private func updateHourFromTap(_ location: CGPoint) {

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        var nearestHour = 1
        var minimumDistance = CGFloat.greatestFiniteMagnitude

        for hour in 1...maxHours {

            let angle = CGFloat(hour) * 360.0 / CGFloat(maxHours)

            let radian = (angle - 90) * .pi / 180

            let x = center.x + radius * cos(radian)
            let y = center.y + radius * sin(radian)

            let distance = sqrt(
                pow(location.x - x, 2) +
                pow(location.y - y, 2)
            )

            if distance < minimumDistance {
                minimumDistance = distance
                nearestHour = hour
            }
        }

        // Tap should be close to circle
        if minimumDistance < 40 {

            progress = nearestHour
            progressAngle = CGFloat(nearestHour) * 360.0 / CGFloat(maxHours)

            updateCenterText()
            setNeedsDisplay()

            delegate?.didUpdateCenterLabel(Hours: "\(nearestHour)")
        }
    }
    private func parentScrollView() -> UIScrollView? {
        var view = superview

        while view != nil {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            view = view?.superview
        }

        return nil
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard isTouchingThumb,
              let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)

        let angle = getAngleFromTouch(location.x, location.y)

        let angleDifference = angle - initialTouchAngle

        progressAngle = initialProgressAngle + angleDifference
        progressAngle = (progressAngle + 360).truncatingRemainder(dividingBy: 360)

        progress = Int((progressAngle / 360) * CGFloat(maxHours))

        updateCenterText()
        setNeedsDisplay()
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if isTouchingThumb {
            parentScrollView()?.isScrollEnabled = true
            delegate?.circularSeekBarDidEndDragging()
        }

        isTouchingThumb = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       isTouchingThumb = false

       // Notify delegate
       delegate?.circularSeekBarDidEndDragging()
    }
    
    public func setHour(_ hour: Int) {
        guard hour >= 0 && hour <= maxHours else { return }

        self.progress = hour
        self.progressAngle = CGFloat(hour) * 360 / CGFloat(maxHours)

        updateCenterText()
        setNeedsDisplay()
    }
}

extension CGFloat {
    func pow(_ exponent: CGFloat) -> CGFloat {
        return CGFloat(Darwin.pow(Double(self), Double(exponent)))
    }
    
    func toDegrees() -> CGFloat {
        return self * 180 / .pi
    }
}


