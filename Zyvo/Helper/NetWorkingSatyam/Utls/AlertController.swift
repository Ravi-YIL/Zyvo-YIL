
//  AlertController.swift
//  FansKick
//
//  Created by FansKick-Raj on 11/10/2017.
//  Copyright © 2017 FansKick Dev. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import SystemConfiguration
 

open class AlertController {
    
    // MARK: - Singleton
    
    static let instance = AlertController()
    
    // MARK: - Private Functions
    
    fileprivate func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            //print("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    // MARK: - Class Functions
    
    open class func alert(title: String) {
        return alert(title: title, message: "")
    }
    
    open class func alert(message: String) {
        return alert(title: "", message: message)
    }
    
    open class func alert(title: String, message: String) {
        
        return alert(title: title, message: message, acceptMessage: "OK") { () -> () in
            // Do nothing
        }
    }
    
    open class func alert(title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) {
        
        DispatchQueue.main.async(execute: {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
                acceptBlock()
            })
            
            alert.addAction(acceptButton)
            
            instance.topMostController()?.present(alert, animated: true, completion: nil)
            //return alert
        })
    }
    
    open class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        
       
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
           // alert.view.tintColor = RGBA(r: 39, g: 192, b: 146, a: 1)
            //alert.view.tintColor = RGBA(39, g: 192, b: 146, a: 1)
            instance.topMostController()?.present(alert, animated: true, completion: nil)
            //return alert
        })

    }
    
    open class func actionSheet(title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
            for action in actions {
                alert.addAction(action)
            }
            
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.topMostController()?.present(alert, animated: true, completion: nil)
            //return alert
        })
    }
    
    open class func actionSheet(title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.topMostController()?.present(alert, animated: true, completion: nil)
            //return alert
        })
    }
    
}


private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            //self.view.tintColor = UIColor.RGB(r: 33, g: 128, b: 188)
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
//enum AlertMessages: String {
//
//    case enterPassword = "Please enter old password"
//    case passwordcount = "Password must be at least 8 characters long, contain at least one number, one special character and have a mixture of uppercase and lowercase letters."
//   // case loginPassword = "Password must be at least 8 characters long, contain at least one number and have a mixture of uppercase and lowercase letters."
//    case newPassword = "Please enter new password"
//    case confirmPassword = "Please enter confirm password"
//    case passwordNotMatch = "Password does not match"
//
//
//}

