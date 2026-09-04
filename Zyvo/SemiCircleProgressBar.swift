////
////  SemiCircleProgressBar.swift
////  Zyvo
////
////  Created by ravi on 3/04/25.
////
//
//
//
//
//




import UIKit
import CoreGraphics


import UIKit

import UIKit

import UIKit


import UIKit

class SemiCircleProgressBar: UIView, CAAnimationDelegate {

    var animationDuration: TimeInterval = 1.0

    var progress: CGFloat = 1.0 { // Value between 0.0 and 1.0
        didSet {
            setNeedsLayout()
        }
    }

    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image name

    private let backgroundShape = CAShapeLayer()
    private let backgroundGradientLayer = CAGradientLayer()

    private let strokeShape = CAShapeLayer()
    private let strokeGradientLayer = CAGradientLayer()

    private var centerPoint: CGPoint = .zero
    private var radius: CGFloat = 0.0
    private var startAngle: CGFloat = .pi
    private var endAngle: CGFloat = 0.0
    private var actualEndAngle: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Clean up old layers
        backgroundGradientLayer.removeFromSuperlayer()
        strokeGradientLayer.removeFromSuperlayer()

        // Setup geometry
        radius = bounds.width / 2
        centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 3)
        startAngle = .pi        // 180° (leftmost)
        endAngle = 0            // 0° (rightmost)
        actualEndAngle = startAngle + (.pi * -progress)

        // Background full semi-circle
        let fullPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        fullPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
        fullPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
        fullPath.close()

        backgroundShape.path = fullPath.cgPath
        backgroundShape.fillColor = UIColor.black.cgColor

        backgroundGradientLayer.frame = bounds
        backgroundGradientLayer.mask = backgroundShape
        backgroundGradientLayer.colors = [
            UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
        ]
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
        layer.addSublayer(backgroundGradientLayer)

        // Progress arc path
        let partialStrokePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: actualEndAngle,
            clockwise: true
        )
        strokeShape.path = partialStrokePath.cgPath
        strokeShape.fillColor = UIColor.clear.cgColor
        strokeShape.strokeColor = UIColor.black.cgColor
        strokeShape.lineWidth = 7

        strokeGradientLayer.frame = bounds
        strokeGradientLayer.mask = strokeShape
        strokeGradientLayer.colors = [
            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
            UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
        ]
        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(strokeGradientLayer)

        // Image setup
        imageView.layer.removeAllAnimations()
        imageView.layer.zPosition = 1
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        let startPoint = CGPoint(
            x: centerPoint.x + radius * cos(startAngle),
            y: centerPoint.y + radius * sin(startAngle)
        )

        if animationDuration == 0.0 {
            // Move instantly to final point
            let finalPoint = CGPoint(
                x: centerPoint.x + radius * cos(actualEndAngle),
                y: centerPoint.y + radius * sin(actualEndAngle)
            )
            imageView.center = finalPoint
        } else {
            // Start from leftmost point
            imageView.center = startPoint
            animateImageAlongArc(path: partialStrokePath)
        }
    }

    private func animateImageAlongArc(path: UIBezierPath) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = animationDuration
        animation.calculationMode = .paced
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        imageView.layer.add(animation, forKey: "arcAnimation")
    }

    // MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            imageView.layer.removeAnimation(forKey: "arcAnimation")

            // Snap image to final point to prevent drift
            let finalPoint = CGPoint(
                x: centerPoint.x + radius * cos(actualEndAngle),
                y: centerPoint.y + radius * sin(actualEndAngle)
            )
            imageView.center = finalPoint
        }
    }
}

