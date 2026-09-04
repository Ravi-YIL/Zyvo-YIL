//
//  GeneralExtensions.swift
//  Template
//
//  Created by Chandra_Mobiloitte on 15/06/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

let imageCache1 = NSCache<AnyObject, AnyObject>()

//MARK: - NSMutable data extension

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        // check for cache
        if let cachedImage = imageCache1.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = cachedImage
            return
        }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                     self.image = UIImage(named: "mapLocation")
                }
               
                return
            }
            DispatchQueue.main.async { () -> Void in
                imageCache1.setObject(image, forKey: url.absoluteString as AnyObject)
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
     
        
       // let url = NSURL(string: urlstring)
        
        let url1 = "http://maps.apple.com/maps?saddr=\("19.4354778"),\("-99.1364789")"
     //   UIApplication.shared.openURL(URL(string:url)!)

          
        guard let url = NSURL(string: url1)
            else {
                
                return
                
        }
        
        downloadedFrom(url: url as URL, contentMode: mode)
    }
}

// MARK: - NSUserDefaults Extensions >>>>>>>>>>>>>>>>>>>>>>

extension UserDefaults {
    func colorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
}

//MARK: - UIImage Extensions>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//extension UIImage {
//    func maskWithColor(_ color: UIColor) -> UIImage? {
//        let maskImage = cgImage
//        let width = size.width
//        let height = size.height
//        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
//        bitmapContext!.clip(to: bounds, mask: maskImage!)
//        bitmapContext!.setFillColor(color.cgColor)
//        bitmapContext!.fill(bounds) //is it nil?
//        if let cImage = bitmapContext!.makeImage() {
//            let coloredImage = UIImage(cgImage: cImage)
//            return coloredImage
//        } else {
//            return nil
//        }
//    }
//    
//}

// MARK: - Array Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Array {
    func contains<T>(_ obj: T) -> Bool where T: Equatable {
        return filter({ $0 as? T == obj }).count > 0
    }
}

// MARK: - Dictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Dictionary {
    mutating func unionInPlace(_ dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    mutating func unionInPlace<S: Sequence>(_ sequence: S) where S.Iterator.Element == (Key, Value) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        // checking if in case object is nil
        
        if let object = self[key] as? AnyObject {
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber, expected is String {
                return "\(object)" as AnyObject
            } else if object is NSNumber, expected is Float {
                return object.floatValue as AnyObject
            } else if object is NSNumber, expected is Double {
                return object.doubleValue as AnyObject
            } else if object.isKind(of: expected.classForCoder) == false {
                return expected
            } else if object is String {
                if (object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)") {
                    return "" as AnyObject
                }
            }
            return object
        } else {
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            
            return expected
        }
    }
}

// MARK: - NSDictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension NSDictionary {
    func objectForKeyNotNull(_ key: AnyObject, expected: AnyObject?) -> AnyObject {
        // checking if in case object is nil
        if let object = self.object(forKey: key) {
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber, expected is String {
                //logInfo("case we are getting number from server but we want a string from it")
                return "\(object)" as AnyObject
            } else if (object as AnyObject).isKind(of: (expected?.classForCoder)!) == false {
                //logInfo("case // checking if object is of desired class....not")
                return expected!
            } else if object is String {
                if (object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)") {
                    //logInfo("null string")
                    return "" as AnyObject
                }
            }
            return object as AnyObject
            
        } else {
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            return expected!
        }
    }
    
    func objectForKeyNotNull(_ key: AnyObject) -> AnyObject {
        let object = self.object(forKey: key)
        
        if object is NSNull {
            return "" as AnyObject
        }
        
        if object == nil {
            return "" as AnyObject
        }
        
        if object is NSString {
            if (object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)") {
                return "" as AnyObject
            }
        }
        return object! as AnyObject
    }
    
    func objectForKeyNotNullExpectedObj(_ key: AnyObject, expectedObj: AnyObject) -> AnyObject {
        let object = self.object(forKey: key)
        
        if object is NSNull {
            return expectedObj
        }
        
        if object == nil {
            return expectedObj
        }
        
        if ((object as AnyObject).isKind(of: expectedObj.classForCoder)) == false {
            return expectedObj
        }
        
        return object! as AnyObject
    }
}



// MARK: - UISlider Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UISlider {
    @IBInspectable var thumbImage: UIImage {
        get {
            return self.thumbImage(for: UIControl.State())!
        }
        set {
            setThumbImage(thumbImage, for: UIControl.State())
        }
    }
}

// MARK: - NSURL Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension URL {
    func isValid() -> Bool {
        if UIApplication.shared.canOpenURL(self) == true {
            return true
        } else {
            return false
        }
    }
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    
}

// MARK: - NSDate Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Date {
    func timestamp() -> String {
        return "\(timeIntervalSince1970)"
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func timeString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "hh:mm a"
          return dateFormatter.string(from: self)
      }
   
    func dateStringFromDate(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func timeStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: self)
    }
    
    func DateStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func onlyTimeStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: self)
    }
    
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    func minutesFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    
    func secondsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date) > 0 { return "\(yearsFrom(date))y" }
        if monthsFrom(date) > 0 { return "\(monthsFrom(date))M" }
        if weeksFrom(date) > 0 { return "\(weeksFrom(date))w" }
        if daysFrom(date) > 0 { return "\(daysFrom(date))d" }
        if hoursFrom(date) > 0 { return "\(hoursFrom(date))h" }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

