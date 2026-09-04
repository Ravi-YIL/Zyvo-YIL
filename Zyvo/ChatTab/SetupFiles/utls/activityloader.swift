//
//  activityloader.swift
//  Time and Task Management
//
//  Created by Raurnet solutions on 21/06/18.
//  Copyright © 2018 yesitlabs. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class indicator {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    func showActivityIndicator(uiView: UIView,Message:String = "Loading...") {
        container.frame = uiView.frame
        container.center = uiView.center
        container.frame.origin.y = 70

        container.backgroundColor = UIColor(red: 255/255, green: 255/255 , blue: 255/255, alpha: 0.2)
            //UIColorFromHex(rgbValue: 0x000000, alpha: 0.4)
        loadingView.frame = CGRect(x:0, y:0, width:160, height:120)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red:0/255, green: 23/255 , blue: 51/255, alpha: 1)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:(loadingView.frame.size.height / 2)-10);
        let messageLabel = UILabel(frame: CGRect(x:0.0, y:70, width:160, height:40.0))
        messageLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = Message
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(messageLabel)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    func showToast(message : String ,hightC:CGFloat = 35.0 ,viewC:UIView) {
        
        let toastLabel = UILabel(frame: CGRect(x: viewC.frame.size.width/2 - 75, y: viewC.frame.size.height-100, width: 150.0, height: hightC))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        viewC.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}


extension UIViewController {
    func p_loadErrorMessage(size:CGSize = CGSize(width: 150, height: 150),img:UIImage = #imageLiteral(resourceName: "no_data_found"),tag:Int = 0) -> UIImageView {
        let button = UIImageView()
        button.image = img
        button.frame.size = size
        button.tag = tag
        return button
    }
}

extension UIViewController {
  
    func ShareControllerCuston(title:String?,videoId:String,completion: @escaping (_ dict:String) -> Void) {
        
        var obj : [Any] = []
        if let d = title {
            obj.append(d)
        }
        obj.append(#imageLiteral(resourceName: "logo"))
//        let firstActivityItem = "Justdance.linking1://videoId=\(videoId)"
        let firstActivityItem = "Justdance.linking1://videoId=\(videoId)"
        http://Justdance.linking1
        
        if let secondActivityItem = URL(string: firstActivityItem) {
            obj.append(secondActivityItem)
        }
//        let image : UIImage = #imageLiteral(resourceName: "logo")
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: obj, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