//
//import UIKit
//
//class SemiCircleProgressBar: UIView, CAAnimationDelegate {
//
//    var animationDuration: TimeInterval = 1.0
//
//    var progress: CGFloat = 1.0 { // Value between 0.0 and 1.0
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image name
//
//    private let backgroundShape = CAShapeLayer()
//    private let backgroundGradientLayer = CAGradientLayer()
//
//    private let strokeShape = CAShapeLayer()
//    private let strokeGradientLayer = CAGradientLayer()
//
//    private var centerPoint: CGPoint = .zero
//    private var radius: CGFloat = 0.0
//    private var startAngle: CGFloat = .pi
//    private var endAngle: CGFloat = 0.0
//    private var actualEndAngle: CGFloat = 0.0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupImageView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupImageView()
//    }
//
//    private func setupImageView() {
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//        addSubview(imageView)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Clean up old layers
//        backgroundGradientLayer.removeFromSuperlayer()
//        strokeGradientLayer.removeFromSuperlayer()
//
//        radius = bounds.width / 2
//        centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 3)
//
//        startAngle = .pi   // Leftmost (180°)
//        endAngle = 0       // Rightmost (0°)
//        actualEndAngle = startAngle + (.pi * -progress) // Clockwise direction
//
//        // Background path (full semicircle)
//        let fullPath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
//        fullPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
//        fullPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
//        fullPath.close()
//
//        backgroundShape.path = fullPath.cgPath
//        backgroundShape.fillColor = UIColor.black.cgColor
//
//        backgroundGradientLayer.frame = bounds
//        backgroundGradientLayer.mask = backgroundShape
//        backgroundGradientLayer.colors = [
//            UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
//        ]
//        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
//        layer.addSublayer(backgroundGradientLayer)
//
//        // Partial stroke path
//        let partialStrokePath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: actualEndAngle,
//            clockwise: true
//        )
//        strokeShape.path = partialStrokePath.cgPath
//        strokeShape.fillColor = UIColor.clear.cgColor
//        strokeShape.strokeColor = UIColor.black.cgColor
//        strokeShape.lineWidth = 7
//
//        strokeGradientLayer.frame = bounds
//        strokeGradientLayer.mask = strokeShape
//        strokeGradientLayer.colors = [
//            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
//            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
//            UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
//            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
//            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
//        ]
//        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(strokeGradientLayer)
//
//        // ImageView setup
//        imageView.layer.removeAllAnimations()
//        imageView.layer.zPosition = 1
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//
//        // Start at leftmost point
//        let startPoint = CGPoint(
//            x: centerPoint.x + radius * cos(startAngle),
//            y: centerPoint.y + radius * sin(startAngle)
//        )
//        imageView.center = startPoint
//
//       // animateImageAlongArc(path: partialStrokePath)
//        
//        if animationDuration == 0.0 {
//            // Move image instantly to the final point on the arc
//            let angle = actualEndAngle
//            let finalPoint = CGPoint(
//                x: centerPoint.x + radius * cos(angle),
//                y: centerPoint.y + radius * sin(angle)
//            )
//            imageView.center = finalPoint
//        } else {
//            // Animate image along the arc
//            animateImageAlongArc(path: partialStrokePath)
//        }
//    }
//
//    private func animateImageAlongArc(path: UIBezierPath) {
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = path.cgPath
//        animation.duration = animationDuration
//     
//        animation.calculationMode = .paced
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        animation.delegate = self
//        imageView.layer.add(animation, forKey: "arcAnimation")
//    }
//
//    // MARK: - CAAnimationDelegate Method
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            
//            imageView.layer.removeAnimation(forKey: "arcAnimation")
//            
//            // Calculate final position
//            let angle = actualEndAngle
//            let finalPoint = CGPoint(
//                x: centerPoint.x + radius * cos(angle),
//                y: centerPoint.y + radius * sin(angle)
//            )
//          
//            imageView.center = finalPoint
//        }
//    }
//}


