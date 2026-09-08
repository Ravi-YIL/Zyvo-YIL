//
//  CreateProfileVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import CountryPickerView
import Combine
import Persona2
import DropDown
import AVFoundation
//import IQKeyboardManager

class CreateProfileVC: UIViewController,UITextViewDelegate, GMSAutocompleteFetcherDelegate {
    
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {

        self.predictions = predictions

        let predictionTexts = predictions.map {
            $0.attributedFullText.string
        }

        dropDownLocation.dataSource = predictionTexts

        // Long address support
        dropDownLocation.width = UIScreen.main.bounds.width - 40

        dropDownLocation.customCellConfiguration = { index, item, cell in
            cell.optionLabel.numberOfLines = 2
            cell.optionLabel.lineBreakMode = .byWordWrapping
            cell.optionLabel.font = UIFont.systemFont(ofSize: 14)
        }

        DispatchQueue.main.async {
            self.dropDownLocation.show()
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    var OTP = ""
    var userID = ""
    var tempID = ""
    var identity_verify : Int? = 0
    
    var email_verify : Int? = 0
    
    var phone_verify : Int? = 0
    
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    
    @IBOutlet weak var view_verifyIndentityConfirmNow: UIView!
    @IBOutlet weak var view_verifiedIndentity: UIView!
    
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var view_UploadPhoto: UIView!
    @IBOutlet weak var collecV_Place: UICollectionView!
    @IBOutlet weak var collecV_MyWork: UICollectionView!
    @IBOutlet weak var collecV_MyLanguage: UICollectionView!
    @IBOutlet weak var collecV_MyHobbies: UICollectionView!
    @IBOutlet weak var collecV_MyPets: UICollectionView!
    @IBOutlet weak var view_AboutMe: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var viewVerification: UIView!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
   
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var infoBtnO: UIButton!
  
    @IBOutlet weak var txt_aboutMe: UITextView!
    var verificationStatus = ""
    private var placesClient: GMSPlacesClient!
    // var imageArray = [Country]()
    var types = ""
    var locationArray: [String] = [ ]
    var myWorkArr: [String] = []
    var myLanguageArr: [String] = []
    var myHobbiesArr: [String] = []
    var myPetsArr: [String] = []
    var activeTextField: UITextField?
    let infoLabel = UILabel()
    var timer = Timer()
    let countryPicker = CountryPickerView()
    var SignUpWith = ""
    var editEmail_Phone = ""
    
    var firstName = ""
    var lastName = ""
    var fullName = ""
    var countryCode = ""
    
    var expectedRegion = ""
    var viewModel = MyProfileViewModel()
    var profileData : MyProfileModel?
    var viewModelVerifyEmail = EmailVerificationViewModel()
    var viewModelEmailVerifyOTP = OTPEmailVerifyViewModel()
    private var viewModelVerifyPhone = PhoneVerificationViewModel_CreateProfile()
        
    let placeholderText = "Describe here about yourself...."
    let validator = PhoneNumberValidator()
    private var cancellables = Set<AnyCancellable>()
    var profileIMGURL = ""
    var isAboutMeStatus = false
    var indexforDeleteLocation: Int? = 0
    var lastSelectedLocation: String = ""
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    let dropDownLocation = DropDown()
  
    
    var activeLocationTextField: UITextField?
    
    var currentLocationSelectionType: LocationSelectionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Google Autocomplete Fetcher
              let filter = GMSAutocompleteFilter()
              filter.type = .noFilter // You can change this to .address, .establishment, etc.
              
              fetcher = GMSAutocompleteFetcher(filter: filter)
              fetcher.delegate = self
        
        
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
        bindVC()
        
        txt_aboutMe.delegate = self
        txt_aboutMe.text = placeholderText
        txt_aboutMe.textColor = .lightGray
        
        let fullName = self.fullName
        let nameComponents = fullName.components(separatedBy: " ")
        
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.dropFirst().joined(separator: " ")
        self.firstName = firstName
        self.lastName = lastName
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        
        self.lbl_UserName.text = "Hey \(self.firstName)" + " \(self.lastName)!"
        self.keyboardNotifications()
        IQKeyboardManager.shared.enable = false
        placesClient = GMSPlacesClient.shared()
        
        view_UploadPhoto.frame = self.view.bounds
        self.view.addSubview(view_UploadPhoto)
        view_UploadPhoto.isHidden = true
        
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 3
        view_Photo.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        styleView(view_ProfileDetails)
        styleView(view_AboutMe)
        
        let collectionViews = [collecV_Place, collecV_MyWork, collecV_MyLanguage, collecV_MyHobbies, collecV_MyPets]
        collectionViews.forEach { setupCollectionView($0) }
        

        infoLabel.text = "Before you can book or host  on the platform the name on Id must match verification documents."
        
        // Set custom font "Poppins" with size 15
        if let customFont = UIFont(name: "Poppins-Regular", size: 8) {
            infoLabel.font = customFont
        } else {
            print("Custom font 'Poppins-Regular' not found. Ensure it's added to the project.")
        }
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor.white
        infoLabel.textColor = .black
        infoLabel.layer.cornerRadius = 8
        infoLabel.layer.borderWidth = 1
        infoLabel.numberOfLines = 3
        infoLabel.layer.borderColor = UIColor.lightGray.cgColor
        infoLabel.clipsToBounds = true
        infoLabel.frame = CGRect(x: infoBtnO.frame.midX + 2 , y: infoBtnO.frame.maxY - 120 , width: 210, height: 40)
        viewModel.getProfile()
        setupDropDown()
    }
    
    
    func setupDropDown() {

        dropDownLocation.anchorView = btnEditAboutMe
        dropDownLocation.direction = .bottom
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: btnEditAboutMe.bounds.height)

        dropDownLocation.width = UIScreen.main.bounds.width - 40
        dropDownLocation.cellHeight = 50
        
        // Multiline support
         dropDownLocation.customCellConfiguration = { index, item, cell in
             cell.optionLabel.numberOfLines = 2
             cell.optionLabel.lineBreakMode = .byWordWrapping
         }
        
       
        // Use the captured values inside the selection action
        dropDownLocation.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            let prediction = self.predictions[index]
            
            GMSPlacesClient.shared().fetchPlace(
                fromPlaceID: prediction.placeID,
                placeFields: [
                    .formattedAddress,
                    .addressComponents,
                    .coordinate,
                    .name
                ],
                sessionToken: nil
            ) { [weak self] place, error in
                
                guard let self = self else { return }
                
                let selectedLocation: String
                if let place = place, let address = place.formattedAddress, !address.isEmpty {
                    selectedLocation = address
                } else {
                    selectedLocation = item.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                if !selectedLocation.isEmpty {
                    self.lastSelectedLocation = selectedLocation
                    self.viewModel.apiForAddPlace(PlaceName: selectedLocation)
                }
                
                self.dropDownLocation.hide()
                self.view.endEditing(true)
            }
        }
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if txt_aboutMe.text == placeholderText {
            txt_aboutMe.text = ""
            txt_aboutMe.textColor = .black
        }
    }
    
