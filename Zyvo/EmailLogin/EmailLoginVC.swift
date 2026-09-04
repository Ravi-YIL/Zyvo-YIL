//
//  EmailLoginVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine


class EmailLoginVC: UIViewController {
    
    @IBOutlet weak var view_Password: UIView!
    @IBOutlet weak var RegisterNow: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var view_email: UIView!
    
    @IBOutlet weak var lbl_Account: UILabel!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    private var viewModel = EmailLoginViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var KeepMeLogin = "No"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindVC()
        
        lbl_Account.text = "Enter your email and password to login your account"
        
        view_email.layer.cornerRadius = view_email.layer.frame.height / 2
        view_email.layer.borderWidth = 1.25
        view_email.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        view_Password.layer.cornerRadius = view_Password.layer.frame.height / 2
        view_Password.layer.borderWidth = 1.25
        view_Password.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        RegisterNow.layer.cornerRadius = RegisterNow.layer.frame.height / 2
                
        RegisterNow.layer.borderWidth = 1.25
        RegisterNow.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15).cgColor
        
    }
    private func bindViewModel() {
        emailTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.Password, on: viewModel)
            .store(in: &cancellables)
    }
    @IBAction func btnCheck(_ sender: UIButton) {
        if KeepMeLogin == "No"{
            self.KeepMeLogin = "Yes"
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
            self.btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
        }else{
            self.KeepMeLogin = "No"
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
            self.btnCheck.setImage(UIImage(named: "Greenblank"), for: .normal)
        }
    }
    
    @IBAction func passHide_ShowBtn(_ sender: UIButton){
        if sender.isSelected == false{
            sender.isSelected = true
            passwordTF.isSecureTextEntry = false
        }else{
            sender.isSelected = false
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if emailTF.text == "" && passwordTF.text == ""{
            self.showAlert(for: "Please enter your email and password")
        } else {
            guard viewModel.isSignUpValid else {
                if let error = viewModel.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            viewModel.loginByEmailApi()
        }
    }
    
    @IBAction func btnforgetPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        vc.comingFrom = "LoginEmailForgetPassword"
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    @IBAction func btnclose(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailRegisterVC") as! EmailRegisterVC
        self.navigationController?.pushViewController(vc, animated:false)
    }
    
}


extension EmailLoginVC {
    private func tobeVerify(userid: String, token: String, is_profile_complete: String, fullName: String = "") {
        if userid != "" && token != "" {
            let isprofileComplete = UserDetail.shared.getisCompleteProfile()
            if isprofileComplete == "true" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
                vc.fullName = fullName
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

    func bindVC(){
        
        viewModel.$emailLoginResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.token ?? 0,"token")
                    print(response.data?.isprofilecomplete ?? false,"isprofilecomplete Status")
                    print(response.data?.imgProfileurl ?? "")
                    
                    let image = response.data?.imgProfileurl ?? ""
                    let imgURL = AppURL.imageURL + image
                    
                    WhereSaveData.shared.clearData()
                    FilterSavedData.shared.clearData()
                   
                    UserDetail.shared.setProfileimg(imgURL)
                    
                    UserDetail.shared.setUserId("\(response.data?.userID ?? 0)")
                    UserDetail.shared.setTokenWith("\(response.data?.token ?? "0")")
                    UserDetail.shared.setName(response.data?.fullName ?? "")
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isprofilecomplete ?? false)")
                    
                    UserDetail.shared.setUserType("Email")
                    
                    self.tobeVerify(userid: "\(response.data?.userID ?? 0)", token: response.data?.token ?? "0", is_profile_complete: "\(response.data?.isprofilecomplete ?? false)", fullName: response.data?.fullName ?? "" )
                    
                })
            }.store(in: &cancellables)
    }
}





