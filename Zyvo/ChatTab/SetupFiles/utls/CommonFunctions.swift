//
//  CommonClasses.swift
//  DittoFashionMarketBeta
//
//  Created by Bhavneet Singh on 23/11/17.
//  Copyright © 2017 Bhavneet Singh. All rights reserved.
//

import UIKit
//import SKToast
import NVActivityIndicatorView
import MobileCoreServices

class CommonFunctions {

    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, displayTime: TimeInterval = 3, completion: (() -> Swift.Void)? = nil) {

        DispatchQueue.main.async {
//            SKToast.backgroundStyle(UIBlurEffect.Style.dark)
//            SKToast.messageFont(AppFonts.Nunito_Regular.withSize(16))
//            SKToast.displayTime(displayTime)
//
//            SKToast.messageTextColor(AppColors.whiteColor)
//            SKToast.show(withMessage: msg, completionHandler: {
//                completion?()
//            })
        }
    }
    
    /// Delay Functions
    class func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
            
        }
    }
    
    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertActionArray.forEach{ alert.addAction($0) }
        
        DispatchQueue.main.async {
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    /// Show Activity Loader
    class func showActivityLoader() {
//        DispatchQueue.main.async {
//            if #available(iOS 13.0, *) {
//                if let windowObj = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first {
//
//                  //  windowObj.rootViewController?.startNYLoader()
//
//                }
//            } else {
//                if let vc = AppDelegate.shared.window?.rootViewController {
//                    vc.startNYLoader()
//                }
//            }
//
////            if let vc = AppDelegate.shared.window?.rootViewController {
////                vc.startNYLoader()
////            }
//        }
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
//        DispatchQueue.main.async {
//            if #available(iOS 13.0, *) {
//                if let windowObj = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first {
//                    //windowObj.rootViewController?.stopAnimating()
//                }
//            } else {
//                if let vc = AppDelegate.shared.window?.rootViewController {
//                    vc.stopAnimating()
//                }
//            }
////            if let vc = AppDelegate.shared.window?.rootViewController {
////                vc.stopAnimating()
////            }
//        }
    }

    // MARK: - Helper Methods
    @available(iOS 13.0, *)
    func getKeyWindow() -> UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return window
    }
}