//import UIKit
//
//
//class SemiCircleProgressBar: UIView, CAAnimationDelegate {
//
//    var animationDuration: TimeInterval?
//
//    var progress: CGFloat = 1.0 { // Value between 0.0 and 1.0
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image name
//
//    private let backgroundShape = CAShapeLayer()
//    private let backgroundGradientLayer = CAGradientLayer()
//
//    private let strokeShape = CAShapeLayer()
//    private let strokeGradientLayer = CAGradientLayer()
//
//    private var centerPoint: CGPoint = .zero
//    private var radius: CGFloat = 0.0
//    private var startAngle: CGFloat = .pi
//    private var endAngle: CGFloat = 0.0
//    private var actualEndAngle: CGFloat = 0.0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupImageView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupImageView()
//    }
//
//    private func setupImageView() {
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//        addSubview(imageView)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Clean up old layers
//        backgroundGradientLayer.removeFromSuperlayer()
//        strokeGradientLayer.removeFromSuperlayer()
//
//        radius = bounds.width / 2
//        centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 3)
//
//        startAngle = .pi   // Leftmost (180°)
//        endAngle = 0       // Rightmost (0°)
//        actualEndAngle = startAngle + (.pi * -progress) // Clockwise direction
//
//        // Background path (full semicircle)
//        let fullPath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
//        fullPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
//        fullPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
//        fullPath.close()
//
//        backgroundShape.path = fullPath.cgPath
//        backgroundShape.fillColor = UIColor.black.cgColor
//
//        backgroundGradientLayer.frame = bounds
//        backgroundGradientLayer.mask = backgroundShape
//        backgroundGradientLayer.colors = [
//            UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
//        ]
//        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
//        layer.addSublayer(backgroundGradientLayer)
//
//        // Partial stroke path
//        let partialStrokePath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: actualEndAngle,
//            clockwise: true
//        )
//        strokeShape.path = partialStrokePath.cgPath
//        strokeShape.fillColor = UIColor.clear.cgColor
//        strokeShape.strokeColor = UIColor.black.cgColor
//        strokeShape.lineWidth = 7
//
//        strokeGradientLayer.frame = bounds
//        strokeGradientLayer.mask = strokeShape
//        strokeGradientLayer.colors = [
//            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
//            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
//            UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
//            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
//            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
//        ]
//        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(strokeGradientLayer)
//
//        // ImageView setup
//        imageView.layer.removeAllAnimations()
//        imageView.layer.zPosition = 1
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//
//        // Start at leftmost point
//        let startPoint = CGPoint(
//            x: centerPoint.x + radius * cos(startAngle),
//            y: centerPoint.y + radius * sin(startAngle)
//        )
//        imageView.center = startPoint
//
//        animateImageAlongArc(path: partialStrokePath)
//    }
//
//    private func animateImageAlongArc(path: UIBezierPath) {
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = path.cgPath
//        animation.duration = animationDuration ?? 0
//        animation.calculationMode = .paced
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        animation.delegate = self
//        imageView.layer.add(animation, forKey: "arcAnimation")
//    }
//
//    // MARK: - CAAnimationDelegate Method
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            // Calculate final position
//            let angle = actualEndAngle
//           // let angle = endAngle + (.pi * -progress) // Calculate angle in radians
//            let finalPoint = CGPoint(
//                x: centerPoint.x + radius * cos(angle),
//                y: centerPoint.y + radius * sin(angle)
//            )
//            imageView.center = finalPoint
//        }
//    }
//}


