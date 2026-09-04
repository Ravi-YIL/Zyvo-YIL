//
//  CustomLoader.swift
//  Zyvo
//
//  Created by ravi on 12/02/25.
//

import UIKit
import WebKit

final class CustomLoader: UIView {

    static let shared = CustomLoader()
    
    private var webView: WKWebView!

    private override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupWebView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWebView() {
        webView = WKWebView(frame: self.bounds)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        
        // Load Lottie HTML file
        if let filePath = Bundle.main.path(forResource: "Zyvo lottie", ofType: "html", inDirectory: "Downloads") {
            let fileURL = URL(fileURLWithPath: filePath)
            print(fileURL,"fileURL LAODIING")
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            print("❌ Error: Zyvo lottie.html not found!")
        }

        addSubview(webView)
        
        // Make the background semi-transparent
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    func show(in view: UIView?) {
        guard let view = view else {
            print("❌ Error: View is nil, trying to add to UIWindow!")
            if let window = UIApplication.shared.windows.first {
                window.addSubview(self)
                window.bringSubviewToFront(self)
                print("✅ CustomLoader added to UIWindow!")
            }
            return
        }

        DispatchQueue.main.async {
            if self.superview == nil {
                view.addSubview(self)
                view.bringSubviewToFront(self)
                print("✅ CustomLoader added to view!")
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
            print("✅ CustomLoader removed from view!")
        }
    }
}
