//
//  CreateWishListVC.swift
//  Zyvo
//
//  Created by ravi Review on 20/11/24.
//

import UIKit
import Combine

class CreateWishListVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lbl50Character: UILabel!
    var backAction:(_ str : String ) -> () = { str in}
    
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_msg: UIView!
    @IBOutlet weak var desTxtV: UITextView!
    
    var propertyID = ""
    
    private var viewModel = CreateWishListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    let placeholderText = "Description"
    let placeholderColor = UIColor.placeholderText // Matches TextField's placeholder color
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        txt_Name.delegate = self
        
        bindViewModel()
        bindVC()
        btnClear.layer.borderWidth = 1
        btnClear.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        btnClear.layer.cornerRadius = btnClear.layer.frame.height / 2
        btnClear.backgroundColor = .clear
        btnClear.layer.borderColor  = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        btnCreate.backgroundColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        btnCreate.layer.cornerRadius = btnCreate.layer.frame.height / 2
        btnCreate.layer.borderColor  = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        btnCreate.layer.borderWidth = 1
        
        view_name.layer.borderWidth = 1
        view_name.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_name.layer.cornerRadius =  view_name.layer.frame.height / 2
        
        view_msg.layer.borderWidth = 1
        view_msg.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_msg.layer.cornerRadius =  15
        
        
    }
    
    private func bindViewModel() {
        txt_Name.textPublisher
            .compactMap { $0 }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        desTxtV.textPublisher1
            .compactMap { $0 }
            .assign(to: \.Desc, on: viewModel)
            .store(in: &cancellables)
    }
    
    @IBAction func btnCreate_Tap(_ sender: UIButton) {
        
        guard viewModel.isValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
            }
            return
        }
        viewModel.propertyID = self.propertyID
        viewModel.apiForCreateWishList()
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("Ravi")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_Name {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 25
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == desTxtV {
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }

            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            // Character limit: 50
            return updatedText.count <= 50
        }
        return true
    }

//    func textViewDidChange(_ textView: UITextView) {
//        if textView == desTxtV {
//            let words = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
//            print("\(words.count)")
//            lbl50Character.text = "Max \(remaining) characters"
//        }
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == desTxtV {
            let currentCount = textView.text.count
            let remaining = 50 - currentCount
            
            lbl50Character.text = "Max \(remaining) characters"
        }
    }
    @IBAction func btnClear_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: false) {
            self.backAction("Ravi")
        }
        
        btnCreate.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        btnCreate.backgroundColor = .clear
        
        btnClear.backgroundColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        
    }
    func configureTextView() {
        desTxtV.delegate = self
        desTxtV.text = placeholderText
        desTxtV.textColor = placeholderColor
    }
    // UITextViewDelegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if desTxtV.text == placeholderText {
            desTxtV.text = ""
            desTxtV.textColor = .label // Default text color
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if desTxtV.text.isEmpty {
            desTxtV.text = placeholderText
            desTxtV.textColor = placeholderColor
        }
    }
}
extension CreateWishListVC {
    
    func bindVC(){
        viewModel.$createWishlistResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Code to execute after delay
                        self.btnClear.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
                        
                        self.btnClear.backgroundColor = .clear
                        
                        self.btnCreate.backgroundColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
                        
                        self.dismiss(animated: false) {
                            self.backAction("Ravi")
                        }
                    }
                    
                })
            }.store(in: &cancellables)
    }
}

