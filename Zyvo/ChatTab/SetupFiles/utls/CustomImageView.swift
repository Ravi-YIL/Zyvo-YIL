//
//  CustomImageView.swift
//  RTG
//
//  Created by mindz on 03/12/2019.
//  Copyright © 2019 mindz. All rights reserved.
//

import UIKit
import Alamofire
//class CustomImageView: UIImageView {


extension UIImageView {
    
   
    private static var imageCacheData : [String:Data] = [:]
    private static var lodedImage : UIImage? = nil
    private static var lodedData : Data? = nil
    typealias successData123 = (UIImage,Data?) -> Void
    private static var succ : successData123? = nil
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.clipsToBounds = true
//        self.image = nil
//    }
    private static var placeHolderImg : UIImage? = nil
    func loadImage(endUrl: String?,placeholder:UIImage? = nil, progressbar: Bool,successData : @escaping (UIImage,Data?) -> Void) {
        UIImageView.succ = successData
        guard let imageUrl1 = endUrl else { return }
        guard var imageUrl = imageUrl1.convert_to_string else { return }
        imageUrl = imageUrl.replace(string: " ", withString: "%20")
        if UIImageView.imageCache[imageUrl as NSCopying] != nil {
            self.image = UIImageView.imageCache[imageUrl as NSCopying] as! UIImage
            let pngData = UIImageView.imageCacheData[imageUrl]
            UIImageView.succ?(self.image!,pngData)
            return
        }
        if placeholder != nil {
            self.image = placeholder
            UIImageView.placeHolderImg = placeholder
        }
//        fetchImageFromServer(endUrl: imageUrl)
        fetchImageFromServer2(endUrl: imageUrl, progressbar: progressbar)
    }
    
    private func fetchImageFromServer(endUrl: String) {
        if endUrl == "" { return }
        let url =  endUrl
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,let image = UIImage(data: data) else {
                DispatchQueue.main.async { self.image = nil }
                return
            }
            UIImageView.imageCache[endUrl as NSCopying] = image
            UIImageView.imageCacheData[endUrl] = data
            DispatchQueue.main.async {
                self.image = image
                self.layoutIfNeeded()
                UIImageView.succ?(image,data)
            }
        }.resume()
    }
    private func fetchImageFromServer2(endUrl: String, progressbar:Bool = false) {
        if endUrl == "" { return }
        guard let url = URL(string: endUrl) else {
            return
        }
        let progressBar = CircleProgress()
        if progressbar == true {
            progressBar.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            if self.frame.size.width/2 < 50 {
                progressBar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.width/2)
            }
            progressBar.center = self.center
            progressBar.tag = -143
            for item in self.subviews {
                if item.tag == -143 {
                    item.removeFromSuperview()
                }
            }
            self.addSubview(progressBar)
            progressBar.progress = 0.0
        }
        let ima = UIImageView()
        
        
//        AF.request(endUrl).downloadProgress { (progres) in
//            if progressbar == true {
//                let g = progres.fractionCompleted
//                progressBar.progress = CGFloat(g)
//            }
//        }.responseImage { response in
//            if progressbar == true {
//                progressBar.removeFromSuperview()
//            }
//            if case .success(let image) = response.result {
//                UIImageView.imageCache[endUrl] = image
//        UIImageView.imageCacheData[endUrl] = response.data!
//                DispatchQueue.main.async {
//                    self.image = image
//                    self.layoutIfNeeded()
//                    UIImageView.succ?(image,response.data!)
//                }
//            }else{
//               DispatchQueue.main.async { self.image = UIImageView.placeHolderImg }
//            }
//        }
    }
}

