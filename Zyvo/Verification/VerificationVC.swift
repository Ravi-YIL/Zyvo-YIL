//
//  VerificationVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine

class VerificationVC: UIViewController  {
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var view_timeResend: UIView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var OtpView: DPOTPView!
    private var viewModelPhone = LoginViewModel()
    private var viewModel = VerificationViewModel()
    private var viewModelSignUp = PhoneSignupViewModel()
    private var viewModelEmail = EmailRegisterViewModel()
    private var viewModelforgotPassword = ForgotPasswordViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var OTP = ""
    var userID = ""
    var tempID = ""
    var phone = ""
    var email = ""
    var password = ""
    var comingFrom = ""
    var countryCode = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindVC()
        
        viewModel.tempID = tempID
        viewModel.otpCode = OTP
        viewModel.userID = userID
        viewModelforgotPassword.email = self.email
        viewModelEmail.email = self.email
        viewModelEmail.Password = self.password
        
        print(self.comingFrom,"ComingFrom")
        print(self.userID,"userID")
        print(self.tempID,"tempID")
        print(self.OTP,"OTP")
        
        OtpView.dpOTPViewDelegate = self
        view_timeResend.isHidden = false
        btnResend.isUserInteractionEnabled = false
        btnResend.setTitleColor(UIColor.lightGray, for: .normal)
        var runCount = Int()
        runCount = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            // print("Timer fired!")
            
            runCount -= 1
            let minutes = runCount / 60
            let seconds = runCount % 60
            self.lbl_time.text = String(format: "%02d:%02d Sec", minutes, seconds)
            if runCount == 0 {
                self.lbl_time.text = "00:00 Sec"
                self.view_timeResend.isHidden = true
                self.btnResend.isUserInteractionEnabled = true
                self.btnResend.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                timer.invalidate()
            }
        }
        
        if comingFrom == "RegisterEmail"  || comingFrom == "LoginEmail"{
            self.detailLbl.text = "Please type the verification code send         to \(email)"
        }else if comingFrom == "LoginEmailForgetPassword"{
            self.detailLbl.text = "Please type the verification code send             to \(email)"
        }else if comingFrom == "RegisterPhone" {
            let countryCode = "\(countryCode)"
            let phone = "\(phone)"
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

            self.detailLbl.attributedText = attributedString
            //self.detailLbl.text = "Please type the verification code send to \(countryCode)\(phone)"
        }
        else if comingFrom == "LoginPhone" {
            let countryCode = "\(countryCode)"
            let phone = "\(phone)"
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

            self.detailLbl.attributedText = attributedString
           // self.detailLbl.text = "Please type the verification code send to \(countryCode)\(phone)"
        }
    }
    
    private func bindViewModel() {
        viewModel.tempID = tempID
        viewModel.otpCode = OTP
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self, let errorMessage = errorMessage else { return }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if comingFrom == "RegisterPhone" {
            
            if OtpView.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else if OtpView.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModel.verifySignUpOtp() }
        }
        if comingFrom == "LoginPhone" {
            print("goto allow location")
            if OtpView.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else  if OtpView.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModel.apiforOtpVerifyLoginPhone() }
            
        }
        if comingFrom == "RegisterEmail" {
            
            if OtpView.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else  if OtpView.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModel.apiforOtpVerifyEmailSignup()
            }
        }
        
        if comingFrom == "LoginEmailForgetPassword" {
            if OtpView.text?.count == 0 {
                self.showAlert(for: "Please enter the verification code")
            }
            else  if OtpView.text?.count != 4 {
                self.showAlert(for: "Please enter the 4-digit code")
            } else {
                viewModel.apiforOtpVerifyForgotPassword()
            }
        }
        
        if comingFrom == "Login" || comingFrom == "LoginEmail"{
            //  login = "Yes"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnResend_Tap(_ sender: UIButton) {
        self.resend(sender: sender)
    }
}

extension VerificationVC :DPOTPViewDelegate{
    func dpOTPViewAddText(_ text: String, at position: Int) {
        viewModel.updateOTPText(text)
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
 }

