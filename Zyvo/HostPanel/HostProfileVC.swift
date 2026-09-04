//
//  HostProfileVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import DropDown
import CountryPickerView
import Combine
import AVFoundation

class HostProfileVC:UIViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate,GMSAutocompleteFetcherDelegate {
    
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
    
    @IBOutlet weak var collectionBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paymentTblVH_Const: NSLayoutConstraint!
    
    @IBOutlet var viewDeletePopUp: UIView!
    @IBOutlet weak var aboutMeTxtV: UITextView!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    @IBOutlet weak var view_ProfilePassword: UIView!
    @IBOutlet weak var view_ProfilePhoneNumber: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    //let keyboardSettings = KeyboardSettings(bottomType: .categories)
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_AddNewPayOutMethod: UIView!
    @IBOutlet weak var view_AddNewPaymentMethod: UIView!
    @IBOutlet weak var view_AddNewPayOut: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zip: UIView!
    @IBOutlet weak var view_EmailProfile: UIView!
    @IBOutlet weak var view_MainPassword: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var view_UploadPhoto: UIView!
    @IBOutlet weak var collecV_Place: UICollectionView!
    @IBOutlet weak var collecV_MyWork: UICollectionView!
    @IBOutlet weak var collecV_MyLanguage: UICollectionView!
    @IBOutlet weak var collecV_MyHobbies: UICollectionView!
    @IBOutlet weak var collecV_MyPets: UICollectionView!
    @IBOutlet weak var view_Dark: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var payoutMethodV: UIView!
    @IBOutlet weak var payoutDropImg: UIImageView!
    @IBOutlet weak var paymentMethodV: UIView!
    @IBOutlet weak var paymentDropImg: UIImageView!
    @IBOutlet weak var cardTblV: UITableView!
    @IBOutlet weak var bankTblV: UITableView!
    @IBOutlet weak var paymentMethodTblV: UITableView!
    @IBOutlet weak var resendBtnO: UIButton!
    @IBOutlet weak var txt_streetProfile: UITextField!
    @IBOutlet weak var txt_cityProfile: UITextField!
    @IBOutlet weak var txt_stateProfile: UITextField!
    @IBOutlet weak var txt_zipProfile: UITextField!
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var btnEditStreet: UIButton!
    @IBOutlet weak var paymentDropBtnO: UIButton!
    @IBOutlet weak var btnEditCity: UIButton!
    @IBOutlet weak var btnEditState: UIButton!
    @IBOutlet weak var btnEditZip: UIButton!
    @IBOutlet weak var view_ConfirmNowIndentity: UIView!
    @IBOutlet weak var view_VerifiedIndentity: UIView!
    @IBOutlet weak var lbl_nameUser: UILabel!
    @IBOutlet weak var txt_PhoneProfile: UITextField!
    @IBOutlet weak var txt_EmailProfile: UITextField!
    @IBOutlet weak var img_UpdateAboutMeButton: UIImageView!
    
    @IBOutlet weak var imgBtnAboutMe: UIButton!
    @IBOutlet weak var view_updateAboutMeBtn: UIView!
    @IBOutlet weak var lbl_AboutMeButton: UILabel!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ImgBtn_AboutMe: UIButton!
    @IBOutlet weak var deletePopUpMainView: UIView!
    @IBOutlet weak var deletePopUpView: UIView!
    @IBOutlet weak var deletePopUpLbl: UILabel!
    @IBOutlet weak var deletePopUpBtn: UIButton!
    @IBOutlet weak var cancelPopUpBtn: UIButton!
    
    @IBOutlet weak var lbl_Logout: UILabel!
    @IBOutlet weak var lbl_EmailTitle: UILabel!
    @IBOutlet weak var lbl_passwordTitle: UILabel!
    
    @IBOutlet weak var btnSwittoGuest: UIButton!
    @IBOutlet weak var lbl_AboutMeTitle: UILabel!
    @IBOutlet weak var lbl_whereILiveTitle: UILabel!
    @IBOutlet weak var lbl_MyWorkTitle: UILabel!
    @IBOutlet weak var lbl_languageSpeakTitle: UILabel!
    @IBOutlet weak var lbl_phoneNumberTitle: UILabel!
    @IBOutlet weak var lbl_addressTitle: UILabel!
    @IBOutlet weak var lbl_payoutMethod: UILabel!
    @IBOutlet weak var lbl_paymentMethod: UILabel!
    @IBOutlet weak var lbl_useFul: UILabel!
    @IBOutlet weak var lbl_support: UILabel!
    @IBOutlet weak var lbl_legel: UILabel!
    
    @IBOutlet weak var lbl_hostTitle: UILabel!
    let placeholderText = "Write about yourself" // Placeholder text/
    let dotDropdown = DropDown()
    var dotArr1 = ["     Set as primary","     Delete"]
    var dotArr = ["Edit","Delete"]
    var identity_verify : Int? = 0
    var verificationStatus = ""
    var editEmail_Phone = ""
    private var placesClient: GMSPlacesClient!
    let countryPicker = CountryPickerView()
    var types = ""
    var locationArray: [String] = [ ]
    var indexforDeleteLocation : Int? = 0
    var myWorkArr: [String] = []
    var indexforDeleteWork : Int? = 0
    var myLanguageArr: [String] = []
    var indexforDeleteLanguage : Int? = 0
    var myHobbiesArr: [String] = []
    var indexforDeleteHobby : Int? = 0
    var myPetsArr: [String] = []
    var indexforDeletePet : Int? = 0
    var activeTextField: UITextField?
    var timer = Timer()
    var isAboutMeStatus = false  // Track editing state
    var isStreetUpdateStatus = false
    var isCityUpdateStatus = false
    var isStateUpdateStatus = false
    var isZipcdeUpdateStatus = false
    var profileData : MyProfileModel?
    var workDataAfterDeletion : DeleteWorkModel?
    private var viewModelPaymentMethod = PaymentHistoryViewModel()
    var addedBankDetailsData = [H_BankAccount]()
    var addedCardDetailsData = [H_Card]()
    var getCardArr : [Card]?
    private var CardViewModel = BookingPropertyViewModel()
    var viewModel = GetMyProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    var  phonetobeUpdate = ""
    var profileIMGURL = ""
    var card_id = ""
    var customerID = ""
    var OTP = ""
    var userID = ""
    var tempID = ""
    var fName = ""
    var lName = ""
    var firstName = ""
    var lastName = ""
    var indx : Int? = 0
    var indexCard: String = ""
    var addNewLocation = "No"
    var updateAllAddress = false
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    let dropDownLocation = DropDown()
    @IBOutlet weak var infoBtnO: UIButton!
    
    var activeLocationTextField: UITextField?
    
    var currentLocationSelectionType: LocationSelectionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentMethodTblV.separatorStyle = .none
        
        // Stop automatic keyboard adjustment
        collecV_Place.contentInsetAdjustmentBehavior = .never
      
        // Initialize Google Autocomplete Fetcher
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter // You can change this to .address, .establishment, etc.
        
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher.delegate = self
        self.txt_streetProfile.delegate = self
        
        txt_streetProfile.addTarget(
            self,
            action: #selector(streetTextChanged(_:)),
            for: .editingChanged
        )
        
        txt_PhoneProfile.textContentType = .none
        txt_EmailProfile.textContentType = .none
        txt_streetProfile.textContentType = .none
        txt_cityProfile.textContentType = .none
        txt_stateProfile.textContentType = .none
        txt_zipProfile.textContentType = .none
        aboutMeTxtV.textContentType = .none
        
