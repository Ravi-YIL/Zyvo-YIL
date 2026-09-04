//
//  ImagePicker.swift
//  Caviar
//
//  Created by YATIN  KALRA on 16/07/20.
//  Copyright © 2020 Ankur. All rights reserved.
//

import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
        public func present(from sourceView: UIView) {

            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//            if let action = self.action(for: .camera, title: "Take a photo") {
//                alertController.addAction(action)
//            }
            if let action = self.action(for: .photoLibrary, title: "Choose from gallery ") {
                alertController.addAction(action)
            }
            if let action = self.action(for: .camera, title: "Take a photo") {
                alertController.addAction(action)
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }

            self.presentationController?.present(alertController, animated: true)
            
        }
    
    public func presentCamera(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .photoLibrary, title: "Take a photo") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
        
    }
    
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
 
extension ImagePicker: UINavigationControllerDelegate {
    
}
//struct imageArray {
//    var image : UIImage!
//    var data : Data!
//    var url : String? = ""
//    var image_id : String? = ""
//}
