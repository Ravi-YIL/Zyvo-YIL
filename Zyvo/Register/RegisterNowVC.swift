//
//  RegisterNowVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine
import CountryPickerView
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class RegisterNowVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var btnLoginHere: UIButton!
    @IBOutlet weak var lbl_Account: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var view_Login: UIView!
    let appleSignIn = HSAppleSignIn()
    let countryPicker = CountryPickerView()
    var social_ID = ""
    var countryCode = ""
    var KeepMeLogin = "No"
    var expectedRegion = ""
    private var viewModelSocial = LoginViewModel()
    private var viewModel = PhoneSignupViewModel()
    private var cancellables = Set<AnyCancellable>()
    let validator = PhoneNumberValidator()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindVC()
       // googleLogin()
        
        countryPicker.delegate = self
        countryPicker.showCountryCodeInView = true
        countryPicker.showPhoneCodeInView = true
        countryCodeTF.inputView = countryPicker
        lbl_Account.text = "Enter your phone to register your\naccount"
        phoneTF.delegate = self
        phoneTF.keyboardType = .numberPad // Set keyboard to number pad
        countryCodeTF.text = "🇺🇸 +1"
        viewModel.countryCode = "+1"
        self.countryCode =  "+1"
        self.expectedRegion = "US"
        countryCodeTF.adjustsFontSizeToFitWidth = false
        continueButton.isEnabled = false // Initially disabled
        phoneTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view_Login.layer.cornerRadius = view_Login.layer.frame.height / 2
        view_Login.layer.borderWidth = 1.25
        view_Login.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.08).cgColor
        
        btnLoginHere.layer.cornerRadius = btnLoginHere.layer.frame.height / 2
        
        btnLoginHere.layer.borderWidth = 1.25
        btnLoginHere.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15).cgColor
    }
    @objc func textFieldDidChange() {
        guard let number = phoneTF.text,
              let code = countryCodeTF.text else {
            continueButton.isEnabled = false
            return
        }
        
        let phoneNumber = (phoneTF.text ?? "")
        let regionCode = expectedRegion // or use "IN" directly
        
//        let isValid = validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
//        print("Is valid: \(isValid)")
        
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
    private func bindViewModel() {
        
        phoneTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModel)
            .store(in: &cancellables)
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text
        let currentText = phoneTF.text ?? ""
        // Create the updated text after replacement
        guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        // Allow only numbers and a maximum of 10 digits
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        
        return isNumeric && updatedText.count <= 15
       // return isNumeric && updatedText.count <= 10
       // return isNumeric && updatedText.count <= 9 || updatedText.count <= 10 || updatedText.count <= 11
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnCheckBox(_ sender: UIButton) {
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
    
    @IBAction func btnContinue_Tap(_ sender: UIButton) {
        
        guard viewModel.isSignUpValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
                // self.showSnackAlert(for: error)
            }
            return
        }
        viewModel.signUpPhoneApi()
    }
    @IBAction func btnLogin_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnGoogle_Tap(_ sender: UIButton) {
        let config = GIDConfiguration(clientID: "81364080009-p0hau9tk8vstu8t73vcehu68iludhr2v.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            //  Print the error if sign in fails
            if let error = error {
                print("Google Sign-In Error:", error.localizedDescription)
                return
            }
            
            guard let user = signInResult?.user else {
                print("Google Sign-In failed: No user object.")
                return
            }
            
            let email = user.profile?.email
            let full_Name = user.profile?.name ?? ""
            let givenName = user.profile?.givenName ?? ""
            let userId = user.userID ?? email ?? full_Name
            
            print("Email:", email ?? "nil")
            print("Full Name:", full_Name)
            print("Given Name:", givenName)
            print("User ID:", userId)
            
            let fullName = full_Name
            let nameComponents = fullName.components(separatedBy: " ")
            
            let firstName = nameComponents.first ?? ""
            let lastName = nameComponents.count > 1 ? nameComponents.last ?? "" : ""
            print("First Name: \(firstName)")
            print("Last Name: \(lastName)")
            self.social_ID = userId
            let emailAddress = email
            UserDetail.shared.setEmailId(emailAddress ?? "email")
            UserDefaults.standard.synchronize()
            
            print("************** Google SignIn Success **************")
            
            if #available(iOS 13.0, *) {
                // your API call here
                self.viewModelSocial.apiforSocialLogin(fName: "\(firstName)", lName: "\(lastName)", Email: emailAddress ?? "", socialID: self.social_ID)
            }
            // 🔥 SIGN OUT AFTER LOGIN
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                GIDSignIn.sharedInstance.signOut()
                print("Signed Out")
            }
        }
    }
    @IBAction func btnFacebook_Tap(_ sender: UIButton) {
        
        
        signInWithFacebook(presentingVC: self) { userData, error in
            if let error = error {
                print("Facebook Login Error: \(error.localizedDescription)")
                return
            }
            print("✅ Facebook User: \(userData ?? [:])")
            
            guard let userData = userData else {
                print("❌ No user data received from Facebook.")
                return
            }
            
            //            var typeUser  = ""
            //            if self.role == "attorney"{
            //                typeUser = "0" //attorney
            //            }else{
            //                typeUser = "1" //consumer
            //            }
            var emailNeedtoSent = ""
            let facebookID = userData["id"] as? String ?? ""
            self.social_ID = facebookID
            let fullName = userData["name"] as? String ?? ""
            let email = userData["email"] as? String ?? ""
            emailNeedtoSent = email
            
            let nameComponents = fullName.components(separatedBy: " ")
            
            let firstName = nameComponents.first ?? ""
            let lastName = nameComponents.count > 1 ? nameComponents.last ?? "" : ""
            print("First Name: \(firstName)")
            print("Last Name: \(lastName)")
            
            var profileImageURL: String = ""
            if let pictureData = userData["picture"] as? [String: Any],
               let data = pictureData["data"] as? [String: Any],
               let url = data["url"] as? String {
                profileImageURL = url
            }
           
            print("✅ Facebook User Data:")
            print("ID: \(facebookID)")
            print("Name: \(fullName)")
            print("Email: \(email)")
            print("Profile Image: \(profileImageURL)")
            
            if email == "" {
                emailNeedtoSent = "\(facebookID)@facebook.com"
            }
            
            if #available(iOS 13.0, *) {
                self.viewModelSocial.apiforSocialLogin(fName: "\(firstName)", lName: "\(lastName)", Email: emailNeedtoSent, socialID: self.social_ID)
            } else {
                
            }
        }
        
    }
    
    func signInWithFacebook(presentingVC: UIViewController, completion: @escaping (_ userData: [String: Any]?, _ error: Error?) -> Void) {
        let loginManager = LoginManager()
       
        loginManager.logIn(permissions: ["public_profile", "email"], from: presentingVC) { result, error in
            // Handle any login error
            if let error = error {
                completion(nil, error)
                return
            }
            
            // ✅ Handle cancel action
            guard let result = result, !result.isCancelled else {
                print("⚠️ Facebook Login Cancelled by user.")
                completion(nil, NSError(domain: "FacebookLogin", code: 999, userInfo: [NSLocalizedDescriptionKey: "User cancelled login"]))
                return
            }
            
            // Ensure we have a valid access token
            guard let token = AccessToken.current?.tokenString else {
                completion(nil, NSError(domain: "FacebookLogin", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token missing"]))
                return
            }
            
            // Request user data from Facebook Graph API
            let request = GraphRequest(
                graphPath: "me",
                parameters: ["fields": "id,name,email,first_name,last_name,picture.type(large)"],
                tokenString: token,
                version: "v19.0",
                httpMethod: .get
            )
            
            request.start { connection, result, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let userData = result as? [String: Any] {
                    completion(userData, nil)
                } else {
                    completion(nil, NSError(domain: "FacebookLogin", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user data"]))
                }
            }
        }
    }
    @IBAction func btnApple_Tap(_ sender: UIButton) {
        
        appleSignIn.didTapLoginWithApple1 { (userInfo, message) in

            if let userInfo = userInfo {

                // First Name
                let firstName = userInfo.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                let finalFirstName: String
                if !firstName.isEmpty {
                    finalFirstName = firstName
                    UserDefaults.standard.set(firstName, forKey: "AppleFirstName")
                } else {
                    finalFirstName = UserDefaults.standard.string(forKey: "AppleFirstName") ?? "Guest"
                }

                // Last Name
                let lastName = userInfo.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                let finalLastName: String
                if !lastName.isEmpty {
                    finalLastName = lastName
                    UserDefaults.standard.set(lastName, forKey: "AppleLastName")
                } else {
                    finalLastName = UserDefaults.standard.string(forKey: "AppleLastName") ?? "User"
                }

                // Email
                let emailString = userInfo.email.trimmingCharacters(in: .whitespacesAndNewlines)

                let finalEmail: String
                if !emailString.isEmpty {
                    finalEmail = emailString
                    UserDefaults.standard.set(emailString, forKey: "AppleEmail")
                } else {
                    finalEmail = UserDefaults.standard.string(forKey: "AppleEmail")
                        ?? "\(finalFirstName.lowercased())@gmail.com"
                }

                print(finalFirstName, "finalFirstName")
                print(finalLastName, "finalLastName")
                print(finalEmail, "finalEmail")

                self.social_ID = "\(userInfo.userid)"

                self.viewModelSocial.apiforSocialLogin(
                    fName: finalFirstName,
                    lName: finalLastName,
                    Email: finalEmail,
                    socialID: self.social_ID
                )

            
        }else if let message = message{
                print("Error Message: \(message)")
                AlertController.alert(title: "Alert", message: "Error Message: \(message)")
            }else{
                print("Unexpected error!")
                AlertController.alert(title: "Alert", message: "Unexpected error!")
            }
        }
    }
    @IBAction func btnEmail_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension RegisterNowVC {
    private func tobeVerify(Otp:Int,tempID:Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.comingFrom = "RegisterPhone"
        vc.tempID = "\(tempID)"
        vc.OTP = "\(Otp)"
        vc.countryCode = self.countryCode
        vc.phone = self.phoneTF.text ?? ""
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func bindVC(){
        viewModel.$signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    //print(response.data?.token ?? "","token")
                    //  UserDetail.shared.setTokenWith(response.data?.otp )
                    print(response.data?.otp ?? 0,"OTP")
                    print(response.data?.tempID ?? 0,"TempID")
                    print(response.data?.isprofilecomplete ?? false, "is_profile_complete Status")
                    
                    WhereSaveData.shared.clearData()
                    FilterSavedData.shared.clearData()
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isprofilecomplete ?? false)")
                    
                    self.tobeVerify(Otp: response.data?.otp ?? 0, tempID: response.data?.tempID ?? 0)
                })
            }.store(in: &cancellables)
        
        
        viewModelSocial.$socialsignUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.token ?? "","Token social Login at Signup")
                    // print(response.data?.isloginfirst ?? "false","isloginfirst")
                    let logintime = "\(response.data?.isLoginFirst ?? false)"
                    let userid = "\(response.data?.userID ?? 0)"
                    let tokens = "\(response.data?.token ?? "")"
                    
                    UserDetail.shared.setKeepMeLogin("Yes")
                    
                    let image = response.data?.userImage ?? ""
                    let imgURL = AppURL.imageURL + image
                    UserDetail.shared.setProfileimg(imgURL)
                    let profileurl  = UserDetail.shared.getProfileimg()
                    print(profileurl,"profile url")
                    
                    let iscompleteProfile = "\(response.data?.isProfileComplete ?? false)"
                    UserDetail.shared.setName(response.data?.fullName ?? "")
                    
                    WhereSaveData.shared.clearData()
                    FilterSavedData.shared.clearData()
                    
                    UserDetail.shared.setisCompleteProfile(iscompleteProfile)
                    
                    UserDetail.shared.setlogintType("Guest")
                    UserDetail.shared.setTokenWith(tokens)
                    UserDetail.shared.setUserId(userid)
                    if logintime == "true" || iscompleteProfile == "false" {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC
                        nextVC?.fullName = response.data?.fullName ?? ""
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    } else {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
//                    if logintime == "false" || iscompleteProfile == "false" {
//                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC
//                        nextVC?.fullName = response.data?.fullName ?? ""
//                        self.navigationController?.pushViewController(nextVC!, animated: true) }
//                    else {
//                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC
//                        self.navigationController?.pushViewController(nextVC!, animated: true)
//                    }
                    
                })
            }.store(in: &cancellables)
    }
}
extension RegisterNowVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
      
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
        countryCodeTF.text = "\(flag) \(code)"
        viewModel.countryCode = "\(code)"
        self.countryCode = "\(code)"
        let phoneNumber = (phoneTF.text ?? "")
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

