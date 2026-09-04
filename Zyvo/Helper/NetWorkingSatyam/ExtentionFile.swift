//
//  ExtentionFile.swift
//  MyAirSpa_YesITLabs
//
//  Created by YATIN  KALRA on 13/12/23.
//

import Foundation
import UIKit
import AVKit
import SDWebImage
import Combine
import QuartzCore
import AVFoundation

class alertTitle {
    static let alert_success = "Success"
    static let alert_error = "Error"
    static let alert_warning = "Warning"
    static let alert_alert = "Alert"
    static let alert_message = "Message"
}

extension UIView {
    func addRoundedBorder(color: UIColor, thickness: CGFloat, cornerRadius: CGFloat) {
          layer.borderColor = color.cgColor
          layer.borderWidth = thickness
          layer.cornerRadius = cornerRadius
          layer.masksToBounds = true
      }
}

extension String {
    
    var convert_to_string:String? {
        var link  = self.replacingOccurrences(of: " ", with: "%20")
        return link.replacingOccurrences(of: "\"", with: "%22")
        
    }
    
    var flagEmoji: String {
        return self.unicodeScalars.reduce("") {
            guard let scalar = UnicodeScalar(127397 + $1.value) else { return $0 }
            return $0 + String(scalar)
        }
    }
  
}

extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension ?? ""
    }
    func fileNameWithExtension() -> String {
        let pn = self.fileName()
        let En = self.fileExtension()
        return  "\(pn).\(En)"
        //        let nameStr = URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
        //        let extensionStr = URL(fileURLWithPath: self).pathExtension
        //        return  "\(nameStr).\(extensionStr)"
    }
    
    
    
}


extension UIImageView {
    
    
        func loadImages(from url: URL) {
            // Clear current image
            self.image = nil
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Could not get image data")
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
    
    
    func loadImage(from url: String?, placeholder: UIImage? = nil, indicator: SDWebImageActivityIndicator = .grayLarge) {
        // Set up the loading indicator
        self.sd_imageIndicator = indicator
        let url = (url ?? "")//AppURL.imageURL + (url ?? "")
        
        // Load the image from the URL
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .highPriority, completed: { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else {
                print("Image loaded successfully from URL: \(url?.absoluteString ?? "unknown")")
            }
        })
    }
    func loadImage(from url: URL?, placeholder: UIImage? = nil, indicator: SDWebImageActivityIndicator = .grayLarge) {
        // Set up the loading indicator
        self.sd_imageIndicator = indicator
    
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .highPriority, completed: { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else {
                print("Image loaded successfully from URL: \(url?.absoluteString ?? "unknown")")
            }
        })
    }
    
}
extension NSObject {
    func formatPhoneNumberToNormal(_ phoneNumber: String) -> String {
        let strippedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Remove country code if present
        if strippedPhoneNumber.count >= 11 {
            let startIndex = strippedPhoneNumber.index(strippedPhoneNumber.startIndex, offsetBy: 1)
            let endIndex = strippedPhoneNumber.endIndex
            let finalNumber = String(strippedPhoneNumber[startIndex..<endIndex])
            return finalNumber
        } else {
            return strippedPhoneNumber
        }
    }
    func printModelAsJSON<T: Codable>(_ model: T,para:[String:Any]?) {
#if DEBUG
        print("============================Parameter==================")
        print(para ?? [:])
        print("============================Response==================")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(model)

            // Print the JSON as a string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("\(jsonString)")
            }
        } catch {
            print("Error encoding model to JSON: \(error)")
        }
#endif
    }
    
    func convertModelToJsonString<T: Codable>(_ model: T?) -> String?{
        guard let model = model else {
            print("Exit from gaurd")
            return ""
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(model)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
              print(jsonString)
              return jsonString
                
            }
        } catch {
            print("Error encoding intervals to JSON: \(error)")
            return ""
        }
        return ""
    }


}
extension URL {
    func getThumbnailImageFromVideoUrl1(completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: self) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    let img:UIImage = #imageLiteral(resourceName: "fullimage")
                    completion(img) //11
                }
            }
        }
    }
}