        btnSwittoGuest.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)!
        txt_PhoneProfile.font = UIFont(name: "Poppins", size: 16)
        txt_EmailProfile.font = UIFont(name: "Poppins", size: 16)
        txt_streetProfile.font = UIFont(name: "Poppins", size: 16)
        txt_cityProfile.font = UIFont(name: "Poppins", size: 16)
        txt_stateProfile.font = UIFont(name: "Poppins", size: 16)
        txt_zipProfile.font = UIFont(name: "Poppins", size: 16)
        
        lbl_Logout.font = UIFont(name: "Poppins", size: 18)!
        lbl_hostTitle.font = UIFont(name: "Poppins", size: 16)!
        lbl_nameUser.font = UIFont(name: "Poppins", size: 20)!
        lbl_EmailTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_passwordTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_AboutMeTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_whereILiveTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_MyWorkTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_languageSpeakTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_phoneNumberTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_addressTitle.font = UIFont(name: "Poppins", size: 20)!
        lbl_payoutMethod.font = UIFont(name: "Poppins", size: 20)!
        lbl_paymentMethod.font = UIFont(name: "Poppins", size: 20)!
        lbl_useFul.font = UIFont(name: "Poppins", size: 20)!
        lbl_support.font = UIFont(name: "Poppins", size: 20)!
        lbl_legel.font = UIFont(name: "Poppins", size: 20)!
        
        aboutMeTxtV.isScrollEnabled = false
        
        lbl_AboutMeButton.font = UIFont(name: "Poppins", size: 15)!
        aboutMeTxtV.font = UIFont(name: "Poppins", size: 14)!
        
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
        
        let tables: [UITableView?] = [bankTblV, cardTblV]
        tables.forEach { configureTableView($0) }
        
        let user = UserDetail.shared.getUserType()
        view_MainPassword.isHidden = true
        
        if user == "Email" {
            view_MainPassword.isHidden = false
        }
        
        bindVC_DeleteMethode()
        bindVC_SetPrimary()
        bindVC_GetPayoutMethods()
        self.keyboardNotifications()
        IQKeyboardManager.shared.enable = false
        
        self.payoutMethodV.isHidden = true
        self.paymentMethodV.isHidden = true
        
        placesClient = GMSPlacesClient.shared()
        
        view_UploadPhoto.frame = self.view.bounds
        self.view.addSubview(view_UploadPhoto)
        view_UploadPhoto.isHidden = true
        
        deletePopUpMainView.frame = self.view.bounds
        self.view.addSubview(deletePopUpMainView)
        deletePopUpMainView.isHidden = true
        
        view_Dark.layer.cornerRadius = 20
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 3
        view_Photo.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.18).cgColor
        
        view_ProfileDetails.layer.cornerRadius = 20
        view_ProfileDetails.layer.borderWidth = 1.50
        view_ProfileDetails.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        paymentMethodTblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        paymentMethodTblV.delegate = self
        paymentMethodTblV.dataSource = self
        paymentMethodTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        aboutMeTxtV.delegate = self
        setup()
        setupCollectionView()
        bindVC()
        
        setupTextView()
        setupTextFields()
        setDeleteView()
        setupDropDown()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true // Ensures accessory bars don't blank
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow2),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide2),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    @objc func streetTextChanged(_ textField: UITextField) {
        
        guard let text = textField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            dropDownLocation.hide()
            return
        }
        
        // Anchor dropdown to textfield
        dropDownLocation.anchorView = textField
        dropDownLocation.bottomOffset = CGPoint(
            x: 0,
            y: textField.bounds.height
        )
        
        // Fetch suggestions
        fetcher?.sourceTextHasChanged(text)
    }
    
    func setupDropDown() {
        
        dropDownLocation.anchorView = txt_streetProfile
        dropDownLocation.direction = .bottom
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: txt_streetProfile.bounds.height)
        
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
            ) { place, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let place = place else { return }
                
                
                switch self.currentLocationSelectionType {
                    
                    // =========================
                    // PROFILE ADDRESS UPDATE
                    // =========================
                case .profileAddress:
                    
                    self.fillAddressFields(from: place)
                    
                    self.updateAllAddress = true
                    
                    self.viewModel.apiForUpdateStreet(
                        StreetAddress: self.txt_streetProfile.text ?? ""
                    )
                    
                    self.viewModel.apiForUpdateCity(
                        City: self.txt_cityProfile.text ?? ""
                    )
                    
                    self.viewModel.apiForUpdateState(
                        State: self.txt_stateProfile.text ?? ""
                    )
                    
                    self.viewModel.apiForUpdateZipcode(
                        zip: self.txt_zipProfile.text ?? ""
                    )
                    
                    self.txt_streetProfile.isUserInteractionEnabled = false
                    self.txt_streetProfile.resignFirstResponder()
                    
                    self.btnEditStreet.setImage(
                        UIImage(named: "EditPencilicon"),
                        for: .normal
                    )
                    
                    self.btnEditCity.setImage(
                        UIImage(named: "EditPencilicon"),
                        for: .normal
                    )
                    
                    self.btnEditState.setImage(
                        UIImage(named: "EditPencilicon"),
                        for: .normal
                    )
                    
                    self.btnEditZip.setImage(
                        UIImage(named: "EditPencilicon"),
                        for: .normal
                    )
                    
                    self.isStreetUpdateStatus = false
                    self.isCityUpdateStatus = false
                    self.isStateUpdateStatus = false
                    self.isZipcdeUpdateStatus = false
                    
                    // =========================
                    // ADD NEW LOCATION
                    // =========================
                case .addPlace:
                    
                    self.activeLocationTextField?.text = place.formattedAddress
                    
                    self.viewModel.apiForAddPlace(
                        PlaceName: place.formattedAddress ?? ""
                    )
                    
                    self.activeLocationTextField?.resignFirstResponder()
                    
                case .none:
                    break
                }
                
                self.dropDownLocation.hide()
            }
        }
        
    }
    
    
    func fillAddressFields(from place: GMSPlace) {
        
        var streetNumber = ""
        var route = ""
        
        var city = ""
        var state = ""
        var zip = ""
        
        place.addressComponents?.forEach { component in
            
            let types = component.types
            
            // Street Number
            if types.contains("street_number") {
                streetNumber = component.name
            }
            
            // Street Name
            if types.contains("route") {
                route = component.name
            }
            
            // City
            if types.contains("locality") {
                city = component.name
            }
            
            // Backup city
            if city.isEmpty && types.contains("administrative_area_level_2") {
                city = component.name
            }
            
            // State
            if types.contains("administrative_area_level_1") {
                state = component.name
            }
            
            // Zip
            if types.contains("postal_code") {
                zip = component.name
            }
        }
        
        // Build street
        let street = "\(streetNumber) \(route)"
            .trimmingCharacters(in: .whitespaces)
        
        // Final Values
        txt_streetProfile.text = !street.isEmpty
        ? street
        : (place.name ?? place.formattedAddress ?? "")
        
        txt_cityProfile.text = city
        txt_stateProfile.text = state
        txt_zipProfile.text = zip
        
        print("Street:", txt_streetProfile.text ?? "")
        print("City:", city)
        print("State:", state)
        print("Zip:", zip)
    }
    
    func updateAboutMeHeight() {
        
        let size = CGSize(
            width: aboutMeTxtV.frame.width,
            height: .greatestFiniteMagnitude
        )
        
        let estimatedSize = aboutMeTxtV.sizeThatFits(size)
        
        textViewHeight.constant = estimatedSize.height
        
        self.view.layoutIfNeeded()
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //           UIView.setAnimationsEnabled(false)
    //           aboutMeTxtV.layoutIfNeeded()
    //           UIView.setAnimationsEnabled(true)
    //       }
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = aboutMeTxtV.frame.size.width
        
        let newSize = aboutMeTxtV.sizeThatFits(
            CGSize(
                width: fixedWidth,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        
        textViewHeight.constant = newSize.height
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        viewModel.getProfile()
        //Api For GetPayoutMethods
        viewModelPaymentMethod.apiforGetPayoutMethods()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if aboutMeTxtV.text.isEmpty {
            aboutMeTxtV.text = placeholderText
            aboutMeTxtV.textColor = UIColor.lightGray // Reset to placeholder color
        } else {
            aboutMeTxtV.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if aboutMeTxtV.text == placeholderText {
            aboutMeTxtV.text = "" // Clear text when starting to type
            aboutMeTxtV.textColor = UIColor.black // Set text color to normal
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        cardTblV.layer.removeAllAnimations()
        paymentTblVH_Const.constant = paymentMethodTblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    func setup(){
        
        view_EmailProfile.applyRoundedBorder()
        view_ProfilePassword.applyRoundedBorder()
        view_ProfilePhoneNumber.applyRoundedBorder()
        view_State.applyRoundedBorder()
        view_City.applyRoundedBorder()
        view_AddNewPayOut.applyRoundedBorder()
        view_AddNewPayOutMethod.applyRoundedBorder()
        view_AddNewPaymentMethod.applyRoundedBorder()
        view_Zip.applyRoundedBorder()
        view_Street.applyRoundedBorder()
        view_updateAboutMeBtn.applyRoundedBorder(radius: 15, borderWidth: 0.75, borderColor: .lightGray)
        //  view_updateAboutMeBtn.applyRoundedBorder()
    }
    
    func setupCollectionView(){
        let allCollections: [UICollectionView?] = [
            collecV_Place,
            collecV_MyWork,
            collecV_MyLanguage,
            collecV_MyHobbies,
            collecV_MyPets]
        allCollections.forEach { configureCollectionView($0) }
    }
    
    func setDeleteView() {
        //  self.deletePopUpMainView.layer.cornerRadius = 0
        self.deletePopUpView.layer.cornerRadius = 26
        //self.deletePopUpLbl.layer.cornerRadius = 0
        self.deletePopUpBtn.layer.cornerRadius = self.cancelPopUpBtn.frame.height/2
        self.cancelPopUpBtn.layer.cornerRadius = self.cancelPopUpBtn.frame.height/2
        self.cancelPopUpBtn.layer.borderWidth = 1
        self.cancelPopUpBtn.layer.borderColor = UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1).cgColor
        
    }
    
    @IBAction func confirnDeleteBtn(_ sender: UIButton){
        //self.indx = indexCard
        self.viewModel.apiForDeleteSavedCard(cardID: indexCard)
        //cardNumTblV.reloadData()
        
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton){
        self.tabBarController?.setTabBarHidden(false, animated: false)
        self.deletePopUpMainView.isHidden = true
    }
    
    
    @IBAction func editAboutMeTxtBtn(_ sender: UIButton){
        if isAboutMeStatus {
            // Stop editing and call API
            
            
            if aboutMeTxtV.text != placeholderText {
                print("api call here for edit aboue me")
                if aboutMeTxtV.text == "" {
                    print("Alert")
                    self.showAlert(for: "About Me cannot be empty.")
                } else {
                    viewModel.apiForUpdateAboutMe(AboutMe: self.aboutMeTxtV.text) }
            }
        } else {
            // Start editing
            aboutMeTxtV.isEditable = true
            aboutMeTxtV.becomeFirstResponder()
            ImgBtn_AboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
            // img_UpdateAboutMeButton.image = UIImage(named: "rightSigntick")
            //lbl_AboutMeButton.text = "Save"
            // btnEditAboutMe.setImage(UIImage(named: "EditTick"), for: .normal)
            
            // Remove placeholder when editing starts
            if aboutMeTxtV.text == placeholderText {
                aboutMeTxtV.text = ""
                aboutMeTxtV.textColor = UIColor.black
            }
        }
        isAboutMeStatus.toggle()
    }
    
    @IBAction func btnLanguage_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostChooseLanguageVC") as! HostChooseLanguageVC
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.viewModel.apiForAddLanguage(languageName: str)
            // self.myLanguageArr.append(str)
            self.collecV_MyLanguage.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func infoBtn(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Before you can book or host  on the platform the name on Id must match verification documents."
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .down // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 230, height: 80)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnCreateNewListing_Tap(_ sender: UIButton) {
//        if addedBankDetailsData.count == 0 && addedCardDetailsData.count == 0 {
//            self.showPayoutSetupPopup()
//            return
//        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostPlaceMngmntVC") as! HostPlaceMngmntVC
        SingltonClass.shared.typeOfSpace = "entire_home"
        SingltonClass.shared.propertySize = "0"
        SingltonClass.shared.no_Of_Ppl = "0"
        SingltonClass.shared.bedrooms = "0"
        SingltonClass.shared.bathrooms = "0"
        SingltonClass.shared.activies.removeAll()
        SingltonClass.shared.other_Activities.removeAll()
        SingltonClass.shared.aminities.removeAll()
        SingltonClass.shared.instantBooking = "0"
        SingltonClass.shared.selfCheck_in = "0"
        SingltonClass.shared.allowPets = "0"
        SingltonClass.shared.cancellationDays = ""
        SingltonClass.shared.Imgs = []
        SingltonClass.shared.title = ""
        SingltonClass.shared.about = "Optional"
        SingltonClass.shared.parkingRule = "Optional"
        SingltonClass.shared.hostRules = "Optional"
        SingltonClass.shared.street = ""
        SingltonClass.shared.city = ""
        SingltonClass.shared.zipcode = ""
        SingltonClass.shared.country = ""
        SingltonClass.shared.state = ""
        SingltonClass.shared.latitude = 0.0
        SingltonClass.shared.longitude = 0.0
        SingltonClass.shared.miniHrsPric_HrsMini = "1"
        SingltonClass.shared.miniHrsPric_perHrs = "10"
        SingltonClass.shared.bulkDis_HrsMini = "1"
        SingltonClass.shared.bulkDis_Discount = "15"
        SingltonClass.shared.addCleaningFees = ""
        SingltonClass.shared.avilabilityMonth = ["all"]
        SingltonClass.shared.avilabilityDays = "all"
        SingltonClass.shared.avilabilityHrsFrom = ""
        SingltonClass.shared.avilabilityHrsTo = ""
        SingltonClass.shared.addOns.removeAll()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPaymentWithdrawals_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostPaymentVC") as! HostPaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddNewPayoutMethod_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "AddCards", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddNewPayment_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "AddCards", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
        vc.profileIMGURL = self.profileIMGURL
        vc.firstName = self.fName
        vc.lastName = self.lName
        vc.backAction = { strfName , strlName in
            print(strfName,strlName,"Name Recieved")
            let nameUser = "\(strfName)" +  " \(strlName)"
            // var imgurlss = self.profileData?.profileImage ?? ""
            print(nameUser,"nameUser")
            self.lbl_nameUser.text = "Hey \(nameUser)!"
            self.fName = strfName
            self.lName = strlName
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        print("confirm Email here")
        verificationStatus = "EmailVerified"
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,"str")
            if userID != "" || email != "" || otp != ""  {
                let vc = sb.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.countryCode = countryCode
                vc.emailtobeUpdate = email
                vc.backAction = { str in
                    print(str,"str recieved")
                    if str == "Yes"{
                        let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            self.txt_EmailProfile.text = email
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
    
    @IBAction func btnLogout_Tap(_ sender: UIButton) {
        print("Logout")
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "LogoutPopUpVC") as! LogoutPopUpVC
        
        vc.backAction = {
            
            self.setRootToHomeWithoutLogin()
            //            let sb = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = sb.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
            //            self.tabBarController?.tabBar.isHidden = false
            //            self.hidesBottomBarWhenPushed = true
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    func setRootToHomeWithoutLogin() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = sb.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
        
        let nav = UINavigationController(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        
        // SceneDelegate (iOS 13+)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            window.rootViewController = nav
            window.makeKeyAndVisible()
            
            // Optional animation
            //            UIView.transition(with: window,
            //                              duration: 0.3,
            //                              options: .transitionFlipFromRight,
            //                              animations: nil,
            //                              completion: nil)
        }
    }
    
    @IBAction func btnSwitchToGuest_Tap(_ sender: UIButton) {
        print("Switch To Guest")
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        UserDetail.shared.setlogintType("Guest")
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @IBAction func btnBooking_Tap(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func btnNotification_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHelpCenter_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        vc.comingFrom = "Host"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShareFeedback_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "ShareFeedbackVC") as! ShareFeedbackVC
        vc.userType = "Host"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTermCondition_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "TermCondition"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPrivacyPolicy_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "Privacy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        print("confirm phone here")
        verificationStatus = "PhoneVerified"
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,countryCode,"str Recieved")
            if userID != "" || email != "" || otp != "" || countryCode != "" {
                let vc = sb.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.phonetobeUpdate = email
                vc.countryCode = countryCode
                vc.countryCode = countryCode
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            self.txt_PhoneProfile.text = email
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
    
    @IBAction func btnverifyIdentity_Tap(_ sender: UIButton) {
        
    }
    
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            view_UploadPhoto.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self?.view_UploadPhoto.isHidden = false
                        self?.tabBarController?.tabBar.isHidden = true
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func payoutMethodDropBtn(_ sender: UIButton){
        
        if sender.isSelected == false {
            
            sender.isSelected = true
            //          payoutDropImgBtnV.isHidden = true
            self.payoutMethodV.isHidden = false
            payoutDropImg.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            //          payoutDropImgBtnV.isHidden = false
            self.payoutMethodV.isHidden = true
            payoutDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func paymentMethodDropBtn(_ sender: UIButton){
        if sender.isSelected == false {
            sender.isSelected = true
            CardViewModel.apiForGetSavedCard()
            //          payoutDropImgBtnV.isHidden = true
            
            paymentDropImg.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            //          payoutDropImgBtnV.isHidden = false
            self.paymentMethodV.isHidden = true
            paymentDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.backAction = {
            //            self.addCardBtnV.isHidden = true
            self.paymentMethodTblV.isHidden = false
            self.paymentDropBtnO.isSelected = true
            self.paymentDropImg.image = UIImage(named: "União 106")
            self.CardViewModel.apiForGetSavedCard()
        }
        self.present(vc, animated: true)
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
    
    @IBAction func editEmailBtn(_ sender: UIButton){
        verificationStatus = "Emailupdate"
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,"str")
            if userID != "" || email != "" || otp != ""  {
                let vc = sb.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.emailtobeUpdate = email
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        self.txt_EmailProfile.text = email
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
    
    @IBAction func editPhoneBtn(_ sender: UIButton){
        verificationStatus = "UpdatePhone"
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,countryCode,"str Recieved")
            if userID != "" || email != "" || otp != "" || countryCode != "" {
                let vc = sb.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.phonetobeUpdate = email
                vc.countryCode = countryCode
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        self.txt_PhoneProfile.text = email
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
    
    @IBAction func editPassBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        vc.comingFrom = "PassChange"
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { str in
            print(str,"str")
            if str == "Cancel"{
                print(str)
            }else{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                vc.comesFrom = "PassChange"
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func btnEditStreet_Tap(_ sender: UIButton) {
        
        currentLocationSelectionType = .profileAddress
        
        // Enable editing
        txt_streetProfile.isUserInteractionEnabled = true
        txt_streetProfile.becomeFirstResponder()
        
        // Change all icons to tick
        btnEditStreet.setImage(UIImage(named: "rightSigntick"), for: .normal)
        btnEditCity.setImage(UIImage(named: "rightSigntick"), for: .normal)
        btnEditState.setImage(UIImage(named: "rightSigntick"), for: .normal)
        btnEditZip.setImage(UIImage(named: "rightSigntick"), for: .normal)
        
        // Status true
        isStreetUpdateStatus = true
        isCityUpdateStatus = true
        isStateUpdateStatus = true
        isZipcdeUpdateStatus = true
        txt_streetProfile.text = ""
        txt_cityProfile.text = ""
        txt_stateProfile.text = ""
        txt_zipProfile.text = ""
        
        //        if isStreetUpdateStatus {
        //            // Stop editing and call API
        //            txt_streetProfile.isUserInteractionEnabled = false
        //            btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
        //            txt_streetProfile.resignFirstResponder()
        //            //  if txt_streetProfile.text != placeholderText {
        //            print("api call here for edit Street")
        //            self.updateAllAddress = true
        //            viewModel.apiForUpdateStreet(StreetAddress: self.txt_streetProfile.text ?? "")
        //            if self.txt_cityProfile.text != ""{
        //                viewModel.apiForUpdateCity(City: self.txt_cityProfile.text ?? "")
        //            }
        //            if self.txt_stateProfile.text != ""{
        //                viewModel.apiForUpdateState(State: self.txt_stateProfile.text ?? "")
        //            }
        //            if self.txt_zipProfile.text != ""{
        //                viewModel.apiForUpdateZipcode(zip: self.txt_zipProfile.text ?? "")
        //            }
        //        } else {
        //            // Start editing
        //            txt_streetProfile.isUserInteractionEnabled = true
        //            txt_streetProfile.becomeFirstResponder()
        //            btnEditStreet.setImage(UIImage(named: "rightSigntick"), for: .normal)
        //        }
        //        isStreetUpdateStatus.toggle()
        //        isCityUpdateStatus.toggle()
        //        isStateUpdateStatus.toggle()
        //        isZipcdeUpdateStatus.toggle()
    }
    @IBAction func btnEditCity_Tap(_ sender: UIButton) {
        if isCityUpdateStatus {
            // Stop editing and call API
            txt_cityProfile.isUserInteractionEnabled = false
            btnEditCity.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_cityProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit City")
            viewModel.apiForUpdateCity(City: self.txt_cityProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_cityProfile.isUserInteractionEnabled = true
            txt_cityProfile.becomeFirstResponder()
            btnEditCity.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isCityUpdateStatus.toggle()
    }
    @IBAction func btnEditState_Tap(_ sender: UIButton) {
        if isStateUpdateStatus {
            // Stop editing and call API
            txt_stateProfile.isUserInteractionEnabled = false
            btnEditState.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_stateProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit State")
            self.updateAllAddress = false
            viewModel.apiForUpdateState(State: self.txt_stateProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_stateProfile.isUserInteractionEnabled = true
            txt_stateProfile.becomeFirstResponder()
            btnEditState.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isStateUpdateStatus.toggle()
    }
    @IBAction func btnEditZip_Tap(_ sender: UIButton) {
        if isZipcdeUpdateStatus {
            // Stop editing and call API
            txt_zipProfile.isUserInteractionEnabled = false
            btnEditZip.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_zipProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit zipcode")
            self.updateAllAddress = false
            viewModel.apiForUpdateZipcode(zip: self.txt_zipProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_zipProfile.isUserInteractionEnabled = true
            txt_zipProfile.becomeFirstResponder()
            btnEditZip.setImage(UIImage(named: "rightSigntick"), for: .normal)
        }
        isZipcdeUpdateStatus.toggle()
    }
    func setupTextFields() {
        txt_streetProfile.delegate = self
        txt_cityProfile.delegate = self
        txt_stateProfile.delegate = self
        txt_zipProfile.delegate = self
        txt_streetProfile.isUserInteractionEnabled = false
        txt_cityProfile.isUserInteractionEnabled = false
        txt_stateProfile.isUserInteractionEnabled = false
        txt_zipProfile.isUserInteractionEnabled = false
        txt_streetProfile.placeholder = "Street"
        txt_cityProfile.placeholder = "City"
        txt_stateProfile.placeholder = "State"
        txt_zipProfile.placeholder = "Zipcode"
    }
    
    func setupTextView() {
        aboutMeTxtV.delegate = self
        aboutMeTxtV.isEditable = false // Initially non-editable
        aboutMeTxtV.text = placeholderText
        aboutMeTxtV.textColor = UIColor.lightGray // Placeholder color
    }
}
extension HostProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
            view_UploadPhoto.isHidden = true
            viewModel.encodeImageToString(image: selectedImage)
            self.tabBarController?.setTabBarHidden(false, animated: false)
        }
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension HostProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
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
        }else if collectionView == collecV_MyLanguage {
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
                cell.lbl_title.text = myLanguageArr[indexPath.row]  // Assuming you have a label for displaying the language
                // /*cell.lbl_title.sizeToFit*/()
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
                cell.lbl_title.text = myHobbiesArr[indexPath.row]  // Assuming you have a label for displaying the language
                //cell.lbl_title.sizeToFit()
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
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]  // Assuming you have a label for displaying the language
                // cell.lbl_title.sizeToFit()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "Pets"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewPets(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    // MARK: - Add location or delete location
    //    @objc func addNewLocation (sender: UIButton) {
    //        print(sender.tag)
    //        self.addNewLocation = "Yes"
    //        self.autocompleteClicked()
    //    }
    
    // MARK: - Add location or delete location
    @objc func addNewLocation (sender: UIButton) {
        print(sender.tag)
        self.addNewLocation = "Yes"
        
        currentLocationSelectionType = .addPlace
        
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
            viewModel.apiForAddPlace(PlaceName: text)
            cell.txt_Workname.text = ""
        }
    }
    
    @objc func DeleteLocation (sender: UIButton) {
        print(sender.tag)
        self.indexforDeleteLocation = sender.tag
        viewModel.apiForDeletePlace(index: sender.tag)
    }
    @objc func locationTextChanged(_ textField: UITextField) {
        
        activeLocationTextField = textField
        
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
    // MARK: -  Add work or delete work
    @objc func addNewWork (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "myworkicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        
        cell.btnAddnewWidth.constant = 180
        cell.btnAddnewHeight.constant = 50

        UIView.performWithoutAnimation {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        //        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
       
        // Optionally update the layout for the collection view
        collecV_MyWork.performBatchUpdates(nil)
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewWorkFinal(sender:)), for: .touchUpInside)
    }
    @objc func addNewWorkFinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        
        cell.btnAddnewWidth.constant = 180
        cell.btnAddnewHeight.constant = 50

        UIView.performWithoutAnimation {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        if cell.txt_Workname.text == "" {
            print("enter name")
            self.showAlert(for: "Add work")
        } else {
            viewModel.apiForAddWork(workName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    @objc func DeleteWork (sender: UIButton) {
        print(sender.tag)
        self.indexforDeleteWork = sender.tag
        viewModel.apiForDeleteWork(index: sender.tag)
    }
    
    // MARK: - Add Language or Delete Language
    @objc func addNewLanguage (sender: UIButton) {
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostChooseLanguageVC") as! HostChooseLanguageVC
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.viewModel.apiForAddLanguage(languageName: str)
            // self.myLanguageArr.append(str)
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
            showAlert(for: "Enter Language")
        }
    }
    
    @objc func DeleteLanguage (sender: UIButton) {
        print(sender.tag)
        viewModel.apiForDeleteLanguage(index: sender.tag)
        self.indexforDeleteLanguage = sender.tag
    }
    // MARK: - Add or Delete Hobbies
    @objc func addNewhobbies (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        cell.imgAddicon.image = UIImage(named: "hobbiesicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
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
            showAlert(for: "Enter Hobby")
        } else {
            viewModel.apiForAddHobbies(HobbyName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    
    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        viewModel.apiForDeleteHobby(index: sender.tag)
        self.indexforDeleteHobby = sender.tag
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
            showAlert(for: "Enter Pet Name")
        } else {
            viewModel.apiForAddPet(PetName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    @objc func DeletePets (sender: UIButton) {
        print(sender.tag)
        self.indexforDeletePet = sender.tag
        viewModel.apiForDeletePet(index: sender.tag)
    }
}
extension HostProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bankTblV{
            return addedBankDetailsData.count
        }else if tableView == cardTblV{
            return addedCardDetailsData.count
        }else{
            return getCardArr?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bankTblV{
            let cell = bankTblV.dequeueReusableCell(withIdentifier: "BankDetailTblVCell", for: indexPath) as! BankDetailTblVCell
            cell.bankDetailLbl.text = addedBankDetailsData[indexPath.row].bankName
            cell.bankDotBtn.tag = indexPath.row
            cell.bankDotBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            cell.bankDetailView.isHidden = false
            if addedBankDetailsData[indexPath.row].defaultForCurrency == true{
                cell.bankPrefferdV.isHidden = false
                cell.bankDotBtn.isHidden = true
            }else{
                cell.bankPrefferdV.isHidden = true
                cell.bankDotBtn.isHidden = false
            }
            cell.cardDetailView.isHidden = true
            return cell
        }else if tableView == cardTblV{
            let cell = cardTblV.dequeueReusableCell(withIdentifier: "BankDetailTblVCell", for: indexPath) as! BankDetailTblVCell
            cell.cardDetailLbl.text = "**** **** **** \(addedCardDetailsData[indexPath.row].lastFourDigits ?? "")"
            cell.cardDotBtn.tag = indexPath.row
            cell.cardDotBtn.addTarget(self, action: #selector(CardDotBtnTapped(_:)), for: .touchUpInside)
            cell.bankDetailView.isHidden = true
            cell.cardPrefferdV.isHidden = true
            cell.cardDotBtn.isHidden = false
            cell.cardDetailView.isHidden = false
            if addedCardDetailsData[indexPath.row].defaultForCurrency == true{
                cell.cardPrefferdV.isHidden = false
                cell.cardDotBtn.isHidden = true
            }else{
                cell.cardPrefferdV.isHidden = true
                cell.cardDotBtn.isHidden = false
            }
            return cell
        }else{
            
            let cell = paymentMethodTblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
            let data = getCardArr?[indexPath.row]
            cell.lbl_cardNumber.text = ("**** **** **** \(data?.last4 ?? "")")
            cell.btnDot.addTarget(self, action: #selector(buttonDotSavedCard(_:)), for: .touchUpInside)
            
            if data?.isPreferred == true {
                cell.lbl_Preferred.isHidden = false
                // cell.btnDot_View.isHidden = true
            } else {
                cell.lbl_Preferred.isHidden = true
                //  cell.btnDot_View.isHidden = false
            }
            
            return cell
        }
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let data = getCardArr?[indexPath.row]
    //        self.indx = indexPath.row
    //        self.CardViewModel.apiForSetPreferredCard(cardID: data?.cardID ?? "")
    //    }
    
    @objc func buttonDotSavedCard(_ sender: UIButton) {
        // Convert the button's origin to the tableView's coordinate space
        let buttonPosition = sender.convert(CGPoint.zero, to: paymentMethodTblV)
        
        // Get the indexPath safely from that point
        guard let indexPath = paymentMethodTblV.indexPathForRow(at: buttonPosition),
              let data = getCardArr?[indexPath.row] else {
            print("Could not find indexPath for tapped button")
            return
        }
        // Capture the index and cardID now (prevents reuse issues)
        let tappedIndex = indexPath.row
        let tappedCardID = data.cardID
        self.indexCard = tappedCardID ?? ""
        
        // Preferred card => only Delete
        if data.isPreferred == true {
            dotDropdown.dataSource = ["    Delete"]
        } else {
            dotDropdown.dataSource = ["    Set as primary", "    Delete"]
        }
        
        
        // Configure dropdown
        dotDropdown.anchorView = sender
        // dotDropdown.dataSource = dotArr1
        dotDropdown.direction = .bottom
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        if let anchorView = dotDropdown.anchorView?.plainView {
            dotDropdown.width = anchorView.frame.width + 140
        }
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -140, y: anchorHeight)
        }
        
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14)
            cell.optionLabel.textColor = UIColor.black
        }
        
        // Use the captured values inside the selection action
        //        dotDropdown.selectionAction = { [weak self] (index, item) in
        //            guard let self = self else { return }
        //            print("Selected: \(item) at dropdown index: \(index) for cell index: \(tappedIndex)")
        //            if index == 0 {
        //                // Set as primary — same behavior as didSelectRowAt
        //                self.indx = tappedIndex
        //                self.viewModel.apiForSetPreferredCard(cardID: tappedCardID ?? "")
        //            } else if index == 1 {
        //                self.tabBarController?.setTabBarHidden(true, animated: false)
        //
        //                self.deletePopUpMainView.isHidden = false
        //                self.indx = tappedIndex
        ////                self.viewModel.apiForDeleteSavedCard(cardID: tappedCardID ?? "")
        ////                cardNumTblV.reloadData()
        //            }
        //        }
        dotDropdown.selectionAction = { [weak self] (_, item) in
            guard let self = self else { return }
            
            if item.trimmingCharacters(in: .whitespaces) == "Set as primary" {
                
                self.indx = tappedIndex
                self.viewModel.apiForSetPreferredCard(cardID: tappedCardID ?? "")
                
            } else if item.trimmingCharacters(in: .whitespaces) == "Delete" {
                
                self.tabBarController?.setTabBarHidden(true, animated: false)
                self.deletePopUpMainView.isHidden = false
                self.indx = tappedIndex
                
                // Or directly call delete API
                // self.viewModel.apiForDeleteSavedCard(cardID: tappedCardID ?? "")
            }
        }
        dotDropdown.show()
    }
    @objc func buttonTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = ["Set as primary","Delete"]
        dotDropdown.direction = .any
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black
        }
        //        dotDropdown.selectionAction = { [weak self] (index, item) in
        //            guard let self = self else { return }
        //            print("Selected month: \(item)")
        //            if index == 0{
        //                self.viewModelPaymentMethod.apiforSetPrimaryMethod(id: self.addedBankDetailsData[sender.tag].id)
        //            }else{
        //                self.viewModelPaymentMethod.apiforDeletePayoutMethod(id: self.addedBankDetailsData[sender.tag].id)
        //            }
        //            //Api For GetPayoutMethods
        //            viewModelPaymentMethod.apiforGetPayoutMethods()
        //        }
        dotDropdown.selectionAction = { [weak self] (_, item) in
            guard let self = self else { return }
            
            print("Selected: \(item)")
            
            let selectedItem = item.trimmingCharacters(in: .whitespaces)
            
            switch selectedItem {
                
            case "Set as primary":
                self.viewModelPaymentMethod.apiforSetPrimaryMethod(
                    id: self.addedBankDetailsData[sender.tag].id
                )
                
            case "Delete":
                self.viewModelPaymentMethod.apiforDeletePayoutMethod(
                    id: self.addedBankDetailsData[sender.tag].id
                )
                
            default:
                break
            }
        }
        dotDropdown.show()
    }
    @objc func CardDotBtnTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = ["Set as primary","Delete"]
        dotDropdown.direction = .any
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        //        dotDropdown.selectionAction = { [weak self] (index, item) in
        //            guard let self = self else { return }
        //            print("Selected month: \(item)")
        //            if index == 0{
        //                self.viewModelPaymentMethod.apiforSetPrimaryMethod(id: self.addedCardDetailsData[sender.tag].id)
        //            }else{
        //                self.viewModelPaymentMethod.apiforDeletePayoutMethod(id: self.addedCardDetailsData[sender.tag].id)
        //            }
        //            //Api For GetPayoutMethods
        //            viewModelPaymentMethod.apiforGetPayoutMethods()
        //        }
        
        dotDropdown.selectionAction = { [weak self] (_, item) in
            guard let self = self else { return }
            
            print("Selected: \(item)")
            
            let selectedItem = item.trimmingCharacters(in: .whitespaces)
            
            if selectedItem == "Set as primary" {
                
                self.viewModelPaymentMethod.apiforSetPrimaryMethod(
                    id: self.addedCardDetailsData[sender.tag].id
                )
                
            } else if selectedItem == "Delete" {
                
                self.viewModelPaymentMethod.apiforDeletePayoutMethod(
                    id: self.addedCardDetailsData[sender.tag].id
                )
            }
        }
        dotDropdown.show()
    }
}
extension HostProfileVC:UICollectionViewDelegateFlowLayout {
    
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
//extension HostProfileVC: CLLocationManagerDelegate{
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
//extension HostProfileVC: GMSAutocompleteViewControllerDelegate {
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        guard let placeName = place.name else { return }
//        print("Place name: \(placeName)")
//        print("Place ID: \(place.placeID ?? "N/A")")
//        print("Latitude: \(place.coordinate.latitude)")
//        print("Longitude: \(place.coordinate.longitude)")
//        print("Formatted Address: \(place.formattedAddress ?? "N/A")")
//        // Save to UserDefaults
//        UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
//        UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
//        if addNewLocation == "Yes" {
//            print("PlaceAPI triggered")
//            viewModel.apiForAddPlace(PlaceName: placeName)
//            NotificationCenter.default.post(
//                name: NSNotification.Name("currentLocation"),
//                object: ["latitude": "\(place.coordinate.latitude)", "longitude": "\(place.coordinate.longitude)"]
//            )
//        } else {
//            updateAddressFields(from: place.coordinate, fallbackStreet: placeName)
//        }
//       // }
//        dismiss(animated: true, completion: nil)
//    }
//    private func updateAddressFields(from coordinate: CLLocationCoordinate2D, fallbackStreet: String) {
//        extractAddressDetails(from: coordinate) { [weak self] street, city, state, zip in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.txt_streetProfile.text = street?.isEmpty == false ? street : fallbackStreet
//                self.txt_cityProfile.text = city
//                self.txt_stateProfile.text = state
//                self.txt_zipProfile.text = zip
//                [self.btnEditCity, self.btnEditState, self.btnEditZip].forEach {
//                    $0?.setImage(UIImage(named: "rightSigntick"), for: .normal)
//                }
//                self.isCityUpdateStatus = true
//                self.isStateUpdateStatus = true
//                self.isZipcdeUpdateStatus = true
//            }
//        }
//    }
//    private func extractAddressDetails(from coordinate: CLLocationCoordinate2D,
//                                       completion: @escaping (_ street: String?, _ city: String?, _ state: String?, _ zip: String?) -> Void) {
//        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            guard let placemark = placemarks?.first, error == nil else {
//                print("Reverse geocode failed: \(error?.localizedDescription ?? "Unknown error")")
//                completion(nil, nil, nil, nil)
//                return
//            }
//            let street = [placemark.subThoroughfare, placemark.thoroughfare]
//                .compactMap { $0 }
//                .joined(separator: " ")
//            completion(street, placemark.locality, placemark.administrativeArea, placemark.postalCode)
//        }
//    }
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("Autocomplete Error: \(error.localizedDescription)")
//    }
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}
extension HostProfileVC :DPOTPViewDelegate{
    func dpOTPViewAddText(_ text: String, at position: Int) {
        // viewModel.updateOTPText(text)
    }
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
}
extension HostProfileVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == txt_streetProfile {
            
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else {
                return true
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            fetcher?.sourceTextHasChanged(updatedText)
            
            return true
        }
        
        return true
    }
    
    
    
    @objc func keyboardWillShow2(_ notification: Notification) {
        
        guard let keyboardFrame =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect else { return }
        
        // only increase bottom space
        let bottomInset = 40
        
        collecV_Place.contentInset =
        UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        collecV_Place.scrollIndicatorInsets =
        collecV_Place.contentInset
        
        
        self.collecV_MyWork.contentInset.bottom = 0
        self.collecV_MyWork.scrollIndicatorInsets.bottom = 0
    }
    
    @objc func keyboardWillHide2(_ notification: Notification) {
        
        collecV_Place.contentInset = .zero
        collecV_Place.scrollIndicatorInsets = .zero
        
        self.collecV_MyWork.contentInset.bottom = 0
        self.collecV_MyWork.scrollIndicatorInsets.bottom = 0
    }
    
  
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        scrollV.contentInset.bottom = keyboardHeight
        scrollV.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if let activeField = activeTextField {
            scrollViewToVisible(activeField, withKeyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        
        scrollV.contentInset.bottom = 0
        scrollV.verticalScrollIndicatorInsets.bottom = 0
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
        if textField == txt_streetProfile {
            self.addNewLocation = "No"
            // self.autocompleteClicked()
        }
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

extension HostProfileVC {
    func bindVC(){
        // updateStreetResult
        viewModel.$updateStreetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var txt = response.data?.addedStreetAddress ?? ""
                    self.txt_streetProfile.text = txt
                    self.btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_streetProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        
        viewModel.$updateZipCodeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    if !self.updateAllAddress{
                        self.showToast(response.message ?? "")
                    }
                    let txt = response.data?.addedzipcode ?? ""
                    self.txt_zipProfile.text = txt
                    self.btnEditZip.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_zipProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        //updateStateResult
        viewModel.$updateStateResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    if !self.updateAllAddress{
                        self.showToast(response.message ?? "")
                    }
                    let txt = response.data?.addedstate ?? ""
                    self.txt_stateProfile.text = txt
                    self.btnEditState.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_stateProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        //updateCityResult
        viewModel.$updateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    if !self.updateAllAddress{
                        self.showToast(response.message ?? "")
                    }
                    let txt = response.data?.addedCity ?? ""
                    self.txt_cityProfile.text = txt
                    self.btnEditCity.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_cityProfile.isUserInteractionEnabled = false
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
                    if txt == "" {
                        self.aboutMeTxtV.text = self.placeholderText
                    }else {
                        self.aboutMeTxtV.text = txt }
                    
                    DispatchQueue.main.async {
                        self.updateAboutMeHeight()
                    }
                    self.aboutMeTxtV.textColor = .black
                    self.aboutMeTxtV.isEditable = false
                    
                    self.aboutMeTxtV.isEditable = false
                    self.ImgBtn_AboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    // img_UpdateAboutMeButton.image = UIImage(named: "EditPencilicon")
                    // self.lbl_AboutMeButton.text = "Edit"
                    self.aboutMeTxtV.resignFirstResponder()
                    
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
                    var image = response.data?.profileImageURL ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    
                    UserDetail.shared.setProfileimg(imgURL)
                    
                    if let tabBarVC = self.tabBarController as? HostMyTabVC {
                        tabBarVC.setProfileTabImage()
                    }
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                })
            }.store(in: &cancellables)
        
        // AddLanguage
        viewModel.$addLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedlng = response.data?.addedlanguage ?? ""
                    self.myLanguageArr.append(addedlng)
                    self.collecV_MyLanguage.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deleteLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myLanguageArr.remove(at: self.indexforDeleteLanguage ?? 0)
                    self.collecV_MyLanguage.reloadData()
                })
            }.store(in: &cancellables)
        // AddPet
        viewModel.$addPetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedPet = response.data?.addedPet ?? ""
                    self.myPetsArr.append(addedPet)
                    self.collecV_MyPets.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deletePetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myPetsArr.remove(at: self.indexforDeletePet ?? 0)
                    self.collecV_MyPets.reloadData()
                })
            }.store(in: &cancellables)
        
        // AddHobby
        viewModel.$addHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedHobby = response.data?.addedHobby ?? ""
                    self.myHobbiesArr.append(addedHobby)
                    self.collecV_MyHobbies.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deleteHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myHobbiesArr.remove(at: self.indexforDeleteHobby ?? 0)
                    self.collecV_MyHobbies.reloadData()
                })
            }.store(in: &cancellables)
        // AddPlace
        viewModel.$addPlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedLocation = response.data?.addedLocation ?? ""
                    self.locationArray.append(addedLocation)
                    self.collecV_Place.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deletePlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.locationArray.remove(at: self.indexforDeleteLocation ?? 0)
                    self.collecV_Place.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteWork
        viewModel.$deleteWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myWorkArr.remove(at: self.indexforDeleteWork ?? 0)
                    self.collecV_MyWork.reloadData()
                })
            }.store(in: &cancellables)
        
        // AddWork
        viewModel.$addWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var workAdded = response.data?.addedWork ?? ""
                    self.myWorkArr.append(workAdded)
                    self.collecV_MyWork.reloadData()
                })
            }.store(in: &cancellables)
        //Get Profile Result
        viewModel.$getMyProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    // self.showToast(response.message ?? "")
                    self.profileData = nil
                    self.profileData = response.data
                    var isEmailVerified = self.profileData?.emailVerified ?? 0
                    // print(isEmailVerified,"isEmailVerified")
                    var isPhoneVerified = self.profileData?.phoneVerified ?? 0
                    // print(isPhoneVerified,"isPhoneVerified")
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
                        self.view_ConfirmNowIndentity.isHidden = true
                        self.view_VerifiedIndentity.isHidden = false
                    } else {
                        self.view_ConfirmNowIndentity.isHidden = false
                        self.view_VerifiedIndentity.isHidden = true
                    }
                    let imgURL = AppURL.imageURL + (self.profileData?.profileImage ?? "")
                    self.profileIMGURL = imgURL
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    var nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")"
                    // var imgurlss = self.profileData?.profileImage ?? ""
                    print(nameUser,"nameUser")
                    if nameUser == " !" {
                        self.lbl_nameUser.text = "Hey Host!"
                    } else {
                        self.lbl_nameUser.text = "Hey \(nameUser)!" }
                    self.fName = "\(self.profileData?.firstName  ?? "")"
                    self.lName = "\(self.profileData?.lastName  ?? "")"
                    let street =  self.profileData?.street ?? ""
                    let city =  self.profileData?.city ?? ""
                    let state =  self.profileData?.state ?? ""
                    let zip =  self.profileData?.zipCode ?? ""
                    
                    self.txt_streetProfile.text = street
                    self.txt_cityProfile.text = city
                    self.txt_stateProfile.text = state
                    self.txt_zipProfile.text = zip
                    let email = self.profileData?.email ?? ""
                    let desc = self.profileData?.aboutMe ?? ""
                    
                    let Phone = self.profileData?.phoneNumber ?? ""
                    
                    if desc == "" {
                        self.aboutMeTxtV.text = self.placeholderText
                    } else {
                        self.aboutMeTxtV.text = desc }
                    
                    DispatchQueue.main.async {
                        self.updateAboutMeHeight()
                    }
                    
                    if self.aboutMeTxtV.text == self.placeholderText  {
                        self.aboutMeTxtV.textColor = .gray
                    } else {
                        self.aboutMeTxtV.textColor = .black
                    }
                    
                    self.txt_PhoneProfile.text = Phone
                    
                    self.txt_EmailProfile.text = email
                    self.myPetsArr = self.profileData?.pets ?? []
                    self.myHobbiesArr = self.profileData?.hobbies ?? []
                    self.myLanguageArr = self.profileData?.languages ?? []
                    self.locationArray = self.profileData?.whereLive ?? []
                    self.myWorkArr = self.profileData?.myWork ?? []
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
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
                    self.view_ConfirmNowIndentity.isHidden = true
                    self.view_VerifiedIndentity.isHidden = false
                })
            }.store(in: &cancellables)
        
        //setPreferredCard
        viewModel.$setPreferredResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.card_id = self.getCardArr?[self.indx ?? 0].cardID ?? ""
                    
                    
                    if let selectedIndex = self.indx {
                        
                        for i in 0..<self.getCardArr!.count {
                            self.getCardArr?[i].isPreferred = false
                        }
                        
                        self.getCardArr?[self.indx ?? 0].isPreferred = true
                        
                        DispatchQueue.main.async {
                            self.paymentMethodTblV.reloadData()
                        }
                    }
                    // self.viewModel.apiForGetSavedCard()
                })
            }.store(in: &cancellables)
        
        //getSavedCard
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.getCardArr = response.data?.cards
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    
                    if self.getCardArr?.count == 0 {
                        self.cardTblV.setEmptyView(message: "No Data Found")
                    } else {
                        self.cardTblV.setEmptyView(message: "")
                    }
                    
                    self.cardTblV.reloadData()
                    // self.paymentMethodTblV.reloadData()
                })
            }.store(in: &cancellables)
        
        //DeleteSavedCard
        viewModel.$deleteSavedCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.getCardArr?.remove(at: self.indx ?? 0)
                    
                    if self.getCardArr?.count == 0 {
                        self.cardTblV.setEmptyView(message: "No Data Found")
                    } else {
                        self.cardTblV.setEmptyView(message: "")
                    }
                    self.deletePopUpMainView.isHidden = true
                    self.tabBarController?.setTabBarHidden(false, animated: false)
                    self.paymentMethodTblV.reloadData()
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_GetPayoutMethods() {
        viewModelPaymentMethod.$getPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        self.addedBankDetailsData.removeAll()
                        self.addedCardDetailsData.removeAll()
                        self.addedBankDetailsData = response.data?.bankAccounts ?? []
                        self.addedCardDetailsData = response.data?.cards ?? []
                        
                        if self.addedCardDetailsData.count == 0 {
                            self.cardTblV.setEmptyView(message: "No Data Found")
                        } else {
                            self.cardTblV.setEmptyView(message: "")
                        }
                        
                        if self.addedBankDetailsData.count == 0 {
                            self.bankTblV.setEmptyView(message: "No Data Found")
                        } else {
                            self.bankTblV.setEmptyView(message: "")
                        }
                        self.bankTblV.reloadData()
                        self.cardTblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
        
        //GetCard Result
        CardViewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.getCardArr = response.data?.cards
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    
                    if self.getCardArr?.count != 0 {
                        self.paymentMethodV.isHidden = false
                    } else {
                        self.paymentMethodV.isHidden = true
                        self.showToast("No data found")
                    }
                    self.paymentMethodTblV.reloadData()
                })
            }.store(in: &cancellables)
    }

    func showPayoutSetupPopup() {
        let popupVC = HostPayoutSetupPopupVC()
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true, completion: nil)
    }

