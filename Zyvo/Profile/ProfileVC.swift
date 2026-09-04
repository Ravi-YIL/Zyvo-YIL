//
//  ProfileVC.swift
//  Zyvo
//
//  Created by ravi on 8/11/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import CountryPickerView
import Combine
import Persona2
import DropDown
import AVFoundation

class ProfileVC: UIViewController,UITextViewDelegate,UIPopoverPresentationControllerDelegate, GMSAutocompleteFetcherDelegate {
    
    
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
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnEditStreet: UIButton!
    @IBOutlet weak var btnEditCity: UIButton!
    @IBOutlet weak var btnEditState: UIButton!
    @IBOutlet weak var btnEditZip: UIButton!
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedIndentity: UIView!
    @IBOutlet weak var view_ConfirmNowIndentity: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    @IBOutlet weak var view_ProfilePassword: UIView!
    @IBOutlet weak var view_ProfilePhoneNumber: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zip: UIView!
    @IBOutlet weak var view_EmailProfile: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var view_UploadPhoto: UIView!
    @IBOutlet weak var collecV_Place: UICollectionView!
    @IBOutlet weak var collecV_MyWork: UICollectionView!
    @IBOutlet weak var collecV_MyLanguage: UICollectionView!
    @IBOutlet weak var collecV_MyHobbies: UICollectionView!
    @IBOutlet weak var aboutMe_HConst: NSLayoutConstraint!
    @IBOutlet weak var collecV_MyPets: UICollectionView!
    @IBOutlet weak var view_AboutMe: UIView!
    @IBOutlet weak var view_Dark: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var cardNumTblV: UITableView!
    @IBOutlet weak var addCardBtnV: UIView!
    @IBOutlet weak var cardListV: UIView!
    @IBOutlet weak var viewAddCardBtn: UIView!
    @IBOutlet weak var AddCardBtnView: UIView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var tblVH_Consts: NSLayoutConstraint!
    @IBOutlet weak var paymentDropIcon: UIImageView!
    @IBOutlet weak var paymentDropBtnO: UIButton!
    @IBOutlet weak var txt_PhoneProfile: UITextField!
    @IBOutlet weak var lbl_nameUser: UILabel!
    @IBOutlet weak var txt_PasswordProfile: UITextField!
    @IBOutlet weak var txtV_AboutMe: UITextView!
    @IBOutlet weak var txt_EmailProfile: UITextField!
    @IBOutlet weak var txt_streetProfile: UITextField!
    @IBOutlet weak var txt_cityProfile: UITextField!
    @IBOutlet weak var txt_stateProfile: UITextField!
    @IBOutlet weak var txt_zipProfile: UITextField!
    @IBOutlet weak var deletePopUpMainView: UIView!
    @IBOutlet weak var deletePopUpView: UIView!
    @IBOutlet weak var deletePopUpLbl: UILabel!
    @IBOutlet weak var deletePopUpBtn: UIButton!
    @IBOutlet weak var cancelPopUpBtn: UIButton!
    @IBOutlet weak var view_MainPassword: UIView!
    @IBOutlet weak var infoBtnO: UIButton!
    
    // MARK: - Internal Helper Properties
    var identity_verify: Int? = 0
    var types = ""
    var fName = ""
    var lName = ""
    var verificationStatus = ""
    var locationArray: [String] = []
    var indexforDeleteLocation: Int? = 0
    var myWorkArr: [String] = []
    var indexforDeleteWork: Int? = 0
    var myLanguageArr: [String] = []
    var indexforDeleteLanguage: Int? = 0
    var myHobbiesArr: [String] = []
    var indexforDeleteHobby: Int? = 0
    var myPetsArr: [String] = []
    var indexforDeletePet: Int? = 0
    var editEmail_Phone = ""
    var OTP = ""
    var userID = ""
    var tempID = ""
    var workDataAfterDeletion: DeleteWorkModel?
    var profileData: MyProfileModel?
    var getCardArr: [Card]?
    var card_id = ""
    var customerID = ""
    var indx: Int? = 0
    var indexCard: String = ""
    var phonetobeUpdate = ""
    var isAboutMeStatus = false
    var isStreetUpdateStatus = false
    var isCityUpdateStatus = false
    var isStateUpdateStatus = false
    var isZipcdeUpdateStatus = false
    var profileIMGURL = ""
    var firstName = ""
    var lastName = ""
    var addNewLocation = "No"
    var updateAllAddress = false
    var activeLocationTextField: UITextField?
    var currentLocationSelectionType: LocationSelectionType?
    