extension UIView {
    func addDynamicCornerAndShadow(cornerRadii: CGSize, maskedCorners: CACornerMask, shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
      
        let cornerRadius = min(bounds.width, bounds.height) / 2.0

        var rectCorners: UIRectCorner = []
        if maskedCorners.contains(.layerMinXMinYCorner) {
            rectCorners.insert(.topLeft)
        }
        if maskedCorners.contains(.layerMaxXMinYCorner) {
            rectCorners.insert(.topRight)
        }
        if maskedCorners.contains(.layerMinXMaxYCorner) {
            rectCorners.insert(.bottomLeft)
        }
        if maskedCorners.contains(.layerMaxXMaxYCorner) {
            rectCorners.insert(.bottomRight)
        }
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: rectCorners,
            cornerRadii: cornerRadii
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}

extension URL {

}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension UITabBarController {
    /// Extends the size of the `UITabBarController` view frame, pushing the tab bar controller off screen.
    /// - Parameters:
    ///   - hidden: Hide or Show the `UITabBar`
    ///   - animated: Animate the change
    func setTabBarHidden1(_ hidden: Bool, animated: Bool) {
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
    
    /// Is the tab bar currently off the screen.
    private var tabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }
}


import UIKit

extension UITableView {
    
    func setEmptyView(message: String, imageName: String? = nil, buttonText: String? = nil,buttonBackGroundImg: String? = nil, buttonAction: (() -> Void)? = nil) {
        // Create a label to display the message
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)

        // Create a view to hold the message label
        let emptyView = UIView()
        emptyView.addSubview(messageLabel)

        // Center the message label in the empty view
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

        // Add an optional background image view
        if let imageName = imageName {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            emptyView.addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 30).isActive = true
            messageLabel.text = ""
        }