  extension VerificationVC {
    func resend(sender:UIButton){
        self.OtpView.text = ""
        viewModelSignUp.countryCode = self.countryCode
        viewModelSignUp.phone = self.phone
        if comingFrom == "LoginPhone" {
            viewModelPhone.countryCode = self.countryCode
            viewModelPhone.phone = self.phone
            viewModelPhone.loginByPhoneApi()
        }
        if comingFrom == "RegisterEmail" {
            viewModelEmail.signUpEmailApi()
        }
        if comingFrom == "RegisterPhone" {
            viewModelSignUp.signUpPhoneApi()
        }
        if comingFrom == "LoginEmailForgetPassword" {
            viewModelforgotPassword.forgetPasswordApi()
        }
        view_timeResend.isHidden = false
        sender.isUserInteractionEnabled = false
        btnResend.setTitleColor(UIColor.lightGray, for: .normal)
        var runCount = Int()
        runCount = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            // print("Timer fired!")
            
            runCount -= 1
            let minutes = runCount / 60
            let seconds = runCount % 60
            self.lbl_time.text = String(format: "%02d:%02d Sec", minutes, seconds)
            if runCount == 0 {
                self.lbl_time.text = "00:00 Sec"
                self.view_timeResend.isHidden = true
                sender.isUserInteractionEnabled = true
                self.btnResend.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                timer.invalidate()
            }
        }
    }
}

extension VerificationVC {
    private func tobeVerifybyLogin(userID:Int,token:String, isProfileCompleted:Bool){
        print(userID,token,"userID,token")
        
        if isProfileCompleted == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    private func tobeVerify(userID:Int,token:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnNotificationVC") as! TurnOnNotificationVC
        vc.signUpWith = "Phone"
        UserDetail.shared.setUserType("Phone")
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func tobeVerifyEmailSignUp(userID:Int,token:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnNotificationVC") as! TurnOnNotificationVC
        vc.signUpWith = "Email"
        UserDetail.shared.setUserType("Email")
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func bindVC(){
        viewModel.$verifyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.token ?? "","token")
                    UserDetail.shared.setUserId("\(response.data?.userID ?? 0)")
                    UserDetail.shared.setTokenWith("\(response.data?.token ?? "0")")
                    
                   // let isprofileCompleted = response.data?.isProfileCompleted ?? false
                    
                    let image = response.data?.imgProfileUrl ?? ""
                    let imgURL = AppURL.imageURL + image
                   
                    
                    
                    UserDetail.shared.setProfileimg(imgURL)
                    
                    let adf = response.data?.isProfileComplete ?? false
                    
                    if self.comingFrom == "RegisterPhone" {
                        self.tobeVerify(userID: response.data?.userID ?? 0, token: response.data?.token ?? "")}
                    if self.comingFrom == "LoginPhone" {
                        
                   
                        
                        self.tobeVerifybyLogin(userID: response.data?.userID ?? 0, token: response.data?.token ?? "",isProfileCompleted : adf)}
                    if self.comingFrom == "RegisterEmail" {
                        
                        self.tobeVerifyEmailSignUp(userID: response.data?.userID ?? 0, token: response.data?.token ?? "")
                    }
                })
            }.store(in: &cancellables)
        
        viewModelSignUp.$signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.data?.otp ?? 0,"OTP")
                    print(response.data?.tempID ?? 0,"TempID")
                    print(response.data?.isprofilecomplete ?? false,"isprofilecomplete Status")
                    
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isprofilecomplete ?? false)")
                    
                    self.OTP = "\(response.data?.otp ?? 0)"
                    self.tempID = "\(response.data?.tempID ?? 0)"
                    
                    self.viewModel.Otp = "\(response.data?.otp ?? 0)"
                    self.viewModel.tempID = "\(response.data?.tempID ?? 0)"
                })
            }.store(in: &cancellables)
        
        viewModelEmail.$emailSignupResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.tempID ?? 0,"tempID")
                    print(response.data?.otp ?? 0,"otp")
                    
                    self.OTP = "\(response.data?.otp ?? 0)"
                    self.tempID = "\(response.data?.tempID ?? 0)"
                    
                })
            }.store(in: &cancellables)
        
        viewModelPhone.$loginResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP = "\(response.data?.otp ?? 0)"
                    
                })
            }.store(in: &cancellables)
        
        
        viewModel.$verifyforgotPasswordResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    if response.success == true {
                        print(response.message ?? "")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                        vc.comingFrom = self.comingFrom
                        vc.userID = self.userID
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    else {
                        print(response.message ?? "")
                    }
                })
            }.store(in: &cancellables)
        
        
        viewModelforgotPassword.$forgetPasswordResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    
                    print(response.message ?? "")
                    
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.email ?? "0","email")
                    print(response.data?.otp ?? 0,"otp")
                    
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP = "\(response.data?.otp ?? 0)"
                })
            }.store(in: &cancellables)
        
    }
    
}
