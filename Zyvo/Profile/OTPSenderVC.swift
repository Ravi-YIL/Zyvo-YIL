//
//  OTPSenderVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 23/05/25.
//

import UIKit
import Combine
import CountryPickerView

class OTPSenderVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var verificationDetaiilLbl: UILabel!
    @IBOutlet weak var txt_EmailVerification: UITextField!
    @IBOutlet weak var view_EmailVerificaiton: UIView!
    @IBOutlet weak var txt_PhoneVerification: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var view_Phone: UIView!
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var view_phoneVerification: UIView!
    private var cancellables = Set<AnyCancellable>()
    private var viewModelVerifyPhone = PhoneVerificationViewModel_CreateProfile()
    var viewModelVerifyEmail = EmailVerificationViewModel()
    private var viewModelUpdatePhone = PhoneVerificationViewModel_CreateProfile()
    var viewModelEmailVerifyOTP = OTPEmailVerifyViewModel()
    var viewModelPhoneVerifyOTP = OTPVerifyPhoneViewModel()
    let countryPicker = CountryPickerView()
    let validator = PhoneNumberValidator()
    var editEmail_Phone = ""
    var countryCode : String = ""
    var expectedRegion = ""
    var verificationStatus = ""
    var OTP = ""
    var userID = ""
    var tempID = ""
    var backAction : (_ userID: String,_ email: String,_ OTP: String,_ countryCode: String) -> () = {_, _, _,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verificationDetaiilLbl.font = UIFont(name: "Poppins", size: 14)!
        verificationDetaiilLbl.lineBreakMode = .byWordWrapping
        
        print(verificationStatus,"verificationStatus")
        bindViewModel()
        bindVC()
        setupCountryAndPhoneFields()
        setupProfileViews()
        
        switch verificationStatus {
        case "Emailupdate", "EmailVerified":
            view_EmailVerificaiton.isHidden = false
            view_phoneVerification.isHidden = true
            verificationDetaiilLbl.text = "Enter your email for the verification process, we will send 4 digits code to your email."

        case "UpdatePhone", "PhoneVerified":
            view_EmailVerificaiton.isHidden = true
            view_phoneVerification.isHidden = false
            continueButton.isEnabled = false // Initially disabled
            verificationDetaiilLbl.text = "Enter your phone number for the verification process, we will send 4 digits code to your number."

        default:
            view_EmailVerificaiton.isHidden = true
            view_phoneVerification.isHidden = true
            verificationDetaiilLbl.text = "Please enter the verification code"
        }
    }
    
    private func bindViewModel() {
        
        txt_EmailVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModelVerifyEmail)
            .store(in: &cancellables)
        
        txt_PhoneVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModelVerifyPhone)
            .store(in: &cancellables)
        
        txt_PhoneVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModelUpdatePhone)
            .store(in: &cancellables)
    }
    
    private func setupCountryAndPhoneFields() {
      
        countryCodeTF.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        countryCodeTF.text = "🇺🇸 +1"
        self.countryCode  = "+1"
        viewModelVerifyPhone.countryCode = "+1"
        viewModelUpdatePhone.countryCode = "+1"
        
        txt_PhoneVerification.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        txt_PhoneVerification.delegate = self
        txt_PhoneVerification.keyboardType = .numberPad
        
        countryPicker.delegate = self
    }
    @objc func textFieldDidChange() {
        guard let number = txt_PhoneVerification.text,
              let code = countryCodeTF.text else {
            continueButton.isEnabled = false
            return
        }

        let phoneNumber = (txt_PhoneVerification.text ?? "")
        let regionCode = expectedRegion // or use "IN" directly

       // let isValid = validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
       
        let isValid = validator.isValidMobileNumber(
            countryCode: self.countryCode,
            number: phoneNumber
        )
        print("Is valid: \(isValid)")
        
       
        if isValid == true {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    
    func setupProfileViews() {
        view_Email.applyLightGrayRoundedBorder()
        view_Phone.applyLightGrayRoundedBorder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if textField == txt_PhoneVerification {
            let currentText = txt_PhoneVerification.text ?? ""
            // Create the updated text after replacement
            guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
            // Allow only numbers and a maximum of 10 digits
            let isNumeric = updatedText.allSatisfy { $0.isNumber }
           // return isNumeric && updatedText.count <= 10
            return isNumeric && updatedText.count <= 15
          //  return isNumeric && updatedText.count <= 9 || updatedText.count <= 10 || updatedText.count <= 11
        }
        // Allow changes for other text fields
        return true
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnSubmit_Verification(_ sender: UIButton) {
        print(verificationStatus,"verificationStatus")
        if verificationStatus == "PhoneVerified" {
            guard viewModelVerifyPhone.isloginValid else {
                
                if let error = viewModelVerifyPhone.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            viewModelVerifyPhone.apiForPhoneVerification()
            
        }
        if verificationStatus == "EmailVerified" {
            
            guard viewModelVerifyEmail.isSignUpValid else {
                if let error = viewModelVerifyEmail.errorMessage {
                    self.showAlert(for: error)
                    // self.showSnackAlert(for: error)
                }
                return
            }
            viewModelVerifyEmail.apiforEmailVerification()
        }
        if verificationStatus == "Emailupdate" {
            
            guard viewModelVerifyEmail.isSignUpValid else {
                if let error = viewModelVerifyEmail.errorMessage {
                    self.showAlert(for: error)
                    // self.showSnackAlert(for: error)
                }
                return
            }
            
            viewModelVerifyEmail.apiforEmailUpdate()
        }
        if verificationStatus == "UpdatePhone" {
            
            guard viewModelVerifyPhone.isloginValid else {
                
                if let error = viewModelVerifyPhone.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            print("api for update phone number")
            
            if self.txt_PhoneVerification.text == "" {
                self.showAlert(for: "Please enter phone number")
            } else {
                
                viewModelUpdatePhone.apiForPhoneUpdate() }
        }
    }
    
    @IBAction func btnCrossVerificaiton_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.backAction("","","","")
        }
        self.editEmail_Phone = ""
        self.txt_PhoneVerification.text = ""
        self.txt_EmailVerification.text = ""
    }
}
extension OTPSenderVC {
    func bindVC(){
        // Email verification
        viewModelVerifyEmail.$emailVerificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    print(response.data?.email ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    
                    self.dismiss(animated: true) {
                        self.backAction("\(response.data?.userID ?? 0)","\(response.data?.email ?? "")","\(response.data?.otp ?? 0)", "")
                    }
                })
            }.store(in: &cancellables)
        
        // Email update
        viewModelVerifyEmail.$emailVerificationCodeSentResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    print(response.data?.otpSendTo ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    self.dismiss(animated: true) {
                        self.backAction("\(response.data?.userID ?? 0)","\(response.data?.otpSendTo ?? "")","\(response.data?.otp ?? 0)", "")
                    }
                })
            }.store(in: &cancellables)
  
        //Result UpdatePhoneNumber
        viewModelUpdatePhone.$updateMobileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    
                    print(response.message ?? "0","MESSAGE")
                    self.showToast(response.message ?? "")
                    print(response.data?.phoneNumber ?? "","Phone")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                   
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP  = "\(response.data?.otp ?? 0)"
                    
            let phone =  "\(response.data?.phoneNumber ?? "")"
                    self.dismiss(animated: true) {
                        self.backAction("\(self.userID)","\(phone)","\(self.OTP)", "\(self.countryCode)")
                    }
                })
            }.store(in: &cancellables)
        
        //Phone Confirm Result
        viewModelVerifyPhone.$phoneverificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    self.showToast(response.message ?? "")
                    print(response.data?.phoneNumber ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP  = "\(response.data?.otp ?? 0)"
                    print(response.message ?? "0","MESSAGE")
                    
                    let phone =  "\(response.data?.phoneNumber ?? "")"
                            
                            self.dismiss(animated: true) {
                                self.backAction("\(self.userID)","\(self.txt_PhoneVerification.text ?? "")","\(self.OTP)", "\(self.countryCode)")
                            }
                    
                })
            }.store(in: &cancellables)
    }
}
extension OTPSenderVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        
        
        let flag = country.code.flagEmoji
        let code = country.phoneCode

        // Make sure flag uses a pure emoji-compatible font
        let emojiFont = UIFont.systemFont(ofSize: 14)
        let textFont = UIFont.systemFont(ofSize: 14, weight: .regular)

        // Build attributed string with flag in emoji font and code in regular font
        let attributedText = NSMutableAttributedString(
            string: "\(flag) ",
            attributes: [.font: emojiFont]
        )
        attributedText.append(NSAttributedString(
            string: "(\(code))",
            attributes: [.font: textFont]
        ))

        // Assign it directly
        countryCodeTF.attributedText = attributedText
       
        //let flag = country.code.flagEmoji // Access the flag emoji as String
       // let name = country.name
      //  let code = country.phoneCode
       // self.countryCode = code
       // countryCodeTF.text = "\(flag) (\(code))"
        
        self.countryCode = "\(flag) (\(code))"
        viewModelUpdatePhone.countryCode = code
        viewModelVerifyPhone.countryCode = code
        self.countryCode = "\(code)"
        if (txt_PhoneVerification.text ?? "") != "" {
            let phoneNumber = (txt_PhoneVerification.text ?? "")
           // let isValid =  validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
            let isValid = validator.isValidMobileNumber(
                countryCode: self.countryCode,
                number: phoneNumber
            )
            print("Is valid: \(isValid)")
            if isValid == true {
                continueButton.isEnabled = true
            } else {
                continueButton.isEnabled = false
            }
        }
        
        
    }
}
extension OTPSenderVC :DPOTPViewDelegate{
    func dpOTPViewAddText(_ text: String, at position: Int) {
        viewModelEmailVerifyOTP.updateOTPText(text)
        viewModelPhoneVerifyOTP.updateOTPText(text)
    }
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
}