//class SemiCircleProgressBar: UIView, CAAnimationDelegate {
//
//    var animationDuration: TimeInterval?
//    
//    var progress: CGFloat = 1.0 { // Value between 0.0 and 1.0
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image name
//
//    private let backgroundShape = CAShapeLayer()
//    private let backgroundGradientLayer = CAGradientLayer()
//
//    private let strokeShape = CAShapeLayer()
//    private let strokeGradientLayer = CAGradientLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupImageView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupImageView()
//    }
//
//    private func setupImageView() {
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//        addSubview(imageView)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        // Clean up old layers
//        backgroundGradientLayer.removeFromSuperlayer()
//        strokeGradientLayer.removeFromSuperlayer()
//
//        let radius = bounds.width / 2
//        let centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 3)
//
//        let startAngle: CGFloat = .pi   // Leftmost (180°)
//        let endAngle: CGFloat = 0       // Rightmost (0°)
//        let actualEndAngle: CGFloat = startAngle + (.pi * -progress) // Clockwise direction
//
//        // Background path (full semicircle)
//        let fullPath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
//        fullPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
//        fullPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
//        fullPath.close()
//
//        backgroundShape.path = fullPath.cgPath
//        backgroundShape.fillColor = UIColor.black.cgColor
//
//        backgroundGradientLayer.frame = bounds
//        backgroundGradientLayer.mask = backgroundShape
//        backgroundGradientLayer.colors = [
//            UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
//        ]
//        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
//        layer.addSublayer(backgroundGradientLayer)
//
//        // Partial stroke path
//        let partialStrokePath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: actualEndAngle,
//            clockwise: true
//        )
//        strokeShape.path = partialStrokePath.cgPath
//        strokeShape.fillColor = UIColor.clear.cgColor
//        strokeShape.strokeColor = UIColor.black.cgColor
//        strokeShape.lineWidth = 7
//
//        strokeGradientLayer.frame = bounds
//        strokeGradientLayer.mask = strokeShape
//        strokeGradientLayer.colors = [
//            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
//            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
//            UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
//            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
//            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
//        ]
//        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(strokeGradientLayer)
//
//        // ImageView setup
//        imageView.layer.removeAllAnimations()
//        imageView.layer.zPosition = 1
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//
//        // Start at leftmost point
//        let startPoint = CGPoint(
//            x: centerPoint.x + radius * cos(startAngle),
//            y: centerPoint.y + radius * sin(startAngle)
//        )
//        imageView.center = startPoint
//
//        animateImageAlongArc(path: partialStrokePath)
//    }
//
//    private func animateImageAlongArc(path: UIBezierPath) {
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = path.cgPath
//        animation.duration = animationDuration ?? 0.0
//        animation.calculationMode = .paced
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        animation.delegate = self
//        imageView.layer.add(animation, forKey: "arcAnimation")
//    }
//
// 
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//           if flag {
//               // Calculate final position
//               let radius = bounds.width / 2
//               let centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 3)
//               let angle = .pi + (-.pi * progress) // Calculate angle in radians
//               let finalPoint = CGPoint(
//                   x: centerPoint.x + radius * cos(angle),
//                   y: centerPoint.y + radius * sin(angle)
//               )
//               imageView.center = finalPoint
//           }
//       }
//   }

extension CGPath {
    var length: CGFloat {
        var length: CGFloat = 0.0
        var previousPoint: CGPoint?

        applyWithBlock { element in
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = points[0]
            case .addLineToPoint:
                if let prev = previousPoint {
                    length += hypot(points[0].x - prev.x, points[0].y - prev.y)
                }
                previousPoint = points[0]
            case .closeSubpath:
                break
            default:
                break
            }
        }
        return length
    }

    func point(at distance: CGFloat) -> CGPoint? {
        var traveled: CGFloat = 0
        var result: CGPoint?
        var previousPoint: CGPoint?

        applyWithBlock { element in
            guard result == nil else { return }
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = points[0]
            case .addLineToPoint:
                if let prev = previousPoint {
                    let segmentLength = hypot(points[0].x - prev.x, points[0].y - prev.y)
                    if traveled + segmentLength >= distance {
                        let t = (distance - traveled) / segmentLength
                        result = CGPoint(
                            x: prev.x + (points[0].x - prev.x) * t,
                            y: prev.y + (points[0].y - prev.y) * t
                        )
                        return
                    }
                    traveled += segmentLength
                }
                previousPoint = points[0]
            default:
                break
            }
        }
        return result
    }
}