    // MARK: - Private Properties
    private var placesClient: GMSPlacesClient!
    private var activeTextField: UITextField?
    private var timer = Timer()
    private let countryPicker = CountryPickerView()
    private let dotDropdown = DropDown()
    private let dotArr = ["    Set as primary", "    Delete"]
    private var viewModel = GetMyProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let placeholderText = "Write about yourself"
    private let editImage = UIImage(named: "EditPencilicon")
    private let saveImage = UIImage(named: "rightSigntick")
    private var fetcher: GMSAutocompleteFetcher!
    private var predictions = [GMSAutocompletePrediction]()
    private let dropDownLocation = DropDown()
    
    deinit {
        cardNumTblV?.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        setupDropDown()
        bindVC()
        setupTextView()
        setupTextFields()
        setupProfileViews()
        setupCollectionView(collecV_Place)
        setupCollectionView(collecV_MyWork)
        setupCollectionView(collecV_MyLanguage)
        setupCollectionView(collecV_MyHobbies)
        setupCollectionView(collecV_MyPets)
        configureUserType()
        setupTextViewsAndButtons()
        setupVerificationViews()
        setupPhotoAndProfileViews()
        setupCardTableView()
        setDeleteView()
        //        cardNumTblV.layer.borderColor = UIColor.lightGray.cgColor
        //        cardNumTblV.layer.borderWidth = 1
        //        cardNumTblV.layer.cornerRadius = 10
        cardNumTblV.separatorStyle = .none
        self.deletePopUpMainView.isHidden = true
        
        txtV_AboutMe.font = UIFont(name: "Poppins", size: 14)!
        
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
        
        self.collecV_MyPets.contentInset.bottom = 0
        self.collecV_MyPets.scrollIndicatorInsets.bottom = 0
        
        self.collecV_MyHobbies.contentInset.bottom = 0
        self.collecV_MyHobbies.scrollIndicatorInsets.bottom = 0
        
    }
    