// Usage

/*
 let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 
 let years = date2.yearsFrom(date1)     // 0
 let months = date2.monthsFrom(date1)   // 9
 let weeks = date2.weeksFrom(date1)     // 39
 let days = date2.daysFrom(date1)       // 273
 let hours = date2.hoursFrom(date1)     // 6,553
 let minutes = date2.minutesFrom(date1) // 393,180
 let seconds = date2.secondsFrom(date1) // 23,590,800
 
 let timeOffset = date2.offsetFrom(date1) // "9M"
 
 let date3 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 let date4 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 
 let timeOffset2 = date4.offsetFrom(date3) // "1y"
 
 let timeOffset3 = NSDate().offsetFrom(date3) // "54m"
 */

// MARK: - UIViewController Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UIViewController {
    func backViewController() -> UIViewController? {
        if let stack = self.navigationController?.viewControllers {
            for count in 0...stack.count - 1 {
                if stack[count] == self {
                    //     logInfo("viewController     \(stack[count-1])")
                    
                    return stack[count - 1]
                }
            }
        }
        return nil
    }
    
    // Check selected date with current date and return value by which we can know that the time is passed by more than one minute
    func checkForPassedDate(dateString: String, timeString: String) -> Bool {
        let newDateString = "\(dateString) \(timeString)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let date = dateFormatter.date(from: newDateString)
        guard let passedDate = date else { return false }
        if passedDate == Date() {
            return true
        }
        else if passedDate < Date() {
            return true
        }
        else{
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to:passedDate );
            
            if (difference.minute! <= 30) {
                return true
            } else {
                return false
            }
        }
    }
    
}

// MARK: - Int/Float/Double Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Int {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)d" as NSString, self) as String
    }
}

extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension Float {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

//extension Character {
//    func isEmoji() -> Bool {
//        let primary:UInt32 = 0x8BC34AFF
//        return Character(_:UnicodeScalar(primary)!) <= self && self <= Character(_:UnicodeScalar (0x1f77f ))
//            || Character(UnicodeScalar(0x8BC34AFF as UInt32)!) <= self && self <= Character(UnicodeScalar(0x26ff))
//    }
//}

//extension String {
//    func stringByRemovingEmoji() -> String {
//        return String(filter(self, {c in !c.isEmoji()}))
//    }
//}

//MARK: - Date Extension

extension Date {
    var millisecondsSince1970: Int {
        return Int(timeIntervalSince1970.rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 { return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago" }
        if months(from: date) > 0 { return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago" }
        if weeks(from: date) > 0 { return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago" }
        if days(from: date) > 0 { return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago" }
        if hours(from: date) > 0 { return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago" }
        if minutes(from: date) > 0 { return minutes(from: date) > 1 ? "\(minutes(from: date))" : "\(minutes(from: date))" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) secs ago" }
        return ""
    }
}

 

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }
}

//public extension UITextField {
//    func useUnderline() {
//        let border = CALayer()
//        let borderWidth = CGFloat(1.0)
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(origin: CGPoint(x: 0, y: frame.size.height - borderWidth), size: CGSize(width: frame.size.width, height: frame.size.height))
//        border.borderWidth = borderWidth
//        layer.addSublayer(border)
//        layer.masksToBounds = true
//    }
    
//    func makeUnderlineInvisible() {
//        let border = CALayer()
//        let borderWidth = CGFloat(1.0)
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(origin: CGPoint(x: 0, y: frame.size.height - borderWidth), size: CGSize(width: frame.size.width, height: frame.size.height))
//        border.borderWidth = borderWidth
//        layer.addSublayer(border)
//        layer.masksToBounds = true
//    }
//    
//    func makeUnderLineRed() {
//        let border = CALayer()
//        let borderWidth = CGFloat(1.0)
//        border.borderColor = UIColor.red.cgColor
//        border.frame = CGRect(origin: CGPoint(x: 0, y: frame.size.height - borderWidth), size: CGSize(width: frame.size.width, height: frame.size.height))
//        border.borderWidth = borderWidth
//        layer.addSublayer(border)
//        layer.masksToBounds = true
//    }
//}

extension UIButton {
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        setAttributedTitle(titleString, for: .normal)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


extension UIWindow {
//    static var currentController: UIViewController? {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        return appDelegate?.window?.currentController
//    }
//
//    var currentController: UIViewController? {
//        if let vc = self.rootViewController {
//            return getCurrentController(vc)
//        }
//        return nil
//    }
    
    func getCurrentController(_ vc: UIViewController) -> UIViewController {
        if let pc = vc.presentedViewController {
            return getCurrentController(pc)
        } else if let nc = vc as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return getCurrentController(nc.viewControllers.last!)
            } else {
                return nc
            }
        } else {
            return vc
        }
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}



extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

 
