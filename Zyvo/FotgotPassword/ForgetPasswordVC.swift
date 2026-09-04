//
//  ForgetPasswordVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine

class ForgetPasswordVC: UIViewController {
    var comingFrom = ""
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var view_Phone: UIView!
    @IBOutlet weak var detailLbl: UILabel!
    
    private var viewModel = ForgotPasswordViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLbl.font = UIFont(name: "Poppins", size: 15)!
        bindViewModel()
        bindVC()
        
        view_Email.layer.cornerRadius = view_Email.layer.frame.height / 2
        view_Email.layer.borderWidth = 1.25
        view_Email.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 2/255, alpha: 0.08).cgColor
        
        view_Phone.layer.cornerRadius = view_Phone.layer.frame.height / 2
        view_Phone.layer.borderWidth = 1.25
        view_Phone.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 2/255, alpha: 0.08).cgColor
        
    }
    
    private func bindViewModel() {
        emailTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
    }
    
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        
        guard viewModel.isForgetPasswordValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
            }
            return
        }
        viewModel.forgetPasswordApi()
    }
    @IBAction func btnClose_Tap(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
}

extension ForgetPasswordVC {
    private func tobeVerify(userid:Int,OTP:String,email:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.comingFrom = self.comingFrom
        vc.OTP = OTP
        vc.userID = "\(userid)"
        vc.email = email
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func bindVC(){
        viewModel.$forgetPasswordResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.email ?? "0","email")
                    print(response.data?.otp ?? 0,"otp")
                    self.tobeVerify(userid: (response.data?.userID ?? 0), OTP: "\(response.data?.otp ?? 0)", email: "\(response.data?.email ?? "0")")
                })
            }.store(in: &cancellables)
    }
}
