////
////  CurvedProgressView.swift
////  Zyvo
////
////  Created by YATIN  KALRA on 24/03/26.
////
//
//
//
//import UIKit
//
//class CustomArcProgressView: UIView {
//    
//    private let trackLayer = CAShapeLayer()
//    private let progressLayer = CAShapeLayer()
//    private let gradientLayer = CAGradientLayer()
//    private let fillLayer = CAShapeLayer()
//    
//    private let fillGradientLayer = CAGradientLayer()
//    private let fillMaskLayer = CAShapeLayer()
//    
//    private let iconView = UIImageView()
//    
//    private var path: UIBezierPath!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    private func setup() {
//        
//        backgroundColor = .clear
//        
//        // ✅ Track
//        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineWidth = 8
//        layer.addSublayer(trackLayer)
//        
//        // ✅ Progress (used as mask)
//        progressLayer.strokeColor = UIColor.black.cgColor
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.lineWidth = 8
//        progressLayer.strokeEnd = 0
//        
//        // ✅ Gradient (exact style)
//        gradientLayer.colors = [
//            UIColor(red: 80/255, green: 210/255, blue: 160/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 120/255, blue: 0/255, alpha: 1).cgColor,
//            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
//        ]
//        
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        
//        // ✅ FILL GRADIENT (inside arc)
//        fillGradientLayer.colors = [
//            UIColor(red: 200/255, green: 235/255, blue: 220/255, alpha: 1).cgColor, // light top
//            UIColor(red: 80/255, green: 210/255, blue: 160/255, alpha: 1).cgColor   // green bottom
//        ]
//
//        fillGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // TOP
//        fillGradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0) // BOTTOM
//
//        layer.insertSublayer(fillGradientLayer, at: 0)
//
//        // mask
//        fillMaskLayer.fillColor = UIColor.black.cgColor
//        fillGradientLayer.mask = fillMaskLayer
//        
//        layer.addSublayer(gradientLayer)
//        gradientLayer.mask = progressLayer   // ✅ IMPORTANT
//        
//        // ✅ Icon
//        iconView.image = UIImage(named: "Group 1171276031")
//        iconView.frame.size = CGSize(width: 40, height: 50)
//        addSubview(iconView)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        createCurve()
//        gradientLayer.frame = bounds
//    }
//    
//    private func createCurve() {
//        
//        let width = bounds.width
//        let height = bounds.height
//        
//        let start = CGPoint(x: 0, y: height * 0.6)
//        let end = CGPoint(x: width, y: height * 0.6)
//        
//        let cp1 = CGPoint(x: width * 0.25, y: height * 0.1)
//        let cp2 = CGPoint(x: width * 0.75, y: height * 0.1)
//        
//        path = UIBezierPath()
//        path.move(to: start)
//        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
//        
//        trackLayer.path = path.cgPath
//        progressLayer.path = path.cgPath
//    }
//    
//    // ✅ MAIN PROGRESS FUNCTION
//    func setProgress(_ progress: CGFloat, animated: Bool = true) {
//        
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        
//        progressLayer.strokeEnd = progress   // gradient fill
//        moveIcon(progress: progress)         // icon move
//        
//        CATransaction.commit()
//    }
//    
//    // ✅ ICON MOVE
//    private func moveIcon(progress: CGFloat) {
//        let point = pointOnBezier(t: progress)
//        iconView.center = point
//    }
//    
//    // ✅ BEZIER POINT
//    private func pointOnBezier(t: CGFloat) -> CGPoint {
//        
//        let width = bounds.width
//        let height = bounds.height
//        
//        let start = CGPoint(x: 0, y: height * 0.6)
//        let end = CGPoint(x: width, y: height * 0.6)
//        
//        let cp1 = CGPoint(x: width * 0.25, y: height * 0.1)
//        let cp2 = CGPoint(x: width * 0.75, y: height * 0.1)
//        
//        let x = cubicBezier(t, start.x, cp1.x, cp2.x, end.x)
//        let y = cubicBezier(t, start.y, cp1.y, cp2.y, end.y)
//        
//        return CGPoint(x: x, y: y)
//    }
//    
//    private func cubicBezier(_ t: CGFloat, _ p0: CGFloat, _ p1: CGFloat, _ p2: CGFloat, _ p3: CGFloat) -> CGFloat {
//        let mt = 1 - t
//        return mt*mt*mt*p0 + 3*mt*mt*t*p1 + 3*mt*t*t*p2 + t*t*t*p3
//    }
//}



import UIKit

class CustomArcProgressView: UIView {
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    private let gradientLayer = CAGradientLayer()        // stroke gradient
    private let fillGradientLayer = CAGradientLayer()    // inside fill
    private let fillMaskLayer = CAShapeLayer()
    
    private var currentProgress: CGFloat = 0
    
    private let curveHeight: CGFloat = -0.15   //
    
    private let iconView = UIImageView()
    
