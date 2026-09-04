//
//  NewPasswordVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine
import IQKeyboardManagerSwift
class NewPasswordVC: UIViewController {
    
    @IBOutlet weak var lbl_EnterPassword: UILabel!
    var comingFrom = ""
    var userID = ""
    
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var view_Paasword: UIView!
    @IBOutlet weak var view_newPassword: UIView!
    var backAction : (_ value: String) -> () = {_ in}
    
    private var viewModel = PasswordSetViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_EnterPassword.font = UIFont(name: "Poppins_Medium", size: 11.5)
        IQKeyboardManager.shared.enable = true
        print(self.comingFrom,"ComingFrom")
        
        print(self.userID,"userID")
        
        viewModel.userID = self.userID
        self.imgPassword.isHidden = true
        self.imgNewPassword.isHidden = true
        bindViewModel()
        bindVC()
        
        view_Paasword.layer.cornerRadius = view_Paasword.layer.frame.height / 2
        view_Paasword.layer.borderWidth = 1.25
        view_Paasword.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        view_newPassword.layer.cornerRadius = view_newPassword.layer.frame.height / 2
        view_newPassword.layer.borderWidth = 1.25
        view_newPassword.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
    }
    
    private func bindViewModel() {
        passwordTF.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.newPassword = text ?? ""
                self.updatePasswordValidationUI()
                
            }
            .store(in: &cancellables)
        
        newPasswordTF.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.confirmnewPassword = text ?? ""
                self.updateConfirmPasswordValidationUI()
            }
            .store(in: &cancellables)
    }
    
    
//    private func updatePasswordValidationUI() {
//        // Example rule: valid if 6 or more characters
//        if viewModel.newPassword.count >= 6 {
//            imgPassword.image = UIImage(named: "imgrightsignicon")
//        } else {
//            imgPassword.image = UIImage(named: "imgcancelicon")
//        }
//    }
    
    private func updatePasswordValidationUI() {
        let password = viewModel.newPassword
        if password.isEmpty {
            self.imgPassword.isHidden = true
        } else {
            imgPassword.isHidden = false

            if password.isPasswordValid() {
                imgPassword.image = UIImage(named: "imgrightsignicon")
            } else {
                imgPassword.image = UIImage(named: "imgcancelicon")
            }
        }
    }
    
    private func updateConfirmPasswordValidationUI() {
        let confirmPassword = viewModel.confirmnewPassword
        let newPassword = viewModel.newPassword

        let isMatching = confirmPassword == newPassword
        let isNewPasswordValid = newPassword.isPasswordValid()
        let shouldShowIcon = !confirmPassword.isEmpty

        imgNewPassword.isHidden = !shouldShowIcon

        if shouldShowIcon {
            let isValid = isMatching && isNewPasswordValid
            imgNewPassword.image = UIImage(named: isValid ? "imgrightsignicon" : "imgcancelicon")
        }
    }
//
//    private func updateConfirmPasswordValidationUI() {
//        let isMatching = viewModel.confirmnewPassword == viewModel.newPassword
//        let isLengthValid = viewModel.newPassword.count >= 6
//        let isConfirmNotEmpty = !viewModel.confirmnewPassword.isEmpty
//        
//        let password = viewModel.confirmnewPassword
//        if password.isEmpty {
//            self.imgNewPassword.isHidden = true
//        } else {
//            imgNewPassword.isHidden = false
//        }
//        
//        if isMatching && isLengthValid && isConfirmNotEmpty {
//            self.imgNewPassword.isHidden = false
//            imgNewPassword.image = UIImage(named: "imgrightsignicon")
//        } else {
//            self.imgNewPassword.isHidden = false
//            imgNewPassword.image = UIImage(named: "imgcancelicon")
//        }
//    }
    
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        if comingFrom == "PassChange"{
            
            guard viewModel.isResetPassword else {
                if let error = viewModel.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            if passwordTF.text != newPasswordTF.text {
                self.showAlert(for: "Passwords do not match")
            } else {
                viewModel.apiforCreatePassword()
            }
        }else{
            guard viewModel.isResetPassword else {
                if let error = viewModel.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            if passwordTF.text != newPasswordTF.text {
                self.showAlert(for: "Passwords do not match")
            } else {
                viewModel.apiforCreatePassword()
            }
        }
    }
    
    @IBAction func btnClose_Tap(_ sender: UIButton) {
        if comingFrom == "PassChange"{
            self.dismiss(animated: true)
            self.backAction("Cancel")
        }else{
            self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
        }
    }
}

extension NewPasswordVC {
    
    func bindVC(){
        viewModel.$ResetPwdResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.success ?? false,"Result")
                    if (response.success ?? false) == true {
                        
                        if self.comingFrom == "PassChange" {
                            self.dismiss(animated: true)
                            self.backAction("Okay")
                            
                        } else {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                            vc.comesFrom = self.comingFrom
                            self.navigationController?.pushViewController(vc, animated: false) }
                        
                    }
                })
            }.store(in: &cancellables)
    }
}
