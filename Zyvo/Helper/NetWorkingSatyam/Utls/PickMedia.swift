//
//  PickMedia.swift
//  MyAirSpa_YesITLabs
//
//  Created by YATIN  KALRA on 08/12/23.
//


//import UIKit
//import Photos
//import AVFoundation
////import AssetsPickerViewController
//
//
//
//struct Media:Equatable {
//    
//    var image : UIImage!
//    var data : Data!
//    var url : String? = ""
//    var type : String? = ""
//    var id : String? = ""
//    var phAsset : PHAsset?
//    var URL : URL?
//}
//
//extension Notification.Name {
//    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
//}
//
//class ImageVideoPickerViewModel: NSObject {
//  
//    var selectedAssets: [Media] = []
//    var didFinishPicking: ((Media) -> Void)?
//    
//    func showImageVideoPicker() {
//        
//         let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
//
//               alert.addAction(UIAlertAction(title: "Photo/Video", style: .default , handler:{ (UIAlertAction)in
//                   print("User click Approve button")
//                
//                   let pickerConfig = AssetsPickerConfig()
//
//                   let options = PHFetchOptions()
//                   options.sortDescriptors = [
//                       NSSortDescriptor(key: "pixelWidth", ascending: true),
//                       NSSortDescriptor(key: "pixelHeight", ascending: true)
//                   ]
//
//                   pickerConfig.assetFetchOptions = [
//                       .smartAlbum: options
//                   ]
//
//                   let picker = AssetsPickerViewController()
//                   picker.pickerConfig = pickerConfig
//                   picker.pickerDelegate = self
//                   
//                   self.selectedAssets.removeAll()
//                   UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
//                   
//               }))
//
//       
//      
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//
//            
//    }
//    
//    
//    @available(iOS 14.0, *)
//    
//    func isAssetVideo(_ asset: PHAsset) -> Bool {
//        return asset.mediaType == .video
//    }
//}
//extension ImageVideoPickerViewModel:AssetsPickerViewControllerDelegate {
//    
//    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
//        if controller.selectedAssets.count > 6 {
//            // do your job here
//            return false
//        }
//        return true
//    }
//    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
//        print(assets.count , "picker bug")
//        for asset_ in assets {
//            if asset_.mediaType == .video{
//                
//                var thumbnail = UIImage()
//                let manager = PHImageManager.default()
//                let option = PHImageRequestOptions()
//                
//                option.isSynchronous = true
//                fetchAssetDuration(asset: asset_) { d in
//                    if d < 60 {
//                        DispatchQueue.global(qos: .background).async {
//                            manager.requestImage(for: asset_, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result,info)->Void in
//                                
//                                thumbnail = result!
//                               
//                                
//                            })
//                            PHImageManager.default().requestAVAsset(forVideo: asset_,
//                                                                    options: nil) { (asset, audioMix, info) in
//                                 if
//                                     let asset1 = asset as? AVURLAsset,
//                                     let data = NSData(contentsOf: asset1.url) {
//                                     print("File size after compression: \(Double(data.length) / 1048576.00) mb")
//                                     
//                                  let m = Media(image: thumbnail, data: data as Data,type: "vedio",phAsset: asset_)
//                                    
//                                     DispatchQueue.main.async {
//                                         self.didFinishPicking?(m)
//                                     }
//                                     }
//                                  }
//                        }
//                    }else{
//                        let alert = UIAlertController(title: "", message: "You have selected asset over 60 seconds, please select again below 60 seconds.", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                            alert.dismiss(animated: true)
//                                }
//                        alert.addAction(okAction)
//                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//
//                
//            }else{
//                self.fetchAssetSize(asset: asset_) { mb in
//                    print(mb,"sizeInMB 2")
//                    if mb ?? 0 < 15.0 {
//                        let manager = PHImageManager.default()
//                        let option = PHImageRequestOptions()
//                        var image = UIImage()
//                        option.isSynchronous = true
//                        
//                        manager.requestImage(for: asset_, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: option, resultHandler: { [self](result, info)->Void in
//                            image = result!
//                            image.resizeByByte(maxMB: 0.5) { d in
//                            let m = Media(image: image, data:d , url: "", type: "image")
//                                
//                                DispatchQueue.main.async {
//                                    self.didFinishPicking?(m)
//                                }
//                            }
//                        })
//                    }else{
//                        
//                        let alert = UIAlertController(title: "", message: "You have selected image over 5 MB, please select again below 5 MB.", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//                            alert.dismiss(animated: true)
//                                }
//                        alert.addAction(okAction)
//                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//                    }
//                }
//                
//                
//            }
//          
//
//        }
//       
//    }
//    func fetchAssetDuration(asset: PHAsset,complition:@escaping(Int) -> Void)  {
//      
//        if asset.mediaType == .video {
//            let options = PHVideoRequestOptions()
//            options.version = .original
//
//            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
//                if let avAsset = avAsset as? AVURLAsset {
//                    let durationInSeconds = avAsset.duration.seconds
//                    var duration = Int(avAsset.duration.seconds)
//                    complition(duration)
//                    print("Video Duration: \(durationInSeconds) seconds")
//                
//                }
//            }
//        }
//       
//    }
//    func fetchAssetSize(asset: PHAsset, completion: @escaping (Double?) -> Void) {
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isNetworkAccessAllowed = true
//
//        PHImageManager.default().requestImageData(for: asset, options: requestOptions) { (data, _, _, _) in
//            if let dataSize = data?.count {
//                // Convert bytes to megabytes
//                let sizeInMB = Double(dataSize) / (1024 * 1024)
//                completion(sizeInMB)
//                print(sizeInMB,"sizeInMB")
//            } else {
//                completion(nil)
//            }
//        }
//    }
//    
//}
//
//
//class VideoThumbnailCache {
//    static let shared = VideoThumbnailCache()
//
//    private var cache: NSCache<NSString, UIImage> = {
//        let cache = NSCache<NSString, UIImage>()
//        return cache
//    }()
//
//    func getThumbnail(for url: URL, completion: @escaping (UIImage?) -> Void) {
//        let key = url.absoluteString as NSString
//        
//        if let cachedImage = cache.object(forKey: key) {
//            completion(cachedImage)
//            return
//        }
//        
//        
//        
//        url.getThumbnailImageFromVideoUrl(completion: { thumbnail in
//            if let thumbnail = thumbnail{
//            self.cache.setObject(thumbnail, forKey: key)
//            DispatchQueue.main.async {
//                completion(thumbnail)
//            }
//        } else {
//            DispatchQueue.main.async {
//                completion(nil)
//                
//            }
//              }
//        })
//    }
//    
//}
//extension URL {
//    func getThumbnailImageFromVideoUrl(completion: @escaping ((_ image: UIImage?)->Void)) {
//        DispatchQueue.global().async { //1
//            let asset = AVAsset(url: self) //2
//            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
//            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
//            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
//            do {
//                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
//                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
//                DispatchQueue.main.async { //8
//                    completion(thumbNailImage) //9
//                }
//            } catch {
//                print(error.localizedDescription) //10
//                DispatchQueue.main.async {
//                    let img:UIImage = #imageLiteral(resourceName: "fullimage")
//                    completion(img) //11
//                }
//            }
//        }
//    }
//}
