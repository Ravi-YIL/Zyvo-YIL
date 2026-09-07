//
//  ContactUsVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 16/01/25.
//

import UIKit
import Combine
import GoogleMaps
import CoreLocation

class ContactUsVC: UIViewController,GMSMapViewDelegate{

    @IBOutlet weak var MapV: GMSMapView!
    @IBOutlet weak var txt_MSG: UITextView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var detailBgView: UIView!
    @IBOutlet weak var msgTxtVBgV: UIView!
    @IBOutlet weak var lbl_discription: UILabel!
    @IBOutlet weak var lbl_HelpContact: UILabel!
    @IBOutlet weak var btn_Info: UIButton!
    private var tooltipView: UIView?
    private var overlayView: UIView?
    
    private var viewModel = ContactUsViewModel()
    private var cancellables = Set<AnyCancellable>()
    var discText: String? = "Need help with a booking, listing, payment, payout or account? Our support team is here to help. Send us a message with a brief description of the issue and, when applicable, include the email on your ZYVO account and your booking or listing reference so we can assist you faster."
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindVC()
        
       self.MapV.delegate = self

        detailBgView.layer.cornerRadius = 8
        detailBgView.layer.borderWidth = 1
        detailBgView.layer.borderColor = UIColor.lightGray.cgColor
        
        msgTxtVBgV.layer.cornerRadius = 8
        msgTxtVBgV.layer.borderWidth = 1
        msgTxtVBgV.layer.borderColor = UIColor.lightGray.cgColor
        
        let rawText = (self.discText)?.decodedHTML

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
        paragraphStyle.alignment = .justified  // Or use .left, .center, etc.

