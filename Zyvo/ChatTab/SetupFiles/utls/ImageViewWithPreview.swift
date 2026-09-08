//
//  ImageViewWithPreview.swift
//  Zyvo
//
//  Created by Bhavneet Singh on 05/01/18.
//  Copyright © 2018 Bhavneet Singh. All rights reserved.
//

import UIKit

@objc protocol ImageViewWithPreviewDelegate: AnyObject {
    @objc optional func imageViewWithPreview(willPreview imageView: ImageViewWithPreview)
    @objc optional func imageViewWithPreview(didPreview imageView: ImageViewWithPreview)
    @objc optional func imageViewWithPreview(willDismiss imageView: ImageViewWithPreview)
    @objc optional func imageViewWithPreview(didDismiss imageView: ImageViewWithPreview)
}

class ImageViewWithPreview: UIImageView, UIGestureRecognizerDelegate {

    @objc enum ImageType: Int {
        case Circle = 0, Rectangle = 1, Square = 2
        
        static func initialize(with: Int) -> ImageType {
            return with == 0 ? ImageType.Circle : with == 1 ? ImageType.Rectangle : ImageType.Square
        }
    }
    
    @objc enum GestureType: Int {
        case tap = 0, longPress = 1, both = 2
        
        static func initialize(with: Int) -> GestureType {
            switch with {
            case 0: return .tap
            case 1: return .longPress
            case 2: return .both
            default: return .tap
            }
        }
    }

    var imageType: ImageType = .Rectangle
    var gestureType: GestureType = .tap
    
    @IBInspectable var previewType: Int = 1 {
        didSet {
            self.imageType = ImageType.initialize(with: previewType)
        }
    }

    @IBInspectable var gestureTypeRaw: Int = 0 {
        didSet {
            self.gestureType = GestureType.initialize(with: gestureTypeRaw)
            setupGestures()
        }
    }
    
    weak var delegate: ImageViewWithPreviewDelegate?
    
    private var tapGesture: UITapGestureRecognizer?
    private var longPressGesture: UILongPressGestureRecognizer?
    
    private var backDarkView: UIView?
    private var previewScrollView: UIScrollView?
    private var transitionImageView: UIImageView?
    private var closeButton: UIButton?
    private var isDismissing: Bool = false
    private var targetOriginFrame: CGRect = .zero