    private func styleRoundedView(_ view: UIView) {
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.85).cgColor
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView?) {
        collectionView?.register(UINib(nibName: "MasterCell", bundle: nil), forCellWithReuseIdentifier: "MasterCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
    }
    
    private func styleView(_ view: UIView, cornerRadius: CGFloat = 15) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.85).cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txt_aboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            txt_aboutMe.text = placeholderText
            txt_aboutMe.textColor = .lightGray
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let usertype = UserDetail.shared.getUserType()
        if usertype == "Email" {
            view_ConfirmNowEmail.isHidden = true
            view_VerifiedEmail.isHidden = false
        }
        if usertype == "Phone" {
            view_ConfirmNowPhone.isHidden = true
            view_VerifiedPhone.isHidden = false
         //   continueButton.isEnabled = true // Initially disabled
        }
    }
    
    
    @IBAction func btnEditAboutMe_Tap(_ sender: UIButton) {
        if isAboutMeStatus {
            
            if txt_aboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || txt_aboutMe.text == placeholderText {
                self.showAlert(for: "Please enter your About Me")
                isAboutMeStatus = false
                txt_aboutMe.isEditable = true
                txt_aboutMe.becomeFirstResponder()
                btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
            } else {
                txt_aboutMe.isEditable = false
                txt_aboutMe.resignFirstResponder()
                viewModel.apiForUpdateAboutMe(AboutMe: txt_aboutMe.text)
                btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            }
        } else {
            
            txt_aboutMe.isEditable = true
            txt_aboutMe.becomeFirstResponder()
            btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
            if txt_aboutMe.text == placeholderText {
                txt_aboutMe.text = ""
                txt_aboutMe.textColor = .black
            }
        }
        isAboutMeStatus.toggle()
    }
    
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
        
        vc.backAction = { fname, lname in
            print(fname, lname,"Data Recieved")
            self.firstName = fname
            self.lastName = lname
            self.viewModel.first_name = self.firstName
            self.viewModel.last_name = self.lastName
            self.lbl_UserName.text = "Hey \(fname)" + " \(lname)!"
            UserDetail.shared.setName("\(fname)" + " \(lname)")
        }
        vc.profileIMGURL = self.profileIMGURL
        vc.firstName = self.firstName
        vc.lastName = self.lastName
        print(firstName)
        print(lastName)
        viewModel.first_name = self.firstName
        viewModel.last_name = self.lastName
        self.present(vc, animated: true)
    }
    
    @IBAction func btnConfirmIndentity_Tap(_ sender: UIButton) {
        checkCameraPermissionAndStartInquiry()
    }
    
    private func checkCameraPermissionAndStartInquiry() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            self.startPersonaInquiry()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self?.startPersonaInquiry()
                    } else {
                        self?.showCameraPermissionAlert()
                    }
                }
            }
        case .restricted, .denied:
            self.showCameraPermissionAlert()
        @unknown default:
            self.showCameraPermissionAlert()
        }
    }
    
    private func startPersonaInquiry() {
        let inquiry = Inquiry.from(templateId: "itmpl_yEu1QvFA5fJ1zZ9RbUo1yroGahx2", delegate: self)
            .build()
            .start(from: self)
    }
    
    private func showCameraPermissionAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required for identity verification.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .default, handler: { _ in
            if UIApplication.shared.canOpenURL(settingsAppURL) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        print("confirm Email here")
        verificationStatus = "EmailVerified"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,"str")
            if userID != "" || email != "" || otp != ""  {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.countryCode = countryCode
                vc.emailtobeUpdate = email
                vc.backAction = { str in
                    print(str,"str recieved")
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.email_verify = 1
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            } }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        print("confirm phone here")
        verificationStatus = "PhoneVerified"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,countryCode,"str Recieved")
            if userID != "" || email != "" || otp != "" || countryCode != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.phonetobeUpdate = email
                vc.countryCode = countryCode
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.phone_verify = 1
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            // self.txt_PhoneProfile.text = email
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    @IBAction func infoBtn(_ sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            infoLabel.removeFromSuperview()
        }else{
            sender.isSelected = true
            viewVerification.addSubview(infoLabel)
        }
    }
    
    @IBAction func btnsaveProfile_Tap(_ sender: UIButton) {
        
        if firstName == "" || lastName == "" {
            self.showAlert(for: "Please update name")
        }else if profileIMGURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || profileIMGURL == AppURL.imageURL {
            self.showAlert(for: "Please upload your profile image")
        }  else if self.phone_verify == 0{
            self.showAlert(for: "Please verify your phone number")
        } else if self.email_verify == 0{
            self.showAlert(for: "Please verify your email")
        } else if self.identity_verify == 0{
            self.showAlert(for: "Please verify your identity")
        }  else if locationArray.count == 0 {
            self.showAlert(for: "Please Add Location (Where I Live)")
        } else if myLanguageArr.count == 0 {
            self.showAlert(for: "Please select language")
        }
            
            else {
            viewModel.first_name = self.firstName
            viewModel.last_name = self.lastName
            viewModel.where_live = self.locationArray
            viewModel.works = self.myWorkArr
            viewModel.languages = self.myLanguageArr
            viewModel.hobbies = self.myHobbiesArr
            viewModel.pets = self.myPetsArr
            viewModel.about_me = self.txt_aboutMe.text
            viewModel.identity_verify = self.identity_verify ?? 0
            viewModel.uploadProfile()
           //viewModel.encodeImageToString(image: profileImg.image ?? UIImage())
        }
    }
    
    @IBAction func btnskipProfile_Tap(_ sender: UIButton) {
        if lbl_UserName.text == "Hey Guest!" {
            self.showAlert(for: "Kindly enter you name.")
        }else if profileIMGURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || profileIMGURL == AppURL.imageURL {
            self.showAlert(for: "Please upload your profile image")
        }  else if self.phone_verify == 0{
            self.showAlert(for: "Please verify your phone number")
        } else if self.email_verify == 0{
            self.showAlert(for: "Please verify your email")
        } else if self.identity_verify == 0{
            self.showAlert(for: "Please verify your identity")
        }  else {
            UserDetail.shared.setisCompleteProfile("true")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func btnSubmit_Verification(_ sender: UIButton) {
        
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
                }
                return
            }
            viewModelVerifyEmail.apiforEmailVerification()
        }
     }
    
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        txt_aboutMe.resignFirstResponder()
        collecV_MyWork.resignFirstResponder()
        collecV_MyHobbies.resignFirstResponder()
        collecV_MyPets.resignFirstResponder()
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            view_UploadPhoto.isHidden = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self?.view_UploadPhoto.isHidden = false
                    } else {
                        self?.showCameraPermissionDeniedAlert()
                    }
                }
            }
        case .restricted, .denied:
            showCameraPermissionDeniedAlert()
        @unknown default:
            showCameraPermissionDeniedAlert()
        }
    }
    
    @IBAction func btnOutsideUploadPropilePhoto_Tao(_ sender: UIButton) {
        view_UploadPhoto.isHidden = true
    }
    
    @IBAction func btnCamera_Tap(_ sender: UIButton) {
        openCameraWithPermissionCheck(delegate: self)
    }
    
    @IBAction func btnGallery_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension CreateProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
            viewModel.encodeImageToStringCreateProfile(image: selectedImage)
            view_UploadPhoto.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Place {
            if self.locationArray.count == 0{
                return 1
            }else if self.locationArray.count >= 2{
                return self.locationArray.count
                
            }else{
                return self.locationArray.count + 1
            }
        } else if collectionView == collecV_MyWork {
            if  self.myWorkArr.count == 0 {
                return 1
            } else if self.myWorkArr.count >= 2{
                return self.myWorkArr.count
                
            }else {
                return myWorkArr.count + 1
            }
        }
        else if collectionView == collecV_MyLanguage {
            if  self.myLanguageArr.count == 0 {
                return 1
            } else if self.myLanguageArr.count >= 2{
                return self.myLanguageArr.count
                
            }else {
                return myLanguageArr.count + 1
            }
        }
        else if collectionView == collecV_MyHobbies {
            if  self.myHobbiesArr.count == 0 {
                return 1
            } else if self.myHobbiesArr.count >= 2{
                return self.myHobbiesArr.count
                
            }else {
                return myHobbiesArr.count + 1
            }
        } else {
            if  self.myPetsArr.count == 0 {
                return 1
            } else if self.myPetsArr.count >= 2{
                return self.myPetsArr.count
                
            }else {
                return myPetsArr.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Place {
            let cell = collecV_Place.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.locationArray.count {
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.item
                cell.imgicon.image = UIImage(named: "location line")
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLocation(sender:)), for: .touchUpInside)
                cell.lbl_title.text = locationArray[indexPath.item]
            } else {
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.item
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLocation(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyWork {
            let cell = collecV_MyWork.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myWorkArr.count {
                // Display language name for regular cells
                let language = self.myWorkArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                cell.txt_Workname.delegate = self
                cell.imgicon.image = UIImage(named: "myworkicon")
                cell.btnCross.addTarget(self, action: #selector(self.DeleteWork(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myWorkArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewWork(sender:)), for: .touchUpInside)
            }
            return cell
        }
        else if collectionView == collecV_MyLanguage {
            let cell = collecV_MyLanguage.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myLanguageArr.count {
                // Display language name for regular cells
                let language = self.myLanguageArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                
                cell.imgicon.image = UIImage(named: "languageicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLanguage(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myLanguageArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "laguange"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLanguage(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyHobbies {
            let cell = collecV_MyHobbies.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myHobbiesArr.count {
                // Display language name for regular cells
                let language = self.myHobbiesArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "hobbiesicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteHobbies(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myHobbiesArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "Hobbie"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewhobbies(sender:)), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = collecV_MyPets.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myPetsArr.count {
                // Display language name for regular cells
                let language = self.myPetsArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "peticon")
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]  // Assuming you have a label for displaying the language
                
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "PEts"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewPets(sender:)), for: .touchUpInside)
                
            }
            return cell
        }
    }
    
    // MARK: - Add location or delete location
    
    // MARK: - Add location or delete location
    @objc func addNewLocation (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_Place.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        cell.txt_Workname.text = ""
        print(types,"location ")
        cell.imgAddicon.image = UIImage(named: "location line")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewLocationFinal(sender:)), for: .touchUpInside)
        
        // Typing listener
        cell.txt_Workname.addTarget(
            self,
            action: #selector(locationTextChanged(_:)),
            for: .editingChanged
        )

        // Focus keyboard
        cell.txt_Workname.becomeFirstResponder()
    }
    
    @objc func addNewLocationFinal(sender: UIButton) {
        guard let cell = collecV_Place.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else { return }
        let text = cell.txt_Workname.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if text.isEmpty {
            showAlert(for: "Enter Location")
        } else {
            cell.txt_Workname.resignFirstResponder()
            self.lastSelectedLocation = text
            self.viewModel.apiForAddPlace(PlaceName: text)
            cell.txt_Workname.text = ""
        }
    }
    
    
    @objc func locationTextChanged(_ textField: UITextField) {

        guard let text = textField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {

            dropDownLocation.hide()
            return
        }

        // IMPORTANT
        dropDownLocation.anchorView = textField
        dropDownLocation.direction = .bottom
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: textField.bounds.height)

        // Fetch Google suggestions
        fetcher?.sourceTextHasChanged(text)
    }
    
    @objc func DeleteLocation (sender: UIButton) {
        print(sender.tag)
        self.indexforDeleteLocation = sender.tag
        self.viewModel.apiForDeletePlace(index: sender.tag)
    }
    // MARK: -  Add work or delete work
    @objc func addNewWork (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "myworkicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        //        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyWork.performBatchUpdates(nil)
        
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewWorkFinal(sender:)), for: .touchUpInside)
        
    }
    @objc func addNewWorkFinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
        } else {
            myWorkArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyWork.reloadData() }
    }
    @objc func DeleteWork (sender: UIButton) {
        print(sender.tag)
        myWorkArr.remove(at: sender.tag)
        self.collecV_MyWork.reloadData()
    }
    
    // MARK: - Add Language or Delete Language
    @objc func addNewLanguage (sender: UIButton) {
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.myLanguageArr.append(str)
            self.collecV_MyLanguage.reloadData()
        }
        self.present(vc, animated: true)
        
    }
    
    @objc func addNewLaguagefinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyLanguage.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //        cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
        } else {
            myLanguageArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyLanguage.reloadData() }
    }
    
    @objc func DeleteLanguage (sender: UIButton) {
        print(sender.tag)
        myLanguageArr.remove(at: sender.tag)
        self.collecV_MyLanguage.reloadData()
    }
    
    
    // MARK: - Add or Delete Hobbies
    @objc func addNewhobbies (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        cell.imgAddicon.image = UIImage(named: "hobbiesicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        //        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyHobbies.performBatchUpdates(nil)
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyHobbiesfinal(sender:)), for: .touchUpInside)
        
    }
    @objc func addMyHobbiesfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
        } else {
            myHobbiesArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyHobbies.reloadData() }
    }
    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        myHobbiesArr.remove(at: sender.tag)
        self.collecV_MyHobbies.reloadData()
    }
    // MARK: - ADD Pets or Delete Pets
    
    @objc func addNewPets (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "peticon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.btnAddWork.tag = sender.tag
        
        //        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyPets.performBatchUpdates(nil)
        
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyPetsfinal(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func addMyPetsfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        if cell.txt_Workname.text == "" {
            print("enter name")
        } else {
            myPetsArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyPets.reloadData() }
    }
    
    @objc func DeletePets (sender: UIButton) {
        print(sender.tag)
        myPetsArr.remove(at: sender.tag)
        self.collecV_MyPets.reloadData()
    }
    
}

