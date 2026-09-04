//
//  CodeVerifierVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 23/05/25.
//


import UIKit
import Combine

class CodeVerifierVC: UIViewController {
    @IBOutlet weak var OTPverificationDetaiilLbl: UILabel!
    @IBOutlet weak var resendBtnO: UIButton!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var view_OTPtxt: DPOTPView!
    @IBOutlet weak var view_timeResend: UIView!
    var viewModelEmailVerifyOTP = OTPEmailVerifyViewModel()
    var viewModelPhoneVerifyOTP = OTPVerifyPhoneViewModel()
    var viewModelVerifyEmail = EmailVerificationViewModel()
    private var viewModelVerifyPhone = PhoneVerificationViewModel_CreateProfile()
    private var viewModelUpdatePhone = PhoneVerificationViewModel_CreateProfile()
    private var cancellables = Set<AnyCancellable>()
    var timer = Timer()
    var verificationStatus = ""
    var OTP = ""
    var userID = ""
    var emailtobeUpdate = ""
    var tempID = ""
    var phonetobeUpdate = ""
    var countryCode = ""
    var backAction : (_ value: String) -> () = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindVC()
        
        self.view_timeResend.isHidden = true
        view_OTPtxt.dpOTPViewDelegate = self
        
        switch verificationStatus {
        case "Emailupdate":
            OTPverificationDetaiilLbl.text = "Please type the verification code sent to \(emailtobeUpdate)"
            
        case "EmailVerified":
            viewModelVerifyEmail.email = emailtobeUpdate
            OTPverificationDetaiilLbl.text = "Please type the verification code sent to \(emailtobeUpdate)"
            
        case "UpdatePhone":
            viewModelUpdatePhone.countryCode = countryCode
            viewModelUpdatePhone.phone = phonetobeUpdate
            
            let countryCode = "\(countryCode)"
            let phone = "\(phonetobeUpdate)"
            let fullText = "Please type the verification code send to \(phone)"
            let boldPart = "\(phone)"

            // Create NSMutableAttributedString
            let attributedString = NSMutableAttributedString(string: fullText)

            // Find the range of the bold part
            if let range = fullText.range(of: boldPart) {
                let nsRange = NSRange(range, in: fullText)
                
                // Apply bold font to that range
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
            }

            self.OTPverificationDetaiilLbl.attributedText = attributedString
            
        case "PhoneVerified":
            viewModelVerifyPhone.countryCode = countryCode
            viewModelVerifyPhone.phone = phonetobeUpdate
            
            let countryCode = "\(countryCode)"
            let phone = "\(phonetobeUpdate)"
            let fullText = "Please type the verification code send to \(countryCode)\(phone)"
            let boldPart = "\(countryCode)\(phone)"

            // Create NSMutableAttributedString
            let attributedString = NSMutableAttributedString(string: fullText)

            // Find the range of the bold part
            if let range = fullText.range(of: boldPart) {
                let nsRange = NSRange(range, in: fullText)
                
                // Apply bold font to that range
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
            }

            self.OTPverificationDetaiilLbl.attributedText = attributedString
        default:
            OTPverificationDetaiilLbl.text = "Please enter the verification code"
        }
        
    }
    
    private func bindViewModel() {
        
        viewModelEmailVerifyOTP.userID = self.userID
        viewModelEmailVerifyOTP.otpCode = self.OTP
        
        viewModelPhoneVerifyOTP.userID = self.userID
        viewModelPhoneVerifyOTP.otpCode = self.OTP
        
    }
    @IBAction func btnSubmitOTPVerification_Tap(_ sender: UIButton) {
        print("yahi api hit hogi")
        print(verificationStatus,"verificationStatus")
        if verificationStatus == "EmailVerified" {
            if view_OTPtxt.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModelEmailVerifyOTP.verifyEmailOtp()
            }
        }
        if verificationStatus == "Emailupdate" {
            if view_OTPtxt.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModelEmailVerifyOTP.verifyEmailUpdateOtp()
            }
        }
        if verificationStatus == "PhoneVerified" {
            if view_OTPtxt.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModelPhoneVerifyOTP.verifyPhoneOtp()
            }
        }
        if verificationStatus == "UpdatePhone" {
            if view_OTPtxt.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModelPhoneVerifyOTP.apiForVerifyUpdatePhoneOTP()
            }
        }
    }
    
    @IBAction func btnResendOTPVerificaiton_Tap(_ sender: UIButton) {
        self.view_OTPtxt.text = ""
        if verificationStatus == "EmailVerified" {
            viewModelVerifyEmail.email = self.emailtobeUpdate
            viewModelVerifyEmail.apiforEmailVerification()
        }
        if verificationStatus == "PhoneVerified" {
            viewModelVerifyPhone.phone = self.phonetobeUpdate
            viewModelVerifyPhone.countryCode = self.countryCode
            viewModelVerifyPhone.apiForPhoneVerification()
        }
        if verificationStatus == "UpdatePhone" {
            print("api for update phone number")
            viewModelUpdatePhone.phone = self.phonetobeUpdate
            viewModelUpdatePhone.countryCode = self.countryCode
            viewModelUpdatePhone.apiForPhoneUpdate()
        }
        if verificationStatus == "Emailupdate" {
            viewModelVerifyEmail.email = self.emailtobeUpdate
            viewModelVerifyEmail.apiforEmailUpdate()
        }
        view_timeResend.isHidden = false
        sender.isUserInteractionEnabled = false
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        var runCount = Int()
        runCount = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            runCount -= 1
            let minutes = runCount / 60
            let seconds = runCount % 60
            self.lbl_time.text = String(format: "%02d:%02dsec", minutes, seconds)
            if runCount == 0 {
                self.lbl_time.text = "00:00sec"
                self.view_timeResend.isHidden = true
                sender.isUserInteractionEnabled = true
                sender.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                timer.invalidate()
            }
        }
    }
    @IBAction func btnCrossOTPVerification_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.backAction("No")
        }
        
        self.view_OTPtxt.text = ""
        
        resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
        self.lbl_time.text = "00:00sec"
        self.resendBtnO.isUserInteractionEnabled = true
        timer.invalidate()
        self.view_timeResend.isHidden = true
        
    }
    
}
extension CodeVerifierVC {
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
                    
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.emailtobeUpdate = "\(response.data?.email ?? "")"
                    self.OTP = "\(response.data?.otp ?? 0)"
                    
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
                    
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.emailtobeUpdate = "\(response.data?.otpSendTo ?? "")"
                    self.OTP = "\(response.data?.otp ?? 0)"
                    
                })
            }.store(in: &cancellables)
        
        // EmailVerified Result
        viewModelEmailVerifyOTP.$emailVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "0","RESULT AFTER VERIFICATION")
                    self.showToast(response.message ?? "")
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_timeResend.isHidden = true
                    self.dismiss(animated: true) {
                        self.backAction("Yes")
                    }
                })
            }.store(in: &cancellables)
        // Email Update Result
        viewModelEmailVerifyOTP.$emailUpdateVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "0","RESULT AFTER VERIFICATION")
                    self.showToast(response.message ?? "")
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_timeResend.isHidden = true
                    self.dismiss(animated: true) {
                        self.backAction("Yes")
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
                })
            }.store(in: &cancellables)
        //Result phoneVerification
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
                })
            }.store(in: &cancellables)
        
        // Phone Update verification Result
        viewModelPhoneVerifyOTP.$phoneVerifiedResultUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.dismiss(animated: true) {
                        self.backAction("Yes")
                    }
                })
            }.store(in: &cancellables)
        
        // Phone Confirm Verification Result
        viewModelPhoneVerifyOTP.$phoneVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.dismiss(animated: true) {
                        self.backAction("Yes")
                    }
                })
            }.store(in: &cancellables)
    }
}
extension CodeVerifierVC :DPOTPViewDelegate{
    func dpOTPViewAddText(_ text: String, at position: Int) {
        viewModelEmailVerifyOTP.updateOTPText(text)
        viewModelPhoneVerifyOTP.updateOTPText(text)
    }
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
}
