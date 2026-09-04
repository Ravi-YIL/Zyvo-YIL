//
//  txtVExTension.swift
//  Zyvo
//
//  Created by ravi on 29/01/25.
//

import UIKit

extension UITextView: UITextViewDelegate {
    
    private struct AssociatedKeys {
        static var placeholderText = "placeholderText"
        static var placeholderColor = "placeholderColor"
    }
    
    var placeholder1: String? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.placeholderText) as? String }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderText, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addPlaceholder()
        }
    }
    
    var placeholderTextColor: UIColor? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.placeholderColor) as? UIColor }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addPlaceholder()
        }
    }
    
    func addPlaceholder() {
        self.delegate = self
        if self.text.isEmpty {
            self.text = placeholder1
            self.textColor = placeholderTextColor ?? .gray
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder1 && textView.textColor == placeholderTextColor {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder1
            textView.textColor = placeholderTextColor ?? .gray
        }
    }
}