    private var targetWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow
            }
            if let firstWindow = windowScene.windows.first {
                return firstWindow
            }
        }
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    return keyWindow
                }
                if let firstWindow = windowScene.windows.first {
                    return firstWindow
                }
            }
        }
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ??
               UIApplication.shared.windows.first ??
               (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        isUserInteractionEnabled = true
        setupGestures()
    }
    
    func setupGestures() {
        if let tap = tapGesture {
            removeGestureRecognizer(tap)
            tapGesture = nil
        }
        if let longPress = longPressGesture {
            removeGestureRecognizer(longPress)
            longPressGesture = nil
        }
        
        switch gestureType {
        case .tap:
            let tap = UITapGestureRecognizer(target: self, action: #selector(showImage))
            addGestureRecognizer(tap)
            tapGesture = tap
        case .longPress:
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
            addGestureRecognizer(longPress)
            longPressGesture = longPress
        case .both:
            let tap = UITapGestureRecognizer(target: self, action: #selector(showImage))
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
            addGestureRecognizer(tap)
            addGestureRecognizer(longPress)
            tapGesture = tap
            longPressGesture = longPress
        }
    }
    
    private func replicate(image: UIImage, in window: UIWindow) -> UIImageView {
        let replicateImage = UIImageView(image: image)
        replicateImage.clipsToBounds = true
        replicateImage.frame = self.superview?.convert(self.frame, to: window) ?? self.frame
        replicateImage.layer.cornerRadius = self.layer.cornerRadius
        replicateImage.contentMode = .scaleAspectFill
        replicateImage.isUserInteractionEnabled = true
        return replicateImage
    }
    
    @objc private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            showImage()
        }
    }
    
    @objc func showImage() {
        guard !isDismissing, backDarkView == nil else { return }
        guard let currentImage = self.image, let window = targetWindow else { return }
        
        delegate?.imageViewWithPreview?(willPreview: self)
        
        let startFrame = self.superview?.convert(self.frame, to: window) ?? self.frame
        self.targetOriginFrame = startFrame
        
        // 1. Dim background
        let darkView = UIView(frame: window.bounds)
        darkView.backgroundColor = UIColor(white: 0, alpha: 0.92)
        darkView.alpha = 0
        window.addSubview(darkView)
        self.backDarkView = darkView
        
        // 2. ScrollView for pinch/zoom
        let scrollView = UIScrollView(frame: window.bounds)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        darkView.addSubview(scrollView)
        self.previewScrollView = scrollView
        
        // 3. Transition image view
        let transImageView = replicate(image: currentImage, in: window)
        scrollView.addSubview(transImageView)
        self.transitionImageView = transImageView
        
        // 4. Close button
        let safeArea = window.safeAreaInsets
        let btnSize: CGFloat = 36
        let closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(
            x: window.bounds.width - btnSize - 16,
            y: max(safeArea.top + 10, 24),
            width: btnSize,
            height: btnSize
        )
        closeBtn.backgroundColor = UIColor(white: 0.2, alpha: 0.7)
        closeBtn.layer.cornerRadius = btnSize / 2
        closeBtn.clipsToBounds = true
        
        if #available(iOS 13.0, *), let xmark = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)) {
            closeBtn.setImage(xmark.withRenderingMode(.alwaysTemplate), for: .normal)
            closeBtn.tintColor = .white
        } else {
            closeBtn.setTitle("✕", for: .normal)
            closeBtn.setTitleColor(.white, for: .normal)
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        closeBtn.alpha = 0
        closeBtn.addTarget(self, action: #selector(hideImage), for: .touchUpInside)
        darkView.addSubview(closeBtn)
        self.closeButton = closeBtn
        
        // 5. Gestures for dismiss & zoom
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        darkView.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        darkView.addGestureRecognizer(singleTap)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        darkView.addGestureRecognizer(panGesture)
        
        // 6. Calculate target layout
        let maxWidth = window.bounds.width - 24
        let maxHeight = window.bounds.height - safeArea.top - safeArea.bottom - 48
        var targetSize: CGSize
        
        switch self.imageType {
        case .Circle:
            let dim = min(maxWidth, maxHeight)
            targetSize = CGSize(width: dim, height: dim)
        case .Square:
            let dim = min(maxWidth, maxHeight)
            targetSize = CGSize(width: dim, height: dim)
        case .Rectangle:
            if currentImage.size.height > 0 && currentImage.size.width > 0 {
                let ratio = currentImage.size.width / currentImage.size.height
                var width = maxWidth
                var height = width / ratio
                if height > maxHeight {
                    height = maxHeight
                    width = height * ratio
                }
                targetSize = CGSize(width: width, height: height)
            } else {
                targetSize = CGSize(width: maxWidth, height: maxWidth)
            }
        }
        
        let targetCenter = CGPoint(x: window.bounds.width / 2, y: window.bounds.height / 2)
        
        UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.86, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            darkView.alpha = 1.0
            closeBtn.alpha = 1.0
            transImageView.frame.size = targetSize
            transImageView.center = targetCenter
            transImageView.layer.cornerRadius = (self.imageType == .Circle) ? (targetSize.width / 2) : 12
        }) { _ in
            self.delegate?.imageViewWithPreview?(didPreview: self)
        }
    }
    
    @objc func hideImage() {
        guard !isDismissing, let darkView = backDarkView, let transImageView = transitionImageView else { return }
        isDismissing = true
        delegate?.imageViewWithPreview?(willDismiss: self)
        
        previewScrollView?.setZoomScale(1.0, animated: false)
        
        let endFrame: CGRect
        if let window = targetWindow, let currentSuperview = self.superview {
            endFrame = currentSuperview.convert(self.frame, to: window)
        } else {
            endFrame = targetOriginFrame
        }
        
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseIn], animations: {
            transImageView.transform = .identity
            transImageView.frame = endFrame
            transImageView.layer.cornerRadius = self.layer.cornerRadius
            darkView.alpha = 0
            self.closeButton?.alpha = 0
        }) { _ in
            darkView.removeFromSuperview()
            self.backDarkView = nil
            self.previewScrollView = nil
            self.transitionImageView = nil
            self.closeButton = nil
            self.isDismissing = false
            self.delegate?.imageViewWithPreview?(didDismiss: self)
        }
    }
    
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        if (previewScrollView?.zoomScale ?? 1.0) <= 1.05 {
            hideImage()
        }
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let scrollView = previewScrollView, let transImageView = transitionImageView else { return }
        if scrollView.zoomScale > 1.05 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let pointInView = gesture.location(in: transImageView)
            let newScale: CGFloat = 2.5
            let width = scrollView.bounds.width / newScale
            let height = scrollView.bounds.height / newScale
            let originX = pointInView.x - (width / 2.0)
            let originY = pointInView.y - (height / 2.0)
            let zoomRect = CGRect(x: originX, y: originY, width: width, height: height)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let scrollView = previewScrollView, scrollView.zoomScale <= 1.05,
              let transImageView = transitionImageView, let darkView = backDarkView else { return }
        
        let translation = gesture.translation(in: darkView)
        let velocity = gesture.velocity(in: darkView)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                transImageView.transform = CGAffineTransform(translationX: translation.x * 0.4, y: translation.y)
                let progress = min(1.0, translation.y / 280.0)
                darkView.alpha = max(0.2, 1.0 - (progress * 0.7))
                closeButton?.alpha = 1.0 - progress
            }
        case .ended, .cancelled:
            if translation.y > 100 || velocity.y > 600 {
                hideImage()
            } else {
                UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut], animations: {
                    transImageView.transform = .identity
                    darkView.alpha = 1.0
                    self.closeButton?.alpha = 1.0
                })
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer, (previewScrollView?.zoomScale ?? 1.0) <= 1.05 {
            return false
        }
        return true
    }
}

extension ImageViewWithPreview: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return transitionImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let transImageView = transitionImageView else { return }
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        transImageView.center = CGPoint(
            x: scrollView.contentSize.width * 0.5 + offsetX,
            y: scrollView.contentSize.height * 0.5 + offsetY
        )
    }
}