extension CreateProfileVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 50
        var cellWidth: CGFloat = 150  // Default width
        
        // Handle different collection views based on which one is being displayed
        switch collectionView {
        case collecV_Place:
            return getSizeForCollectionView(dataArray: locationArray, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyWork:
            return getSizeForCollectionView(dataArray: myWorkArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyLanguage:
            return getSizeForCollectionView(dataArray: myLanguageArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyHobbies:
            return getSizeForCollectionView(dataArray: myHobbiesArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyPets:
            return getSizeForCollectionView(dataArray: myPetsArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        default:
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    // Generalized function to calculate cell size based on the array and indexPath
    func getSizeForCollectionView(dataArray: [String], indexPath: IndexPath, defaultWidth: CGFloat, cellHeight: CGFloat) -> CGSize {
        if indexPath.item < dataArray.count {
            let text = dataArray[indexPath.item]
            if let calculatedWidth = calculateWidth(for: text) {
                return CGSize(width: calculatedWidth, height: cellHeight)
            }
        }
        return CGSize(width: 130, height: cellHeight)
    }
    
    func calculateWidth(for text: String) -> CGFloat? {
        guard !text.isEmpty else { return nil }
        let font = UIFont(name: "Poppins-Regular", size: 16) ?? UIFont(name: "Poppins", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let textAttributes = [NSAttributedString.Key.font: font]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        let padding: CGFloat = 105
        let maxAllowedWidth = UIScreen.main.bounds.width - 32
        let dynamicWidth = min(max(textWidth + padding, 110), maxAllowedWidth)
        return dynamicWidth
    }
    
    // Set minimum line spacing and inter-item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
}


//extension CreateProfileVC: CLLocationManagerDelegate{
//    @objc func autocompleteClicked() {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
//        autocompleteController.autocompleteFilter = filter
//        // Display the autocomplete view controller.
//        present(autocompleteController, animated: true, completion: nil)
//        autocompleteController.tintColor = .white
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//.white]
//    }
//}

//extension CreateProfileVC: GMSAutocompleteViewControllerDelegate {
//    
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name ?? "")")
//        print("Place ID: \(String(describing: place.placeID))")
//        print("Place attributions: \(String(describing: place.attributions))")
//        print("Place latitude: \(place.coordinate.latitude)")
//        print("Place longitude: \(place.coordinate.longitude)")
//        
//        print("Place formattedAddress: \(String(describing: place.formattedAddress!))")
//        if place.name != nil {
//            UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
//            UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
//            
//            self.locationArray.append("\(place.name ?? "")")
//            self.collecV_Place.reloadData()
//            
//            NotificationCenter.default.post(name: NSNotification.Name("currentLocation"), object: ["latitude":"\(place.coordinate.latitude)","longitude":"\(place.coordinate.longitude)"])
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//    
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//    
//}

struct location {
    var loacationName: String
    var latitude: String
    var longitude: String
}

extension CreateProfileVC: UITextFieldDelegate {
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Adjust the bottom constraint based on the keyboard's height
        tbl_bottom_h.constant = keyboardHeight
        
        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        // Scroll the active text field into view (if applicable)
        if let activeField = self.activeTextField {
            scrollViewToVisible(activeField, withKeyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Reset the bottom constraint
        tbl_bottom_h.constant = 24 // original constraint value
        
        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewToVisible(_ textField: UITextField, withKeyboardHeight keyboardHeight: CGFloat) {
        // Ensure the scrollView exists
        guard let scrollView = self.scrollV else { return }
        
        // Calculate the visible area of the scrollView by subtracting the keyboard height
        var visibleRect = scrollView.frame
        visibleRect.size.height -= keyboardHeight
        
        // Convert the text field's frame to the scroll view's coordinate system
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        
        // Check if the text field is outside the visible area
        if !visibleRect.contains(textFieldFrame.origin) {
            // Scroll the scroll view so the text field is visible
            scrollView.scrollRectToVisible(textFieldFrame, animated: true)
        }
    }
    
    // Track the active text field when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // Clear the active text field when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

extension CreateProfileVC {
    func bindVC(){
        viewModel.$getMyProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    // self.showToast(response.message ?? "")
                    self.profileData = nil
                    self.profileData = response.data
                    let isEmailVerified = self.profileData?.emailVerified ?? 0
                    self.email_verify = isEmailVerified
                    let isPhoneVerified = self.profileData?.phoneVerified ?? 0
                    self.phone_verify = isPhoneVerified
                    if isEmailVerified == 1 {
                        self.view_ConfirmNowEmail.isHidden = true
                        self.view_VerifiedEmail.isHidden = false
                    } else {
                        self.view_ConfirmNowEmail.isHidden = false
                        self.view_VerifiedEmail.isHidden = true
                    }
                    if isPhoneVerified == 1 {
                        self.view_ConfirmNowPhone.isHidden = true
                        self.view_VerifiedPhone.isHidden = false
                    } else {
                        self.view_ConfirmNowPhone.isHidden = false
                        self.view_VerifiedPhone.isHidden = true
                    }
                    self.identity_verify = self.profileData?.identityVerified ?? 0
                    if  self.identity_verify == 1 {
                        self.view_verifyIndentityConfirmNow.isHidden = true
                        self.view_verifiedIndentity.isHidden = false
                    } else {
                        self.view_verifyIndentityConfirmNow.isHidden = false
                        self.view_verifiedIndentity.isHidden = true
                    }
                    if let profileImageStr = self.profileData?.profileImage, !profileImageStr.isEmpty {
                        let imgURL = AppURL.imageURL + profileImageStr
                        self.profileIMGURL = imgURL
                        self.profileImg.loadImage(from: imgURL, placeholder: UIImage(named: "user"))
                    } else {
                        self.profileIMGURL = ""
                    }
                    let nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")"
                    print(nameUser,"nameUser")
                    if nameUser != " " {
                        self.lbl_UserName.text = "Hey \(nameUser)!" } else {
                            self.lbl_UserName.text = "Hey Guest!"
                        }
                    self.firstName = "\(self.profileData?.firstName  ?? "")"
                    self.lastName = "\(self.profileData?.lastName  ?? "")"
                    let street =  self.profileData?.street ?? ""
                    let city =  self.profileData?.city ?? ""
                    let state =  self.profileData?.state ?? ""
                    let zip =  self.profileData?.zipCode ?? ""
                    
                    let email = self.profileData?.email ?? ""
                    
                    let Phone = self.profileData?.phoneNumber ?? ""
                    
                    let desc = self.profileData?.aboutMe ?? ""
                    
                    if desc != "" {
                        self.txt_aboutMe.text = desc
                        self.txt_aboutMe.textColor = .black
                    } else {
                        self.txt_aboutMe.textColor = .gray
                        self.txt_aboutMe.text = self.placeholderText
                    }
                    self.myPetsArr = self.profileData?.pets ?? []
                    self.myHobbiesArr = self.profileData?.hobbies ?? []
                    self.myLanguageArr = self.profileData?.languages ?? []
                    self.locationArray = self.profileData?.whereLive ?? []
                    self.myWorkArr = self.profileData?.myWork ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        self.collecV_Place.collectionViewLayout.invalidateLayout()
                        self.collecV_MyLanguage.collectionViewLayout.invalidateLayout()
                        self.collecV_MyPets.collectionViewLayout.invalidateLayout()
                        self.collecV_MyWork.collectionViewLayout.invalidateLayout()
                        self.collecV_MyHobbies.collectionViewLayout.invalidateLayout()

                        self.collecV_Place.reloadData()
                        self.collecV_MyLanguage.reloadData()
                        self.collecV_MyPets.reloadData()
                        self.collecV_MyWork.reloadData()
                        self.collecV_MyHobbies.reloadData()
                    }
                })
            }.store(in: &cancellables)
        
        
        //Result Verify Identity
        viewModel.$verifyIdentityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    self.showToast(response.message ?? "")
                    self.view_verifyIndentityConfirmNow.isHidden = true
                    self.view_verifiedIndentity.isHidden = false
                })
            }.store(in: &cancellables)

        
        // updateAboutMeResult
        viewModel.$updateAbouMeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedAboutMe ?? ""
                    self.txt_aboutMe.text = txt
                    self.btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_aboutMe.isEditable = false
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getProfileUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.message ?? "")
                    
                    print(response.data?.isProfileComplete ?? false,"isProfileComplete Status")
                    
                    self.showToast("Your profile has been saved successfully")
                    
                    var is_profile_complete = "\(response.data?.isProfileComplete ?? false)"
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isProfileComplete ?? false)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2 seconds delay
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
        
        
        // updateProfileImage
        viewModel.$getUpdateProfileImgResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let image = response.data?.profileImageURL ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    
                    UserDetail.shared.setProfileimg(imgURL)
                    
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                })
            }.store(in: &cancellables)
        
        // addPlaceResult
        viewModel.$addPlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    print(response.message ?? "")
                    let addedLocation = response.data?.addedLocation ?? ""
                    let finalLocation = (!addedLocation.isEmpty && addedLocation.count > 3) ? addedLocation : self.lastSelectedLocation
                    if !finalLocation.isEmpty {
                        self.locationArray.append(finalLocation)
                        self.collecV_Place.collectionViewLayout.invalidateLayout()
                        self.collecV_Place.reloadData()
                    }
                })
            }.store(in: &cancellables)

        // deletePlaceResult
        viewModel.$deletePlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let deleteIndex = self.indexforDeleteLocation ?? 0
                    if deleteIndex < self.locationArray.count {
                        self.locationArray.remove(at: deleteIndex)
                        self.collecV_Place.collectionViewLayout.invalidateLayout()
                        self.collecV_Place.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
    
}

extension CreateProfileVC: InquiryDelegate {
    
    func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        print(inquiryId)
        print(status)
        if status ==  "completed" {
            self.identity_verify = 1
            self.view_verifiedIndentity.isHidden = false
            self.view_verifyIndentityConfirmNow.isHidden = true
        }  else if status ==  "approved" {
            self.identity_verify = 1
            self.view_verifiedIndentity.isHidden = false
            self.view_verifyIndentityConfirmNow.isHidden = true
        }else {
            self.identity_verify = 0
            self.view_verifiedIndentity.isHidden = true
            self.view_verifyIndentityConfirmNow.isHidden = false
        }
        viewModel.apiForVerifyIdentity(identityverify: self.identity_verify ?? 0)
     }
    
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        // Inquiry cancelled by user
    }
    
    func inquiryError(_ error: Error) {
        // Inquiry errored
    }
}
