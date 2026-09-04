//
//  ShareFeedbackVC.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit
import DropDown
import Combine
import IQKeyboardManagerSwift

class ShareFeedbackVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var view_AddDetails1: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_AddDetails: UIView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var contactUsBtnO: UIButton!
    @IBOutlet weak var view_Select: UIView!
    @IBOutlet weak var feedbackAboveLbl: UILabel!
    @IBOutlet weak var feedbackAboveLbl2: UILabel!
    @IBOutlet weak var txt_Type: UITextField!
//    var UserType:String? = ""
//    {
//        didSet {
//            txt_Type.attributedPlaceholder = NSAttributedString(
//                string: "Please select",
//                attributes: [.foregroundColor: UIColor.black]
//            )
//        }
//    }
    @IBOutlet weak var txtV_AddDetails: UITextView!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var btnVGuest: UIView!
    @IBOutlet weak var btnVHost: UIView!
    @IBOutlet weak var infoBtnO: UIButton!
    
    // MARK: - Properties
       let dropDown = DropDown()
       private let userTypes = ["Guest", "Host"]
        var userType: String = ""
       private var cancellables = Set<AnyCancellable>()
       private let placeholderText = "Type a message..."
       private let viewModel = FeebackViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        atriburedText()
        //atriburedText2()
        setupUI()
        setupKeyboardNotifications()
        bindVC()
        
        if  self.userType == "Host" {
            self.txt_Type.text = "Host"
            self.userType = "host"
            self.view_AddDetails1.isHidden = false
            self.view_AddDetails.isHidden = false
        }
        if  self.userType == "Guest" {
            self.txt_Type.text = "Guest"
            self.userType = "guest"
            self.view_AddDetails1.isHidden = false
            self.view_AddDetails.isHidden = false
          }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        scrollView.alwaysBounceVertical = true
        txtV_AddDetails.delegate = self
        txtV_AddDetails.text = placeholderText
        txtV_AddDetails.textColor = .lightGray

        [view_Details, view_Select].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }

        btnContactUs.layer.cornerRadius = 22.5
        btnContactUs.layer.borderWidth = 1
        btnContactUs.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor

        contactUsBtnO.layer.cornerRadius = 6
        contactUsBtnO.layer.borderWidth = 1
        contactUsBtnO.layer.borderColor = UIColor.darkGray.cgColor

        view_AddDetails1.isHidden = true
        view_AddDetails.isHidden = true

        btnVGuest.isHidden = true
        btnVHost.isHidden = false

        setupInfoButton()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupInfoButton() {
        if infoBtnO == nil {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: "Caminho 14430") ?? UIImage(systemName: "info.circle"), for: .normal)
            btn.tintColor = .darkGray
            btn.translatesAutoresizingMaskIntoConstraints = false
            view_AddDetails.addSubview(btn)
            
            if let label = view_AddDetails.subviews.first(where: { $0 is UILabel }) {
                NSLayoutConstraint.activate([
                    btn.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 6),
                    btn.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                    btn.widthAnchor.constraint(equalToConstant: 20),
                    btn.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
            btn.addTarget(self, action: #selector(btnInfo_Tap(_:)), for: .touchUpInside)
            self.infoBtnO = btn
        }
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = bottomInset + 20
        scrollView.scrollIndicatorInsets.bottom = bottomInset + 20

        if let activeView = view.currentFirstResponder() {
            let convertedFrame = scrollView.convert(activeView.bounds, from: activeView)
            scrollView.scrollRectToVisible(convertedFrame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func atriburedText(){
        let rawText = "Found something confusing, broken, or harder than it should be? Tell us what happened. Your feedback goes directly toward improving the ZYVO experience for guests and hosts."
//        let rawText2 = "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4  // Adjust line spacing as needed
        paragraphStyle.alignment = .justified
        let attributedString = NSAttributedString(
            string: rawText,
           
            attributes: [
                
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label // Optional: customize color
            ]
        )

        self.feedbackAboveLbl.font = UIFont(name: "Poppins-Regular", size: 15.5)
        self.feedbackAboveLbl.attributedText = attributedString
    }
    
    func atriburedText2(){
        let rawText = "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4  // Adjust line spacing as needed
        paragraphStyle.alignment = .justified
        let attributedString = NSAttributedString(
            string: rawText,
           
            attributes: [
                
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label // Optional: customize color
            ]
        )

        self.feedbackAboveLbl2.font = UIFont(name: "Poppins-Regular", size: 15.5)
        self.feedbackAboveLbl2.attributedText = attributedString
    }
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        let textViewFrame = textView.convert(textView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(textViewFrame, animated: true)

        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }

    // MARK: - Actions
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelect_Tap(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = userTypes
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 3, y: sender.bounds.height)

        dropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            self.txt_Type.text = item
            self.userType = item.lowercased()
            self.view_AddDetails1.isHidden = false
            self.view_AddDetails.isHidden = false
        }

        dropDown.show()
    }

    @IBAction func btnContactUs_Tap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Host", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        guard let type = txt_Type.text, !type.isEmpty else {
            showAlert(for: "Please select your account")
            return
        }

        let details = txtV_AddDetails.text ?? ""
        if details.isEmpty || details == placeholderText {
            showAlert(for: "Please add additional details")
            return
        }

        viewModel.apiForShareFeedback(userType: userType, details: details)
    }

    @IBAction func btnInfo_Tap(_ sender: UIButton) {
        
        let msgText = "Please do not include full card numbers, bank account numbers, passwords, government ID numbers, or other highly sensitive information in your message."

        let storyboard = UIStoryboard(name: "Host", bundle: nil)

        if let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as? InfoPopVC {
            
            popoverContent.msg = msgText
            
            popoverContent.modalPresentationStyle = .popover
            
            if let popover = popoverContent.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds
                popover.permittedArrowDirections = .any
                popover.delegate = self
                popoverContent.preferredContentSize = CGSize(width: 270, height: 120)
            }
            
            self.present(popoverContent, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(
                title: nil,
                message: msgText,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ShareFeedbackVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - ViewModel Binding
extension ShareFeedbackVC {
    func bindVC() {
        viewModel.$shareFeedbackResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result = result else { return }
                result.handle(success: { response in
                    print(response.message ?? "")
                    
                    let title = "Thanks — we got it."
                    let message = "We appreciate you taking the time to help us improve ZYVO. If you asked us to follow up, we’ll use the contact information on your account."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        guard let self = self else { return }
                        if self.userTypes.contains(self.txt_Type.text ?? "") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            .store(in: &cancellables)
    }
}

// MARK: - Find Current First Responder
extension UIView {
    func currentFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        return subviews.compactMap { $0.currentFirstResponder() }.first
    }
}
