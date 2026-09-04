//
//  ChangeNameVC.swift
//  Zyvo
//
//  Created by ravi on 18/10/24.
//

import UIKit
import Combine

class ChangeNameVC: UIViewController {
    var firstName = ""
    var lastName = ""
    var profileIMGURL = ""
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var view_LastName: UIView!
    @IBOutlet weak var view_FirstName: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    
    @IBOutlet weak var profileImg: UIImageView!
    private var viewModel = UpdateNameViewModel()
    private var cancellables = Set<AnyCancellable>()
    var backAction:(_ strfName : String,_ strlName : String ) -> () = { strfName,strlName  in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstName != "" {
            fName.text = firstName
            viewModel.firstName = firstName
        }
        if lastName != "" {
            lName.text = lastName
            viewModel.lastName = lastName
        }
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
        
        let imgURL = profileIMGURL
        self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
        
        bindViewModel()
        bindVC()
        fName.delegate = self
        lName.delegate = self
        
        view_ProfileDetails.layer.cornerRadius = view_ProfileDetails.layer.frame.height / 2
        view_ProfileDetails.layer.borderWidth = 3
        view_ProfileDetails.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.18).cgColor
        
        view_LastName.layer.cornerRadius = 15
        view_LastName.layer.borderWidth = 0.75
        view_LastName.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view_FirstName.layer.cornerRadius = 15
        view_FirstName.layer.borderWidth = 0.75
        view_FirstName.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    private func bindViewModel() {
        
        fName.textPublisher
            .compactMap { $0 }
            .assign(to: \.firstName, on: viewModel)
            .store(in: &cancellables)
        
        
        lName.textPublisher
            .compactMap { $0 }
            .assign(to: \.lastName, on: viewModel)
            .store(in: &cancellables)
        
    }
    
    
    @IBAction func btnSaveChange_Tap(_ sender: UIButton) {
        
        guard viewModel.isNameValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
                // self.showSnackAlert(for: error)
            }
            return
        }
        viewModel.apiForUpdateName()
        
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension ChangeNameVC {
    private func tobeVerify(userid:Int,Fname:String,Lname:String){
        self.dismiss(animated: false) {
            self.backAction("\(Fname)", "\(Lname)")
        }
    }
    func bindVC(){
        
        viewModel.$updateNameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.fname ?? "0","fName")
                    print(response.data?.lname ?? "0","lName")
                    self.tobeVerify(userid: response.data?.userID ?? 0, Fname: response.data?.fname ?? "0", Lname: response.data?.lname ?? "0")
                })
            }.store(in: &cancellables)
    }
}

extension ChangeNameVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Set max length for first and last name
        let maxLength = 15 // Customize this limit
        // Current text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        // New text after input
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
}