        // Add an optional button
        if let buttonBackGroundImg = buttonBackGroundImg, let buttonAction = buttonAction {
            
            let button = UIButton()
            button.setTitle(buttonText, for: .normal)
            button.setImage(UIImage(named: buttonBackGroundImg ), for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            emptyView.addSubview(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
            button.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            button.tag = 1
            button.tintColor = nil
            objc_setAssociatedObject(button, &AssociatedKeys.buttonActionClosure, buttonAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        // Set the table view's background view to the empty view
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }

    @objc private func buttonTapped(_ sender: UIButton) {
            // Retrieve the button action closure from the button's tag
            if let buttonAction = objc_getAssociatedObject(sender, &AssociatedKeys.buttonActionClosure) as? () -> Void {
                // Call the button action closure
                buttonAction()
            }
        }

    func restore1() {
        DispatchQueue.main.async {
            self.backgroundView = nil
            self.separatorStyle = .none
        }
        // Remove the empty view when data is available
        
    }
    
}

extension UICollectionView {
    
    private struct AssociatedKeys {
        static var refreshAction = "refreshAction"
        static var buttonActionClosure = "buttonActionClosure"
    }
    
    func setEmptyView(message: String, imageName: String? = nil, buttonText: String? = nil,buttonBackGroundImg: String? = nil, buttonAction: (() -> Void)? = nil) {
        // Create a label to display the message
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)

        // Create a view to hold the message label
        let emptyView = UIView()
        emptyView.addSubview(messageLabel)

        // Center the message label in the empty view
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

        // Add an optional background image view
        if let imageName = imageName {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            emptyView.addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 30).isActive = true
            messageLabel.text = ""
        }

        // Add an optional button
        if let buttonBackGroundImg = buttonBackGroundImg, let buttonAction = buttonAction {
            
            let button = UIButton()
            button.setTitle(buttonText, for: .normal)
            button.setImage(UIImage(named: buttonBackGroundImg ), for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            emptyView.addSubview(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
            button.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            button.tag = 1
            button.tintColor = nil
            objc_setAssociatedObject(button, &AssociatedKeys.buttonActionClosure, buttonAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        // Set the table view's background view to the empty view
        self.backgroundView = emptyView
        
    }

    @objc private func buttonTapped(_ sender: UIButton) {
            // Retrieve the button action closure from the button's tag
            if let buttonAction = objc_getAssociatedObject(sender, &AssociatedKeys.buttonActionClosure) as? () -> Void {
                // Call the button action closure
                buttonAction()
            }
        }

    func restore() {
        // Remove the empty view when data is available
        self.backgroundView = nil
        
    }
    
    func updateCollecforNoData(count:Int,msg:String? = "No data found",dataLoded:Bool){
        if dataLoded {
            if   count == 0{
                self.setEmptyView(message: msg ?? "")
            }else{
                self.restore()
            }
        }
    }
}


extension UIImage {
    
    
    func maskWithColor(_ color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    
    func resizeImage(image:UIImage, maxHeight:Float, maxWidth:Float) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = img.jpegData(compressionQuality: 1.0)! as NSData
        
//    let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
        
    }
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
  
    
//    func resizeByByte(maxMB: Double, completion: @escaping (Data) -> Void) {
//
//        var compressQuality: CGFloat = 1
//        var imageData = Data()
//        let max = maxMB * 1000000.0
//        var imageByte = Double(self.jpegData(compressionQuality: 1.0)?.count ?? 0)
//        imageData = self.jpegData(compressionQuality: compressQuality)!
//
//        while imageByte > max {
//            imageData = self.jpegData(compressionQuality: compressQuality)!
//            imageByte = Double(imageData.count)
////            imageByte = Double(self.jpegData(compressionQuality: compressQuality)?.count ?? 0)
//            compressQuality -= 0.1
//        }
//
//        if max > imageByte {
//            completion(imageData)
//        } else {
//            completion(self.jpegData(compressionQuality: 1.0)!)
//        }
//    }
    
    func resizeByByte(maxMB: Double, completion: @escaping (Data?) -> Void) {
        var compressQuality: CGFloat = 1.0
        let maxBytes = maxMB * 1000000.0 // Convert MB to Bytes

        guard var imageData = self.jpegData(compressionQuality: compressQuality) else {
            showAlert(message: "Failed to process image.")
            completion(nil)
            return
        }

        var imageByteSize = Double(imageData.count)

        while imageByteSize > maxBytes && compressQuality > 0.1 {
            compressQuality -= 0.1
            if let compressedData = self.jpegData(compressionQuality: compressQuality) {
                imageData = compressedData
                imageByteSize = Double(imageData.count)
            } else {
                self.showAlert(message: "Image compression failed.")
                completion(nil)
                return
            }
        }

        if imageByteSize > maxBytes {
            showAlert(message: "Image size is too large and cannot be compressed below \(maxMB) MB. Please select a smaller image.")
            completion(nil)
        } else {
            completion(imageData)
        }
    }
    
    // **Function to Show Alert**
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Image Too Large", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if let topVC = UIApplication.shared.keyWindow?.rootViewController {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        var newRect = CGRect(origin: .zero, size: CGSize(width: size.width*percentage, height: size.height*percentage))
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        self.draw(in: newRect)
        defer {UIGraphicsEndImageContext()}
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//extension UIImageView {
//    func makeRounded() {
//        self.layer.cornerRadius = self.frame.size.width / 2
//        self.clipsToBounds = true
//    }
//    
//    
//    func resizeByByte(maxMB: Double, completion: @escaping (Data) -> Void) {
//        
//        var compressQuality: CGFloat = 1
//        var imageData = Data()
//        let max = maxMB * 1000000.0
//        var imageByte = Double(self.jpegData(compressionQuality: 1.0)?.count ?? 0)
//        imageData = self.jpegData(compressionQuality: compressQuality)!
//                
//        while imageByte > max {
//            imageData = self.jpegData(compressionQuality: compressQuality)!
//            imageByte = Double(imageData.count)
////            imageByte = Double(self.jpegData(compressionQuality: compressQuality)?.count ?? 0)
//            compressQuality -= 0.1
//        }
//        
//        if max > imageByte {
//            completion(imageData)
//        } else {
//            completion(self.jpegData(compressionQuality: 1.0)!)
//        }
//    }
//}

extension UITableView {
    func addPullToRefresh(refreshAction: @escaping () -> Void) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshAction(sender:)), for: .valueChanged)
        self.refreshControl = refreshControl
        self.refreshAction = refreshAction
    }

    @objc private func handleRefreshAction(sender: UIRefreshControl) {
        refreshAction?()
    }

    private struct AssociatedKeys {
        static var refreshAction = "refreshAction"
        static var buttonActionClosure = "buttonActionClosure"
    }

    private var refreshAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshAction) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func endRefreshing() {
           refreshControl?.endRefreshing()
       }
}
enum AppStoryboard : String {
    
    case Main,Home,NewRquest,Service,Setting
}

extension AppStoryboard {

    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                        function : String = #function, // debugging purposes
                        line : Int = #line,
                        file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
    
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(self)
    }
    class var storyboardID : String {
        
        return "\(self)"
    }
    func updateRecycleCollView(collectionView:UICollectionView,count:Int,msg:String? = "") {
        if count == 0 {
         //   collectionView.toggleNoDataLabel(true, withText: msg)
        } else {
        //    collectionView.toggleNoDataLabel(false)
        }
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    func updateRecycletblView(collectionView:UITableView,count:Int,msg:String? = "",dataLoad:Bool? = true) {
        if dataLoad ?? false {
            if count == 0 {
              //  collectionView.toggleNoDataLabel(true, withText: msg)
            } else {
             //   collectionView.toggleNoDataLabel(false)
            }
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
}
extension String {
    func convertToMMDDYYYY(desireformate:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Array of possible date formats to check
        let formats = [
            "yyyy-MM-dd",
            "yyyy/MM/dd",
            "yyyy.MM.dd",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy/MM/dd HH:mm:ss",
            "yyyy.MM.dd HH:mm:ss",
            "MM/dd/yyyy",
            "MM-dd-yyyy",
            "dd/MM/yyyy",
            "dd-MM-yyyy"
        ]
        
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: self) {
                dateFormatter.dateFormat = desireformate
                let formattedDate = dateFormatter.string(from: date)
                return formattedDate
            }
        }
        
        return nil
    }
} 



extension UIViewController {
    
    // This method gets called automatically once when the app starts
    static let swizzleViewDidAppear: Void = {
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(swizzled_viewDidAppear(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    // This is the swizzled method
    @objc func swizzled_viewDidAppear(_ animated: Bool) {
        // Call the original method (which is now swizzled)
        self.swizzled_viewDidAppear(animated)
        
        // Print the class name of the view controller
        print("===============================================")
        print("ViewController appeared: \(type(of: self))")
        print("===============================================")
    }
    
    func openCameraWithPermissionCheck(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, allowsEditing: Bool = false) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            self.presentCameraPicker(delegate: delegate, allowsEditing: allowsEditing)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self?.presentCameraPicker(delegate: delegate, allowsEditing: allowsEditing)
                    } else {
                        self?.showCameraPermissionDeniedAlert()
                    }
                }
            }
        case .restricted, .denied:
            self.showCameraPermissionDeniedAlert()
        @unknown default:
            self.showCameraPermissionDeniedAlert()
        }
    }
    
    private func presentCameraPicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, allowsEditing: Bool) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.AlertControllerOnr(title: "Camera Unavailable", message: "Camera is not available on this device.")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = delegate
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = allowsEditing
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func showCameraPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Camera access is required to take photos. Please enable it in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
extension UITextView {
    var textPublisher1: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text }
            .eraseToAnyPublisher()
    }
}
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
 