    private var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        // ✅ TRACK
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 8
        layer.addSublayer(trackLayer)
        
        // ✅ PROGRESS (mask for gradient stroke)
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 8
        progressLayer.strokeEnd = 0
        
        // ✅ STROKE GRADIENT (green → yellow → red)
        gradientLayer.colors = [
            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
            UIColor(red: 209/255, green: 254/255, blue: 55/255, alpha: 1).cgColor,
            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.addSublayer(gradientLayer)
        // Gradient as full stroke
        let strokeMask = CAShapeLayer()
        strokeMask.strokeColor = UIColor.black.cgColor
        strokeMask.fillColor = UIColor.clear.cgColor
        strokeMask.lineWidth = 8
        strokeMask.lineCap = .round   // ✅ FIX
        gradientLayer.mask = strokeMask
        

        // ✅ FILL GRADIENT (inside arc - like image)
            fillGradientLayer.colors = [
               // UIColor.white.withAlphaComponent(0.00025).cgColor,
                UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.65).cgColor, // light top
                UIColor(red: 80/255, green: 210/255, blue: 160/255, alpha: 1).cgColor  // green bottom
            ]
        
       fillGradientLayer.locations = [0.0, 0.85, 1.0]
            
        fillGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        fillGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.insertSublayer(fillGradientLayer, at: 0)
        
        fillMaskLayer.fillColor = UIColor.black.cgColor
        fillGradientLayer.mask = fillMaskLayer
        
        // ✅ GLOSSY SHINE
        let shine = CAGradientLayer()
        shine.colors = [
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        shine.startPoint = CGPoint(x: 0.5, y: 0)
        shine.endPoint = CGPoint(x: 0.5, y: 1)
        
        fillGradientLayer.addSublayer(shine)
        
        // ✅ ICON
        iconView.image = UIImage(named: "Group 1171276031")
        iconView.frame.size = CGSize(width: 30, height: 40)
        addSubview(iconView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        createCurve()
          
          gradientLayer.frame = bounds
          fillGradientLayer.frame = bounds
          fillGradientLayer.sublayers?.first?.frame = bounds
          
          // ALWAYS stay at correct position
          moveIcon(progress: currentProgress)
    }
    
    private func createCurve() {
        
        let width = bounds.width
        let height = bounds.height
        
        let start = CGPoint(x: 0, y: height * 0.6)
        let end = CGPoint(x: width, y: height * 0.6)
        
        let cp1 = CGPoint(x: width * 0.25, y: height * curveHeight)
        let cp2 = CGPoint(x: width * 0.75, y: height * curveHeight)
        
        // CURVE PATH
        path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        
        // CLOSED SHAPE (for fill)
        let fillPath = UIBezierPath()
        fillPath.move(to: start)
        fillPath.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        fillPath.addLine(to: CGPoint(x: width, y: height))
        fillPath.addLine(to: CGPoint(x: 0, y: height))
        fillPath.close()
        
        // Apply path to gradient mask (FULL stroke always visible)
        if let mask = gradientLayer.mask as? CAShapeLayer {
            mask.path = path.cgPath
        }
        
        fillMaskLayer.path = fillPath.cgPath
    }
    

    func setInitialProgress(_ progress: CGFloat) {
        
        currentProgress = progress
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        progressLayer.strokeEnd = progress
        moveIcon(progress: progress)
        
        CATransaction.commit()
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool = true) {
        
        currentProgress = progress   // ✅ store
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        moveIcon(progress: progress)
        
        CATransaction.commit()
    }

    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        DispatchQueue.main.async {
            self.moveIcon(progress: self.currentProgress)
        }
    }
    // ✅ ICON MOVE
    private func moveIcon(progress: CGFloat) {
        let point = pointOnBezier(t: progress)
       // print(progress,"At Icon moving")
        iconView.center = point
    }
    
    // ✅ BEZIER POINT
    private func pointOnBezier(t: CGFloat) -> CGPoint {
        
        let width = bounds.width
        let height = bounds.height
        
        let start = CGPoint(x: 0, y: height * 0.6)
        let end = CGPoint(x: width, y: height * 0.6)

       // let curveHeight: CGFloat = -0.3   // 👈 change this value

        let cp1 = CGPoint(x: width * 0.25, y: height * curveHeight)
        let cp2 = CGPoint(x: width * 0.75, y: height * curveHeight)
        
        let x = cubicBezier(t, start.x, cp1.x, cp2.x, end.x)
        let y = cubicBezier(t, start.y, cp1.y, cp2.y, end.y)
        
        return CGPoint(x: x, y: y)
    }
    
    private func cubicBezier(_ t: CGFloat, _ p0: CGFloat, _ p1: CGFloat, _ p2: CGFloat, _ p3: CGFloat) -> CGFloat {
        let mt = 1 - t
        return mt*mt*mt*p0 + 3*mt*mt*t*p1 + 3*mt*t*t*p2 + t*t*t*p3
    }
}