        let attributedString = NSAttributedString(
            string: rawText ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label // Optional: customize color
            ]
        )

        self.lbl_discription.attributedText = attributedString
        setupHelpInfoButton()
        setupMap()
    }
    
    private func bindViewModel() {
        txt_Name.textPublisher
            .compactMap { $0 }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        txt_Email.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        txt_MSG.textPublisher1
            .compactMap { $0 }
            .assign(to: \.Desc, on: viewModel)
            .store(in: &cancellables)
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtn(_ sender: UIButton){
        guard viewModel.isSignUpValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
            }
            return
        }
        viewModel.apiforContactUs()
    }

    private func setupMap() {
        guard let mapV = self.MapV else { return }
        
        let lat: CLLocationDegrees = 33.7490
        let lng: CLLocationDegrees = -84.3880
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        mapV.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 14.0)
        mapV.camera = camera
        mapV.animate(to: camera)
        
        let marker = GMSMarker(position: position)
        marker.position = position
        marker.title = "Atlanta, Georgia, United States"
        marker.snippet = "Zyvo"
        marker.icon = UIImage(named: "path0 8") ?? UIImage(named: "Locationicon") ?? GMSMarker.markerImage(with: .red)
        marker.map = mapV
        
        let styleJSON = """
        [
          {
            "elementType": "labels",
            "stylers": [
              { "visibility": "off" }
            ]
          }
        ]
        """

        do {
            mapV.mapStyle = try GMSMapStyle(jsonString: styleJSON)
        } catch {
            print(error)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            mapV.animate(to: camera)
        }
    }

    private func setupHelpInfoButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let infoImage = UIImage(systemName: "info.circle", withConfiguration: config) ?? UIImage(named: "information-button")
        
        if let btn = btn_Info {
            btn.setImage(infoImage, for: .normal)
            btn.tintColor = UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 1.0)
            btn.addTarget(self, action: #selector(btnInfo_Tap(_:)), for: .touchUpInside)
        }
        
        let labelToAttach = lbl_HelpContact ?? self.findHelpContactLabel()
        if btn_Info == nil, let label = labelToAttach {
            let infoButton = UIButton(type: .custom)
            infoButton.setImage(infoImage, for: .normal)
            infoButton.tintColor = UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 1.0)
            infoButton.addTarget(self, action: #selector(btnInfo_Tap(_:)), for: .touchUpInside)
            self.btn_Info = infoButton
            
            if let superview = label.superview {
                infoButton.translatesAutoresizingMaskIntoConstraints = false
                superview.addSubview(infoButton)
                NSLayoutConstraint.activate([
                    infoButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 6),
                    infoButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                    infoButton.widthAnchor.constraint(equalToConstant: 24),
                    infoButton.heightAnchor.constraint(equalToConstant: 24)
                ])
            }
        }
    }

    private func findHelpContactLabel() -> UILabel? {
        func searchLabel(in view: UIView) -> UILabel? {
            for subview in view.subviews {
                if let lbl = subview as? UILabel, let text = lbl.text, text.contains("Help") || text.contains("Contact") {
                    return lbl
                }
                if let found = searchLabel(in: subview) {
                    return found
                }
            }
            return nil
        }
        return searchLabel(in: self.view)
    }

    @objc @IBAction func btnInfo_Tap(_ sender: UIButton) {
        if tooltipView != nil {
            dismissTooltip()
            return
        }

        let overlay = UIView(frame: self.view.bounds)
        overlay.backgroundColor = .clear
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip))
        overlay.addGestureRecognizer(tapGesture)
        self.view.addSubview(overlay)
        self.overlayView = overlay

        let tooltip = UIView()
        tooltip.alpha = 0
        tooltip.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.view.addSubview(tooltip)
        self.tooltipView = tooltip

        let bubble = UIView()
        bubble.backgroundColor = UIColor(red: 45/255, green: 55/255, blue: 56/255, alpha: 0.96)
        bubble.layer.cornerRadius = 10
        bubble.layer.shadowColor = UIColor.black.cgColor
        bubble.layer.shadowOpacity = 0.15
        bubble.layer.shadowOffset = CGSize(width: 0, height: 4)
        bubble.layer.shadowRadius = 8
        bubble.translatesAutoresizingMaskIntoConstraints = false
        tooltip.addSubview(bubble)

        let arrowView = UIView()
        arrowView.backgroundColor = .clear
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        tooltip.addSubview(arrowView)

        let arrowLayer = CAShapeLayer()
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 0, y: 10))
        arrowPath.addLine(to: CGPoint(x: 8, y: 0))
        arrowPath.addLine(to: CGPoint(x: 16, y: 10))
        arrowPath.close()
        arrowLayer.path = arrowPath.cgPath
        arrowLayer.fillColor = UIColor(red: 45/255, green: 55/255, blue: 56/255, alpha: 0.96).cgColor
        arrowView.layer.addSublayer(arrowLayer)

        let label = UILabel()
        label.text = "Tell us what happened and include any relevant booking, listing or payment details. Please do not include full card numbers, passwords or other sensitive credentials."
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14)
        ])

        tooltip.translatesAutoresizingMaskIntoConstraints = false
        
        let iconFrame = sender.superview?.convert(sender.frame, to: self.view) ?? sender.frame
        
        NSLayoutConstraint.activate([
            tooltip.topAnchor.constraint(equalTo: self.view.topAnchor, constant: iconFrame.maxY + 4),
            tooltip.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            tooltip.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            arrowView.topAnchor.constraint(equalTo: tooltip.topAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 16),
            arrowView.heightAnchor.constraint(equalToConstant: 10),
            arrowView.centerXAnchor.constraint(equalTo: self.view.leadingAnchor, constant: iconFrame.midX),

            bubble.topAnchor.constraint(equalTo: arrowView.bottomAnchor),
            bubble.leadingAnchor.constraint(equalTo: tooltip.leadingAnchor),
            bubble.trailingAnchor.constraint(equalTo: tooltip.trailingAnchor),
            bubble.bottomAnchor.constraint(equalTo: tooltip.bottomAnchor)
        ])

        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            tooltip.alpha = 1
            tooltip.transform = .identity
        }, completion: nil)
    }

    @objc private func dismissTooltip() {
        self.overlayView?.removeFromSuperview()
        self.overlayView = nil

        if let tooltip = tooltipView {
            UIView.animate(withDuration: 0.2, animations: {
                tooltip.alpha = 0
                tooltip.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                tooltip.removeFromSuperview()
                self.tooltipView = nil
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if tooltipView != nil {
            dismissTooltip()
        }
    }

}

extension ContactUsVC {
    func bindVC(){
        viewModel.$contactUsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.showToast(response.message ?? "")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        print("Executed after 2 seconds!")
                        self.navigationController?.popViewController(animated: true)
                    }

                })
            }.store(in: &cancellables)
    }
}