    @objc func keyboardWillHide2(_ notification: Notification) {
        
        collecV_Place.contentInset = .zero
        collecV_Place.scrollIndicatorInsets = .zero
        
        self.collecV_MyWork.contentInset.bottom = 0
        self.collecV_MyWork.scrollIndicatorInsets.bottom = 0
        
        self.collecV_MyPets.contentInset.bottom = 0
        self.collecV_MyPets.scrollIndicatorInsets.bottom = 0
        
        self.collecV_MyHobbies.contentInset.bottom = 0
        self.collecV_MyHobbies.scrollIndicatorInsets.bottom = 0
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
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: txt_streetProfile.bounds.height - 80)
        
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
            width: txtV_AboutMe.frame.width,
            height: .greatestFiniteMagnitude
        )
        
        let estimatedSize = txtV_AboutMe.sizeThatFits(size)
        
        aboutMe_HConst.constant = estimatedSize.height
        
        self.view.layoutIfNeeded()
    }
    private func configureUserType() {
        let user = UserDetail.shared.getUserType()
        view_MainPassword.isHidden = (user != "Email")
        //        viewModel.apiForGetSavedCard()
    }
    //    private func setupTextViewsAndButtons() {
    //        txtV_AboutMe.delegate = self
    //        btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
    //        keyboardNotifications()
    //        IQKeyboardManager.shared.enable = false
    //    }
    
    private func setupTextViewsAndButtons() {
        txtV_AboutMe.delegate = self
        btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
        keyboardNotifications()
        
        // Instead of completely turning it off globally, tell IQKeyboardManager
        // to ignore only this textview or allow suggestions:
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true // Ensures accessory bars don't blank out suggestions
    }
    private func setupVerificationViews() {
        addCardBtnV.isHidden = false
        cardListV.isHidden = true
        setupFullScreenSubview(view_UploadPhoto)
        setupFullScreenSubview(deletePopUpMainView)
    }
    private func setupFullScreenSubview(_ subview: UIView) {
        subview.frame = self.view.bounds
        self.view.addSubview(subview)
        subview.isHidden = true
    }
    private func setupPhotoAndProfileViews() {
        view_Dark.layer.cornerRadius = 20
        view_Photo.makeCircular(borderWidth: 3, borderColor: UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.18))
        view_ProfileDetails.applyRoundedBorder(radius: 15, borderWidth: 0.75, borderColor: .lightGray)
        view_AboutMe.applyRoundedBorder(radius: 15, borderWidth: 0.75, borderColor: .lightGray)
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
    }
    private func setupCardTableView() {
        cardNumTblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        cardNumTblV.delegate = self
        cardNumTblV.dataSource = self
        cardNumTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
    
    func setupProfileViews() {
        view_EmailProfile.applyRoundedBorder()
        view_ProfilePassword.applyRoundedBorder()
        view_ProfilePhoneNumber.applyRoundedBorder()
        view_State.applyRoundedBorder()
        view_City.applyRoundedBorder()
        view_Zip.applyRoundedBorder()
        view_Street.applyRoundedBorder()
        viewAddCardBtn.applyRoundedBorder()
        AddCardBtnView.applyRoundedBorder()
        view_EmailProfile.applyLightGrayRoundedBorder()
    }
    private func setupCollectionView(_ collectionView: UICollectionView?) {
        let nib = UINib(nibName: "MasterCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "MasterCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        cardNumTblV.layer.removeAllAnimations()
        tblVH_Const.constant = cardNumTblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
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
        
        txtV_AboutMe.isScrollEnabled = false
        txtV_AboutMe.delegate = self
        txtV_AboutMe.isEditable = false
        
        txtV_AboutMe.text = placeholderText
        txtV_AboutMe.textColor = .lightGray
        
        txtV_AboutMe.textContainerInset = .zero
        txtV_AboutMe.textContainer.lineFragmentPadding = 0
        
        // FORCE autocorrection and keyboard suggestions to show:
        txtV_AboutMe.autocorrectionType = .yes
        txtV_AboutMe.spellCheckingType = .yes
        txtV_AboutMe.keyboardType = .default
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.getProfile()
        
    }
    @IBAction func btnEditAboutMe_Tap(_ sender: UIButton) {
        if isAboutMeStatus {
            if txtV_AboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || txtV_AboutMe.text == placeholderText {
                self.showAlert(for: "Please enter your About Me")
                txtV_AboutMe.becomeFirstResponder()
                isAboutMeStatus = false
                txtV_AboutMe.isEditable = true
                btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
            } else {
                txtV_AboutMe.isEditable = false
                txtV_AboutMe.resignFirstResponder()
                viewModel.apiForUpdateAboutMe(AboutMe: txtV_AboutMe.text)
                btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            }
        } else {
            
            txtV_AboutMe.isEditable = true
            txtV_AboutMe.becomeFirstResponder()
            btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
            if txtV_AboutMe.text == placeholderText {
                txtV_AboutMe.text = ""
                txtV_AboutMe.textColor = .black
            }
        }
        isAboutMeStatus.toggle()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(
            width: txtV_AboutMe.frame.width,
            height: .infinity
        )
        
        let estimatedSize = txtV_AboutMe.sizeThatFits(size)
        
        aboutMe_HConst.constant = estimatedSize.height
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.scrollV.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtV_AboutMe.text.isEmpty {
            txtV_AboutMe.text = placeholderText
            txtV_AboutMe.textColor = UIColor.lightGray // Reset to placeholder color
            
            // Disable suggestions/corrections for placeholder
            txtV_AboutMe.autocorrectionType = .no
            txtV_AboutMe.spellCheckingType = .no
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtV_AboutMe.text == placeholderText {
            // Enable corrections now that the placeholder is gone
            txtV_AboutMe.autocorrectionType = .default
            txtV_AboutMe.spellCheckingType = .default
            txtV_AboutMe.text = "" // Clear text when starting to type
            txtV_AboutMe.textColor = UIColor.black // Set text color to normal
        }
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
        
        
        // Start autocomplete
        // fetcher?.sourceTextHasChanged(txt_streetProfile.text ?? "")
        
        //        if isStreetUpdateStatus {
        //
        //            fetcher?.sourceTextHasChanged(self.txt_streetProfile.text ?? "")
        //            // Stop editing and call API
        ////            txt_streetProfile.isUserInteractionEnabled = false
        ////            btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
        ////            txt_streetProfile.resignFirstResponder()
        ////            //  if txt_streetProfile.text != placeholderText {
        ////            print("api call here for edit Street")
        ////            self.updateAllAddress = true
        ////            viewModel.apiForUpdateStreet(StreetAddress: self.txt_streetProfile.text ?? "")
        ////            if self.txt_cityProfile.text != ""{
        ////                viewModel.apiForUpdateCity(City: self.txt_cityProfile.text ?? "")
        ////            }
        ////            if self.txt_stateProfile.text != ""{
        ////                viewModel.apiForUpdateState(State: self.txt_stateProfile.text ?? "")
        ////            }
        ////            if self.txt_zipProfile.text != ""{
        ////                viewModel.apiForUpdateZipcode(zip: self.txt_zipProfile.text ?? "")
        ////            }
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
            self.updateAllAddress = false
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
    
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeNameVC") as? ChangeNameVC else { return }
        vc.profileIMGURL = self.profileIMGURL
        vc.firstName = self.fName
        vc.lastName = self.lName
        vc.backAction = { [weak self] strfName , strlName in
            guard let self = self else { return }
            print(strfName,strlName,"Name Recieved")
            let nameUser = "\(strfName) \(strlName)!"
            print(nameUser,"nameUser")
            self.lbl_nameUser.text = "Hey \(nameUser)"
            self.fName = strfName
            self.lName = strlName
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        print("confirm Email here")
        verificationStatus = "EmailVerified"
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as? OTPSenderVC else { return }
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { [weak self] userID, email, otp, countryCode in
            guard let self = self else { return }
            print(userID, email, otp, "str")
            if !userID.isEmpty || !email.isEmpty || !otp.isEmpty {
                guard let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as? CodeVerifierVC else { return }
                verifyVC.verificationStatus = self.verificationStatus
                verifyVC.OTP = otp
                verifyVC.userID = userID
                verifyVC.countryCode = countryCode
                verifyVC.emailtobeUpdate = email
                verifyVC.backAction = { [weak self] str in
                    guard let self = self else { return }
                    print(str, "str recieved")
                    if str == "Yes" {
                        guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                        pwVC.comesFrom = self.verificationStatus
                        pwVC.backCome = { [weak self] in
                            guard let self = self else { return }
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            self.txt_EmailProfile.text = email
                        }
                        pwVC.modalPresentationStyle = .overCurrentContext
                        self.present(pwVC, animated: true)
                    }
                }
                verifyVC.modalPresentationStyle = .overCurrentContext
                self.present(verifyVC, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func btnLogout_Tap(_ sender: UIButton) {
        print("Logout")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutPopUpVC") as? LogoutPopUpVC else { return }
        vc.backAction = { [weak self] in
            self?.setRootToHomeWithoutLogin()
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
    @IBAction func btnSwitchToHost_Tap(_ sender: UIButton) {
        print("Switch To Hostt")
        let stryB = UIStoryboard(name: "Host", bundle: nil)
        UserDetail.shared.setlogintType("Host")
        let vc = stryB.instantiateViewController(withIdentifier: "HostMyTabVC") as! HostMyTabVC
        
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func btnNotification_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.comgingFrom = "guest"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnHelpCenter_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFaq_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShareFeedback_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareFeedbackVC") as! ShareFeedbackVC
        vc.userType = "Guest"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func infoBtn(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Before you can book or host  on the platform the name on Id must match verification documents."
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .any // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 230, height: 80)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnTermCondition_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "TermCondition"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPrivacy_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "Privacy"
        self.navigationController?.pushViewController(vc, animated: true)
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
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        print("confirm phone here")
        verificationStatus = "PhoneVerified"
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as? OTPSenderVC else { return }
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { [weak self] userID, email, otp, countryCode in
            guard let self = self else { return }
            print(userID, email, otp, countryCode, "str Recieved")
            if !userID.isEmpty || !email.isEmpty || !otp.isEmpty || !countryCode.isEmpty {
                guard let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as? CodeVerifierVC else { return }
                verifyVC.verificationStatus = self.verificationStatus
                verifyVC.OTP = otp
                verifyVC.userID = userID
                verifyVC.phonetobeUpdate = email
                verifyVC.countryCode = countryCode
                verifyVC.backAction = { [weak self] str in
                    guard let self = self else { return }
                    if str == "Yes" {
                        guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                        pwVC.comesFrom = self.verificationStatus
                        pwVC.backCome = { [weak self] in
                            guard let self = self else { return }
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            self.txt_PhoneProfile.text = email
                        }
                        pwVC.modalPresentationStyle = .overCurrentContext
                        self.present(pwVC, animated: true)
                    }
                }
                verifyVC.modalPresentationStyle = .overCurrentContext
                self.present(verifyVC, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func btnverifyIdentity_Tap(_ sender: UIButton) {
        
    }
    @IBAction func btnsaveProfile_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            self.tabBarController?.setTabBarHidden(true, animated: false)
            view_UploadPhoto.isHidden = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if accessGranted {
                        self.tabBarController?.setTabBarHidden(true, animated: false)
                        self.view_UploadPhoto.isHidden = false
                    } else {
                        self.showCameraPermissionDeniedAlert()
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
        self.tabBarController?.setTabBarHidden(false, animated: false)
        view_UploadPhoto.isHidden = true
    }
    @IBAction func btnCamera_Tap(_ sender: UIButton) {
        openCameraWithPermissionCheck(delegate: self)
    }
    @IBAction func paymentMethodDropBtn(_ sender: UIButton){
        
        if sender.isSelected == false {
            
            viewModel.apiForGetSavedCard()
            sender.isSelected = true
            //            self.addCardBtnV.isHidden = true
            //            self.cardListV.isHidden = false
            //            paymentDropIcon.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            self.addCardBtnV.isHidden = false
            self.cardListV.isHidden = true
            paymentDropIcon.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as? AddCardVC else { return }
        vc.backAction = { [weak self] in
            guard let self = self else { return }
            self.addCardBtnV.isHidden = true
            self.cardListV.isHidden = false
            self.paymentDropBtnO.isSelected = true
            self.paymentDropIcon.image = UIImage(named: "União 106")
            self.viewModel.apiForGetSavedCard()
        }
        self.present(vc, animated: true)
    }
    @IBAction func btnGallery_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func editEmailBtn(_ sender: UIButton){
        verificationStatus = "Emailupdate"
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as? OTPSenderVC else { return }
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { [weak self] userID, email, otp, countryCode in
            guard let self = self else { return }
            print(userID, email, otp, "str")
            
            if !userID.isEmpty || !email.isEmpty || !otp.isEmpty {
                guard let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as? CodeVerifierVC else { return }
                verifyVC.verificationStatus = self.verificationStatus
                verifyVC.OTP = otp
                verifyVC.userID = userID
                verifyVC.emailtobeUpdate = email
                verifyVC.backAction = { [weak self] str in
                    guard let self = self else { return }
                    if str == "Yes" {
                        guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                        pwVC.comesFrom = self.verificationStatus
                        self.txt_EmailProfile.text = email
                        pwVC.modalPresentationStyle = .overCurrentContext
                        self.present(pwVC, animated: true)
                    }
                }
                verifyVC.modalPresentationStyle = .overCurrentContext
                self.present(verifyVC, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func editPhoneBtn(_ sender: UIButton){
        verificationStatus = "UpdatePhone"
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as? OTPSenderVC else { return }
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { [weak self] userID, email, otp, countryCode in
            guard let self = self else { return }
            print(userID, email, otp, countryCode, "str Recieved")
            if !userID.isEmpty || !email.isEmpty || !otp.isEmpty || !countryCode.isEmpty {
                guard let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as? CodeVerifierVC else { return }
                verifyVC.verificationStatus = self.verificationStatus
                verifyVC.OTP = otp
                verifyVC.userID = userID
                verifyVC.phonetobeUpdate = email
                verifyVC.countryCode = countryCode
                verifyVC.backAction = { [weak self] str in
                    guard let self = self else { return }
                    if str == "Yes" {
                        guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                        pwVC.comesFrom = self.verificationStatus
                        self.txt_PhoneProfile.text = email
                        pwVC.modalPresentationStyle = .overCurrentContext
                        self.present(pwVC, animated: true)
                    }
                }
                verifyVC.modalPresentationStyle = .overCurrentContext
                self.present(verifyVC, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func editPassBtn(_ sender: UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as? NewPasswordVC else { return }
        vc.comingFrom = "PassChange"
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { [weak self] str in
            guard let self = self else { return }
            print(str,"str")
            if str == "Cancel"{
                print(str)
            }else{
                guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                pwVC.comesFrom = "PassChange"
                pwVC.modalPresentationStyle = .overCurrentContext
                self.present(pwVC, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
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
}

extension ProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension ProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
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
                cell.txt_Workname.delegate = self
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
                cell.txt_Workname.delegate  = self
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "hobbiesicon")
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
                cell.txt_Workname.delegate  = self
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "peticon")
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]
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
        // Ensure the layout is updated
        // Ensure the layout is updated
        cell.btnAddnewWidth.constant = 180
        cell.btnAddnewHeight.constant = 50
        
        UIView.performWithoutAnimation {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        cell.txt_Workname.becomeFirstResponder()   // <-- Missing
        
        activeTextField = cell.txt_Workname        // <-- Add
        // Optionally update the layout for the collection view
        collecV_MyWork.performBatchUpdates(nil)
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewWorkFinal(sender:)), for: .touchUpInside)
    }
    
    @objc func addNewWorkFinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        // cell.widthH_constant.constant = 150
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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as? ChooseLanguageVC else { return }
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { [weak self] str in
            guard let self = self else { return }
            print(str,"Data Recieved")
            self.viewModel.apiForAddLanguage(languageName: str)
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
        
        // Ensure the layout is updated
        // Ensure the layout is updated
        cell.btnAddnewWidth.constant = 180
        cell.btnAddnewHeight.constant = 50
        
        UIView.performWithoutAnimation {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        cell.txt_Workname.becomeFirstResponder()   // <-- Missing
        
        activeTextField = cell.txt_Workname        // <-- Add
        
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
        // Ensure the layout is updated
        cell.btnAddnewWidth.constant = 180
        cell.btnAddnewHeight.constant = 50
        
        UIView.performWithoutAnimation {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        // Optionally update the layout for the collection view
        
        cell.txt_Workname.becomeFirstResponder()   // <-- Missing
        
        activeTextField = cell.txt_Workname        // <-- Add
        
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

extension ProfileVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = getCardArr?.count ?? 0
        // Hide or show the table and empty state view based on data count
        //        cardListV.isHidden = (count == 0)
        //        cardNumTblV.isHidden = (count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardNumTblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let data = getCardArr?[indexPath.row]
        cell.selectionStyle = .none
        
        if data?.cardID?.count == 0{
            print("Blank")
        }
        
        cell.lbl_cardNumber.text = ("**** **** **** \(data?.last4 ?? "")")
        cell.btnDot.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if data?.isPreferred == true {
            cell.lbl_Preferred.isHidden = false
        } else {
            cell.lbl_Preferred.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let data = getCardArr?[indexPath.row]
        //        self.indx = indexPath.row
        //        self.viewModel.apiForSetPreferredCard(cardID: data?.cardID ?? "")
    }
    
    //    @objc func buttonTapped(_ sender: UIButton) {
    //        // Convert the button's origin to the tableView's coordinate space
    //        let buttonPosition = sender.convert(CGPoint.zero, to: cardNumTblV)
    //
    //        // Get the indexPath safely from that point
    //        guard let indexPath = cardNumTblV.indexPathForRow(at: buttonPosition),
    //              let data = getCardArr?[indexPath.row] else {
    //            print("Could not find indexPath for tapped button")
    //            return
    //        }
    //
    //        // Capture the index and cardID now (prevents reuse issues)
    //        let tappedIndex = indexPath.row
    //        let tappedCardID = data.cardID
    //        self.indexCard = tappedCardID ?? ""
    //
    //        // Configure dropdown
    //        dotDropdown.anchorView = sender
    //        dotDropdown.dataSource = dotArr
    //        dotDropdown.direction = .bottom
    //        dotDropdown.backgroundColor = UIColor.white
    //        dotDropdown.cornerRadius = 10
    //        dotDropdown.layer.masksToBounds = false
    //        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
    //        dotDropdown.layer.shadowOpacity = 0.2
    //        dotDropdown.layer.shadowRadius = 10
    //        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
    //
    //        if let anchorView = dotDropdown.anchorView?.plainView {
    //            dotDropdown.width = anchorView.frame.width + 140
    //        }
    //        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
    //            dotDropdown.bottomOffset = CGPoint(x: -140, y: anchorHeight)
    //        }
    //
    //        dotDropdown.customCellConfiguration = { (index, item, cell) in
    //            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14)
    //            cell.optionLabel.textColor = UIColor.black
    //        }
    //
    //        dotDropdown.show()
    //     }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: cardNumTblV)
        
        guard let indexPath = cardNumTblV.indexPathForRow(at: buttonPosition),
              let data = getCardArr?[indexPath.row] else {
            print("Could not find indexPath for tapped button")
            return
        }
        
        self.indx = indexPath.row
        self.indexCard = data.cardID ?? ""
        
        // Preferred card => only Delete
        if data.isPreferred == true {
            dotDropdown.dataSource = ["    Delete"]
        } else {
            dotDropdown.dataSource = ["    Set as primary", "    Delete"]
        }
        
        // Configure dropdown
        dotDropdown.anchorView = sender
        dotDropdown.direction = .bottom
        dotDropdown.backgroundColor = .white
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
            cell.optionLabel.textColor = .black
        }
        
        // Selection Action
        dotDropdown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            
            if item.trimmingCharacters(in: .whitespaces) == "Set as primary" {
                
                print("Set as primary tapped")
                self.viewModel.apiForSetPreferredCard(
                    cardID: self.indexCard
                )
                
            } else if item.trimmingCharacters(in: .whitespaces) == "Delete" {
                
                print("Delete tapped")
                
                self.deletePopUpMainView.isHidden = false
                self.tabBarController?.setTabBarHidden(true, animated: false)
                
                // Direct delete karna ho to:
                // self.viewModel.apiForDeleteSavedCard(cardID: self.indexCard)
            }
        }
        
        dotDropdown.show()
    }
}

extension ProfileVC {
    func bindVC(){
        //updateStateResult
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
        // updateStreetResult
        
        viewModel.$updateStreetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedStreetAddress ?? ""
                    self.txt_streetProfile.text = txt
                    self.btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_streetProfile.isUserInteractionEnabled = false
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
                    self.txtV_AboutMe.text = txt
                    
                    self.updateAboutMeHeight()
                    self.btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txtV_AboutMe.isEditable = false
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
                    
                    let profileurl  = UserDetail.shared.getProfileimg()
                    print(profileurl,"profileurlRAVI profileurlRAVI")
                    
                    if let tabBarVC = self.tabBarController as? MainTabVC {
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
                    let addedlng = response.data?.addedlanguage ?? ""
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
                    let addedLocation = response.data?.addedLocation ?? ""
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
                    let workAdded = response.data?.addedWork ?? ""
                    self.myWorkArr.append(workAdded)
                    self.collecV_MyWork.reloadData()
                })
            }.store(in: &cancellables)
        
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
                    let isPhoneVerified = self.profileData?.phoneVerified ?? 0
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
                    let nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")"
                    print(nameUser,"nameUser")
                    if nameUser != " " {
                        self.lbl_nameUser.text = "Hey \(nameUser)!" } else {
                            self.lbl_nameUser.text = "Hey Guest!"
                        }
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
                    let Phone = self.profileData?.phoneNumber ?? ""
                    let desc = self.profileData?.aboutMe ?? ""
                    
                    if desc != "" {
                        self.txtV_AboutMe.text = desc
                        self.txtV_AboutMe.textColor = .black
                    } else {
                        self.txtV_AboutMe.textColor = .gray
                        self.txtV_AboutMe.text = self.placeholderText
                    }
                    
                    self.updateAboutMeHeight()
                    
                    self.txt_PhoneProfile.text = Phone
                    
                    self.txt_EmailProfile.text = email
                    self.myPetsArr = self.profileData?.pets ?? []
                    self.myHobbiesArr = self.profileData?.hobbies ?? []
                    self.myLanguageArr = self.profileData?.languages ?? []
                    self.locationArray = self.profileData?.whereLive ?? []
                    self.myWorkArr = self.profileData?.myWork ?? []
                    
                    self.collecV_Place.reloadData()
                    self.collecV_MyLanguage.reloadData()
                    self.collecV_MyPets.reloadData()
                    self.collecV_MyWork.reloadData()
                    self.collecV_MyHobbies.reloadData()
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
        
        //getSavedCard
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.addCardBtnV.isHidden = true
                    self.cardListV.isHidden = false
                    self.paymentDropIcon.image = UIImage(named: "União 106")
                    
                    self.getCardArr = response.data?.cards
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    self.cardNumTblV.reloadData()
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
                    self.deletePopUpMainView.isHidden = true
                    self.tabBarController?.setTabBarHidden(false, animated: false)
                    self.getCardArr?.remove(at: self.indx ?? 0)
                    self.cardNumTblV.reloadData()
                    
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
                    self.viewModel.apiForGetSavedCard()
                })
            }.store(in: &cancellables)
    }
}

extension ProfileVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 50
        let cellWidth: CGFloat = 150  // Default width
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

extension ProfileVC: UITextFieldDelegate {
    
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
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo,
              let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
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
                                               selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}
extension ProfileVC: InquiryDelegate {
    func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        print(inquiryId)
        print(status)
        if status ==  "completed" {
            self.identity_verify = 1
            self.view_VerifiedIndentity.isHidden = false
            self.view_ConfirmNowIndentity.isHidden = true
        } else if status ==  "approved" {
            self.identity_verify = 1
            self.view_VerifiedIndentity.isHidden = false
            self.view_ConfirmNowIndentity.isHidden = true
        }  else {
            self.identity_verify = 0
            self.view_VerifiedIndentity.isHidden = true
            self.view_ConfirmNowIndentity.isHidden = false
        }
        viewModel.apiForVerifyIdentity(identityverify: self.identity_verify ?? 0)
        // Inquiry completed
    }
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        // Inquiry cancelled by user
    }
    func inquiryError(_ error: Error) {
        // Inquiry errored
    }
}

enum LocationSelectionType {
    case profileAddress
    case addPlace
}



extension UITextField {
    func disableSuggestions() {
        autocorrectionType = .no
        spellCheckingType = .no
    }
}

extension UITextView {
    func disableSuggestions() {
        autocorrectionType = .no
        spellCheckingType = .no
    }
}
