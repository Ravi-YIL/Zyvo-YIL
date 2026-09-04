//
//  Misllanious.swift
//  Tradesman
//
//  Created by satyam dwivedi on 12/07/24.
//

import Foundation
import UIKit

class SkeletonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        self.layer.cornerRadius = 4.0
        startShimmering()
    }
    
    private func startShimmering() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.75, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        gradientLayer.frame.size.width *= 1.5
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -self.bounds.width
        animation.toValue = self.bounds.width
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmer")
        self.layer.mask = gradientLayer
    }
}
extension UIView{
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    func applyRoundedBorderPhoto(radius: CGFloat? = nil, borderWidth: CGFloat = 2.0, borderColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)) {
        self.layer.cornerRadius = radius ?? (self.frame.height / 2)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
        func applyRoundedBorder(radius: CGFloat? = nil, borderWidth: CGFloat = 1.0, borderColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)) {
            self.layer.cornerRadius = radius ?? (self.frame.height / 2)
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.clipsToBounds = true
        }
        func applyLightGrayRoundedBorder(radius: CGFloat? = nil, borderWidth: CGFloat = 1.0) {
            self.layer.cornerRadius = radius ?? (self.frame.height / 2)
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.clipsToBounds = true
        }
        
        func makeCircular(borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.clipsToBounds = true
        }
    }


extension UITabBarController {
    /// Extends the size of the `UITabBarController` view frame, pushing the tab bar controller off screen.
    /// - Parameters:
    ///   - hidden: Hide or Show the `UITabBar`
    ///   - animated: Animate the change
    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard let vc = selectedViewController else { return }
        guard tabBarHidden != hidden else { return }
        
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = hidden ? height : -height
        
        UIViewPropertyAnimator(duration: animated ? 0.3 : 0, curve: .easeOut) {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            self.selectedViewController?.view.frame = CGRect(
                x: 0,
                y: 0,
                width: vc.view.frame.width,
                height: vc.view.frame.height + offsetY
            )
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
        .startAnimation()
    }
    
    // Is the tab bar currently off the screen.
    private var tabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }
}