extension UIViewController{
    func showOkAlertWithHandler(_ msg: String, handler: @escaping ()->Void){
           if self is UIAlertController || self.presentedViewController is UIAlertController {
               print("showOkAlertWithHandler skipped: Alert already presented")
               return
           }
           let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) { (type) -> Void in
               handler()
           }
           alert.addAction(okAction)
           present(alert, animated: true, completion: nil)
       }
    
    func AlertControllerOnr1(title:String?,message:String?,BtnTitle:String = "OK") {
          if APISessionManager.shared.isUnauthorizedAlertShowing || self is UIAlertController || self.presentedViewController is UIAlertController {
              print("AlertControllerOnr1 skipped: Alert already presented or unauthorized alert showing")
              return
          }
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
          let tit : UIAlertAction = UIAlertAction(title: BtnTitle, style: UIAlertAction.Style.default) { (result) in
              print(result.title!)
          }
          alert.addAction(tit)
          self.present(alert, animated: true, completion:   nil)
      }
    
    func AlertControllerOnr(title:String?,message:String?,BtnTitle:String = "OK") {
          if APISessionManager.shared.isUnauthorizedAlertShowing || self is UIAlertController || self.presentedViewController is UIAlertController {
              print("AlertControllerOnr skipped: Alert already presented or unauthorized alert showing")
              return
          }
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
          let tit : UIAlertAction = UIAlertAction(title: BtnTitle, style: UIAlertAction.Style.default) { (result) in
              print(result.title!)
              
              if title == "Your account has been Deactivate from the admin."{
                  // Assuming you are using a UINavigationController and you want to navigate to another view controller
                   let nextVC = LoginVC() // Replace with your view controller initialization
                  
                  self.navigationController?.pushViewController(nextVC, animated: true)
              }
              
          }
          alert.addAction(tit)
          self.present(alert, animated: true, completion:   nil)
      }
    func pavan_checkAlphabet(Str:String) -> Bool {
           let emailRegEx = "[A-Za-z]"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           print(emailTest.evaluate(with: Str))
           if !emailTest.evaluate(with: Str) {
               return false
           }
           return true
       }


     func pavan_checkNumberOrAlphabet(Str:String) -> Bool {
          
           let emailRegEx = "[0-9+]"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           print(emailTest.evaluate(with: Str))
           if !emailTest.evaluate(with: Str) {
               return false
           }
           return true
       }
    
}
//
extension UIViewController {
   func showIndicator(withTitle title: String, and Description:String) {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      Indicator.isUserInteractionEnabled = false
      Indicator.detailsLabel.text = Description
       Indicator.bezelView.style = .solidColor
       Indicator.contentColor = UIColor.orange//UIColor.black
       Indicator.bezelView.color = .clear
      Indicator.show(animated: true)
   }
    // To call.
    //showIndicator(withTitle: "", and: "fetching details")
   func hideIndicator() {
      MBProgressHUD.hide(for: self.view, animated: true)
   }
    
    
    func showIndicator2(withTitle title: String, and Description:String) {
       let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
       Indicator.label.text = title
       Indicator.isUserInteractionEnabled = false
       Indicator.detailsLabel.text = Description
        Indicator.bezelView.style = .solidColor
        Indicator.bezelView.color = .clear
       Indicator.show(animated: true)
    }
     // To call.
     //showIndicator(withTitle: "", and: "fetching details")
    func hideIndicator2() {
       MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // for image loader.
    func ImageshowIndicator(withTitle title: String, and Description:String, view: UIView) {
       let Indicator = MBProgressHUD.showAdded(to: view, animated: true)
       Indicator.label.text = title
       Indicator.isUserInteractionEnabled = false
       Indicator.detailsLabel.text = Description
        Indicator.bezelView.style = .solidColor
        Indicator.contentColor = UIColor.purple//UIColor.black
        Indicator.bezelView.color = .clear
       Indicator.show(animated: true)
    }
     // To call.
     //showIndicator(withTitle: "", and: "fetching details")
    func ImagehideIndicator(view: UIView) {
       MBProgressHUD.hide(for: view, animated: true)
    }
    

}

extension UITextView {

    public class PlaceholderLabel: UILabel { }

    public var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.2)
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}
extension UIViewController{
    func isConnectedToNetwork() -> Bool {
           
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }
           
           var flags = SCNetworkReachabilityFlags()
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
               return false
           }
           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)
           
           return (isReachable && !needsConnection)
       }
       
       func showAlert() {
           if !isConnectedToNetwork() {
            AlertControllerOnr(title: "Warning", message: "Something went wrong. Make sure wifi or cellular data is turned on.")
           }
       }
}

extension Int {
    static func parse(from string: String) -> Int? {
        Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension UIViewController {
    static func parseToInt(from string: String) -> Int? {
        Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}


extension UIViewController{
    func shortenText(_ text: String, maxLength: Int) -> String {
        if text.count <= maxLength {
            return text // If the text is already within the limit, no changes needed.
        }

        let ellipsis = "…" // The character to represent omitted text.
        
        // Calculate how many characters to keep from the start and end, leaving room for the ellipsis.
        let keepFromStart = (maxLength - ellipsis.count) / 2
        let keepFromEnd = maxLength - keepFromStart - ellipsis.count

        // Construct the shortened text.
        let shortenedText = String(text.prefix(keepFromStart)) + ellipsis + String(text.suffix(keepFromEnd))

        return shortenedText
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
 

extension UIViewController{
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String, phone: String) -> String {
        var result = ""
        var numbers = ""
        if phone.count == 1{
            numbers = "1 "+phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        }else{
            numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        }
            //            var result = ""
            var index = numbers.startIndex // numbers iterator
            
            // iterate over the mask characters until the iterator of numbers ends
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    // mask requires a number in this place, so take the next one
                    //                if numbers.count == 1{
                    //                    result.append("+1 \(numbers[index])")
                    //                }else{
                    result.append(numbers[index])
                    //}
                    // move numbers iterator to the next index
                    index = numbers.index(after: index)
                    
                } else {
                    result.append(ch) // just append a mask character
                }
            }
            return result
        }

    
    func getMaskedNumber(formattedPhoneNumber: String) -> String {
        return formattedPhoneNumber.replacingOccurrences(of: "[0-9]", with: "X", options: .regularExpression, range: nil)
    }
}
 
