//
//  TostMsg.swift
//  Stadio
//
//  Created by YATIN  KALRA on 9/27/22.
//

import Foundation
import UIKit
//import SnackBar_swift

extension UIViewController {
    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    // status bar customize
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
//            statusBar.setValue(style == .lightContent ? ColorCompatibility.label : ColorCompatibility.systemBackground, forKey: "foregroundColor")
        }
    }
    
    func setUpStatusBar(_ color : UIColor) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
            statusBar?.alpha = 0.5

        }
    }
    
    func showAlert(for alert: String) {
        if APISessionManager.shared.isUnauthorizedAlertShowing || alert.lowercased() == "unauthorized" {
            if alert.lowercased() == "unauthorized" {
                APISessionManager.shared.handleUnauthorized()
            }
            return
        }
        guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
            let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
            return
        }
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Perform navigation when OK button is clicked
          
            if alert == "Your account has been Deactivate from the admin." || alert  == "Your account has been deleted from the admin." {
                // Example of navigation to another view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = (storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                UserDetail.shared.removeUserId()
                UserDetail.shared.removeChatToken()
                UserDetail.shared.removeKeepMeLogin()
                UserDetail.shared.removeUserType()
                UserDetail.shared.removeTokenWith()
                UserDetail.shared.removeisTimeExtend()
                UserDetail.shared.removeisCompleteProfile()
                CurrentDateTimer.shared.stopTimer()
                UserDetail.shared.removeProfileimg()
                UserDetail.shared.removeName()
                topViewController.navigationController?.pushViewController(nextVC, animated: true)
            }
            
            if alert == "Please add card" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as? AddCardVC {
                    nextVC.modalPresentationStyle = .overFullScreen // Optional: Set the presentation style
                    topViewController.present(nextVC, animated: true, completion: nil)
                }
                
            }
        }
        alertController.addAction(alertAction)
        topViewController.present(alertController, animated: true, completion: nil)
    }


//    
    static let DELAY_SHORT = 1.0
      static let DELAY_LONG = 2.0
    
    func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.alpha = 0
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image (static from assets)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconaa") // 👉 your asset name
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        view.addSubview(containerView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        // Container constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: safeArea.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        ])
        
        // Image constraints
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Label constraints
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        // Animation
        UIView.animate(withDuration: 0.4) {
            containerView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: delay, options: .curveEaseOut) {
                containerView.alpha = 0
            } completion: { _ in
                containerView.removeFromSuperview()
            }
        }
    }
////
//      func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
//          let label = ToastLabel()
//          label.backgroundColor = UIColor.black
//          label.textColor = UIColor.white
//          label.textAlignment = .center
//          label.font = UIFont.systemFont(ofSize: 15)
//          label.alpha = 0
//          label.text = text
//          label.clipsToBounds = true
//          label.layer.cornerRadius = 20
//          label.numberOfLines = 0
//          label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
//          label.translatesAutoresizingMaskIntoConstraints = false
//          view.addSubview(label)
//
//          let saveArea = view.safeAreaLayoutGuide
//          label.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor, constant: 0).isActive = true
//          label.leadingAnchor.constraint(greaterThanOrEqualTo: saveArea.leadingAnchor, constant: 15).isActive = true
//          label.trailingAnchor.constraint(lessThanOrEqualTo: saveArea.trailingAnchor, constant: -15).isActive = true
//          label.bottomAnchor.constraint(equalTo: saveArea.bottomAnchor, constant: -30).isActive = true
//
//          UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//              label.alpha = 1
//          }, completion: { _ in
//              UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
//                  label.alpha = 0
//              }, completion: {_ in
//                  label.removeFromSuperview()
//              })
//          })
//      }
    

}

class ToastLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)

        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

 
@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor1:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var startColor2:   UIColor = .black { didSet { updateColors() }}
//    @IBInspectable var startColor3:   UIColor = .black { didSet { updateColors() }}
//    @IBInspectable var startColor4:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor1:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var endColor2:     UIColor = .white { didSet { updateColors() }}
//    @IBInspectable var endColor3:     UIColor = .white { didSet { updateColors() }}
//    @IBInspectable var endColor4:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation1: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var startLocation2: Double =   0.05 { didSet { updateLocations() }}
//    @IBInspectable var startLocation3: Double =   0.05 { didSet { updateLocations() }}
//    @IBInspectable var startLocation4: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation1:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var endLocation2:   Double =   0.95 { didSet { updateLocations() }}
//    @IBInspectable var endLocation3:   Double =   0.95 { didSet { updateLocations() }}
//    @IBInspectable var endLocation4:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation1 as NSNumber, startLocation2 as NSNumber, endLocation1 as NSNumber, endLocation2 as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor1.cgColor,startColor2.cgColor, endColor1.cgColor,endColor2.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}