// MARK: - Custom Payout Setup Popup VC
class HostPayoutSetupPopupVC: UIViewController {
    
    var onOkTapped: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.font = UIFont(name: "Poppins-Bold", size: 19) ?? UIFont(name: "Poppins-SemiBold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
            let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(red: 0.25, green: 0.30, blue: 0.35, alpha: 1.0)
        } else {
            button.setTitle("✕", for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete your payout setup in Profile before publishing your listing."
        label.font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(white: 0.5, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1.0)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let bgTap = UITapGestureRecognizer(target: self, action: #selector(closePressed))
        bgTap.cancelsTouchesInView = false
        view.addGestureRecognizer(bgTap)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(separatorView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            messageLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 24),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 28),
            okButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            okButton.heightAnchor.constraint(equalToConstant: 48),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func okPressed() {
        dismiss(animated: true) { [weak self] in
            self?.onOkTapped?()
        }
    }
    
    @objc private func closePressed() {
        dismiss(animated: true)
    }
}
    
    func bindVC_SetPrimary() {
        viewModelPaymentMethod.$SetPrimaryPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModelPaymentMethod.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_DeleteMethode() {
        viewModelPaymentMethod.$DeletePayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModelPaymentMethod.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
}

extension HostProfileVC{
    func configureCollectionView(_ collectionView: UICollectionView?) {
        let nib = UINib(nibName: "MasterCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "MasterCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
    }
}

extension HostProfileVC{
    func configureTableView(_ tableView: UITableView?) {
        let nib = UINib(nibName: "BankDetailTblVCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "BankDetailTblVCell")
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}
