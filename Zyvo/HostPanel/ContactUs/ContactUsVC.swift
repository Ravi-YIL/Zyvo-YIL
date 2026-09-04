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
    
    private var viewModel = ContactUsViewModel()
    private var cancellables = Set<AnyCancellable>()
    var discText: String? = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search"
    
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
