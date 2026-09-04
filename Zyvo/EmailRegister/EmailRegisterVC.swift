//
//  EmailRegisterVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine

class EmailRegisterVC:UIViewController {
    
    @IBOutlet weak var imgRightSign: UIImageView!
    @IBOutlet weak var btnLoginHere: UIButton!
    @IBOutlet weak var view_Password: UIView!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var KeepMeLogin = "No"
    
    private var viewModel = EmailRegisterViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindVC()
        
        self.imgRightSign.isHidden = true
        
        view_email.layer.cornerRadius = view_email.layer.frame.height / 2
        view_email.layer.borderWidth = 1.25
        view_email.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        view_Password.layer.cornerRadius = view_Password.layer.frame.height / 2
        view_Password.layer.borderWidth = 1.25
        view_Password.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        btnLoginHere.layer.cornerRadius = btnLoginHere.layer.frame.height / 2
        
        btnLoginHere.layer.borderWidth = 1.25
        btnLoginHere.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15).cgColor
        
        
    }
    
    //    private func bindViewModel() {
    //
    //        emailTF.textPublisher
    //            .compactMap { $0 }
    //            .assign(to: \.email, on: viewModel)
    //            .store(in: &cancellables)
    //
    //        passwordTF.textPublisher
    //            .compactMap { $0 }
    //            .assign(to: \.Password, on: viewModel)
    //            .store(in: &cancellables)
    //       // updatePasswordValidationUI()
    //        updatePasswordValidationUI()
    //
    //    }
    
    private func bindViewModel() {
        emailTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTF.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.Password = text ?? ""
                self.updatePasswordValidationUI()
            }
            .store(in: &cancellables)
    }
    
    private func updatePasswordValidationUI() {
        let password = viewModel.Password
        
        if password.isEmpty {
            self.imgRightSign.isHidden = true
        } else {
            imgRightSign.isHidden = false
            
            if password.isPasswordValid() {
                self.imgRightSign.image = UIImage(named: "imgrightsignicon")
                
            } else {
                self.imgRightSign.image = UIImage(named: "imgcancelicon")
            }
        }
    }
    
    @IBAction func btnEye_Tap(_ sender: UIButton) {
        
        //        if sender.isSelected == false{
        //            sender.isSelected = true
        //            passwordTF.isSecureTextEntry = false
        //        }else{
        //            sender.isSelected = false
        //            passwordTF.isSecureTextEntry = true
        //        }
    }
    
    
    //    private func updatePasswordValidationUI() {
    //        // Example rule: valid if 6 or more characters
    //        if viewModel.Password.count >= 6 {
    //            self.btnEye.isHidden = false
    //            self.btnEye.setImage(UIImage(named: "imgrightsignicon"), for: .normal)
    //
    //        } else {
    //            self.btnEye.isHidden = false
    //            self.btnEye.setImage(UIImage(named: "imgcancelicon"), for: .normal)
    //
    //        }
    //    }
    
    @IBAction func btnCheck(_ sender: UIButton) {
        if KeepMeLogin == "No"{
            self.KeepMeLogin = "Yes"
            self.btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
        }else{
            self.KeepMeLogin = "No"
            self.btnCheck.setImage(UIImage(named: "Greenblank"), for: .normal)
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnclose(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnCreateAccount(_ sender: UIButton) {
        if emailTF.text == "" && passwordTF.text == ""{
            self.showAlert(for: "Please enter your email and password")
        }
        else {
            guard viewModel.isSignUpValid else {
                if let error = viewModel.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            viewModel.signUpEmailApi()
        }
    }
}

extension EmailRegisterVC {
    private func tobeVerify(tempid:Int,OTP:Int){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.comingFrom = "RegisterEmail"
        vc.tempID = "\(tempid)"
        vc.OTP = "\(OTP)"
        vc.email = self.emailTF.text ?? ""
        vc.password = self.passwordTF.text ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    func bindVC(){
        
        viewModel.$emailSignupResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.tempID ?? 0,"tempID")
                    print(response.data?.otp ?? 0,"otp")
                    
                    WhereSaveData.shared.clearData()
                    FilterSavedData.shared.clearData()
                    
                    self.tobeVerify(tempid: response.data?.tempID ?? 0, OTP: response.data?.otp ?? 0 )
                    
                })
            }.store(in: &cancellables)
        
    }
    
}
