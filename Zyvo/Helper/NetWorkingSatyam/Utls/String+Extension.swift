//
//  String+Extension.swift
//  Heavenly_Ravi_YesITLabs
//
//  Created by ravi on 13/12/22.
//


import Foundation
import UIKit

extension String {
    
    var removeSpaces:String{
            return self.replacingOccurrences(of: " ", with: "")
        }
    
    func replace(string: String, withString: String) -> String
       {
           return self.replacingOccurrences(of: string, with: withString, options: String.CompareOptions.literal, range: nil)
       }
    
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
      let unreserved = "*-._"
      let allowed = NSMutableCharacterSet.alphanumeric()
      allowed.addCharacters(in: unreserved)

      if plusForSpace {
        allowed.addCharacters(in: " ")
      }

      var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
      if plusForSpace {
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
      }
      return encoded
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
    static func getHighletedSubString(firstString : String, secondString: String ) -> NSMutableAttributedString {
        
        
        var attributes1 = [NSAttributedString.Key: AnyObject]()
        
//        attributes1[.foregroundColor] = ColorCompatibility.label
        attributes1[.font] = UIFont.systemFont(ofSize: 12, weight: .bold)

        var attributes2 = [NSAttributedString.Key: AnyObject]()
        
        attributes2[.foregroundColor] = UIColor.gray
        
        
        let attributedString1 = NSAttributedString(string: firstString,
                                                   attributes: attributes1)
        let attributedString2 = NSAttributedString(string: secondString,
                                                   attributes: attributes2)
        let combination = NSMutableAttributedString()
        
        combination.append(attributedString1)
        combination.append(attributedString2)
        
        return combination
    }
    
    
//    var isValidEmail: Bool {
//        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
//        return testEmail.evaluate(with: self)
//    }
//    var isValidPhone: Bool {
//        let regularExpressionForPhone = "^[7-9][0-9]{9}$"
//        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
//        return testPhone.evaluate(with: self)
//    }
//    
//    var isNumeric : Bool {
//        return Int(self) != nil
//    }
    
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

func normal(_ value:String) -> NSMutableAttributedString {
    
    let attributes:[NSAttributedString.Key : Any] = [
        .font : normalFont,
    ]
    
    self.append(NSAttributedString(string: value, attributes:attributes))
    return self
}
/* Other styling methods */
func orangeHighlight(_ value:String) -> NSMutableAttributedString {
    
    let attributes:[NSAttributedString.Key : Any] = [
        .font :  normalFont,
        .foregroundColor : UIColor.white,
        .backgroundColor : UIColor.orange
    ]
    
    self.append(NSAttributedString(string: value, attributes:attributes))
    return self
}

func blackHighlight(_ value:String) -> NSMutableAttributedString {
      
      let attributes:[NSAttributedString.Key : Any] = [
          .font :  normalFont,
          .foregroundColor : UIColor.white,
          .backgroundColor : UIColor.black
          
      ]
      
      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }
  
  func underlined(_ value:String) -> NSMutableAttributedString {
      
      let attributes:[NSAttributedString.Key : Any] = [
          .font :  normalFont,
          .underlineStyle : NSUnderlineStyle.single.rawValue
          
      ]
      
      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
  }
}
extension String {
    
    var isNumeric: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
    
    
    var ismobile: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isPasswordValid() -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,15}")
        
        return passwordTest.evaluate(with: self)
    }
    func isValidPhone() -> Bool {
        if self.count > 8 || self.count < 12 {
            return true
        }else { return false
        }
    }

    }

    extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for (index, title) in actionTitles.enumerated() {
        let action = UIAlertAction(title: title, style: .default, handler: actions[index])
        alert.addAction(action)
    }
    self.present(alert, animated: true, completion: nil)
    }
}
//extension UINavigationController {
//  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
//    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
//      popToViewController(vc, animated: animated)
//    }
//  }
//}

