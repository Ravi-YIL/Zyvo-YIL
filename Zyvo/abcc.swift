//
//  abcc.swift
//  Zyvo
//
//  Created by ravi on 29/10/24.
//

import UIKit
import KDCircularProgress

class CircularSliderViewController: UIViewController {
    
    private var circularProgress: KDCircularProgress!
    private var thumbView: UIView!
    private var hoursLabel: UILabel!
    private let maxHours = 24 // Max hours displayed on the slider (e.g., 12 hours)
    private var currentProgress: Double = 0.00 // Initial progress, set to 3 hours (0.25 of 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCircularProgress()
        setupThumbView()
        setupHoursLabel()
        updateThumbPosition()
    }
    
    private func setupCircularProgress() {
        circularProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        circularProgress.startAngle = -360
        circularProgress.progressThickness = 0.3
        circularProgress.trackThickness = 0.3
        circularProgress.clockwise = true
        circularProgress.gradientRotateSpeed = 2
        circularProgress.roundedCorners = true
        circularProgress.trackColor = UIColor.lightGray
        circularProgress.progressColors = [UIColor.systemGreen]
        circularProgress.center = view.center
        circularProgress.angle = currentProgress * 360 // Set initial progress (e.g., 3 hours)
        view.addSubview(circularProgress)
        
        // Add gesture recognizer to circular progress
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        circularProgress.addGestureRecognizer(panGesture)
    }
    
    private func setupThumbView() {
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = 12
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOpacity = 0.3
        thumbView.layer.shadowRadius = 4
        thumbView.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.addSubview(thumbView)
    }
    
    private func setupHoursLabel() {
        hoursLabel = UILabel()
        hoursLabel.text = "\(Int(currentProgress * Double(maxHours))) Hours"
        hoursLabel.textAlignment = .center
        hoursLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hoursLabel)
        
        // Center the hours label within the circular progress view
        NSLayoutConstraint.activate([
            hoursLabel.centerXAnchor.constraint(equalTo: circularProgress.centerXAnchor),
            hoursLabel.centerYAnchor.constraint(equalTo: circularProgress.centerYAnchor)
        ])
    }
    
    private func updateThumbPosition() {
        let angleInRadians = CGFloat(circularProgress.angle) * CGFloat.pi / 180
        let thumbRadius = circularProgress.frame.width / 2
        let thumbX = circularProgress.center.x + thumbRadius * cos(angleInRadians)
        let thumbY = circularProgress.center.y + thumbRadius * sin(angleInRadians)
        thumbView.center = CGPoint(x: thumbX, y: thumbY)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        let dx = location.x - circularProgress.center.x
        let dy = location.y - circularProgress.center.y
        var angle = atan2(dy, dx) * 360 / CGFloat.pi + 90 // Adjust for -90 start angle
        
        // Keep angle within [0, 360]
        if angle < 0 { angle += 360 }
        circularProgress.angle = angle
        updateThumbPosition()
        
        // Calculate hours from angle
        let hours = Int((angle / 360) * Double(maxHours))
        hoursLabel.text = "\(hours) Hours"
    }
}
