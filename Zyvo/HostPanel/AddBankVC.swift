//
//  AddBankVC.swift
//  Myka App
//
//  Created by YES IT Labs on 19/12/24.
//

import UIKit
import DropDown
import AVFoundation
import ProgressHUD
import Combine
import CountryPickerView


class AddBankVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,DocumentDelegate, ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        
    }
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var BgV: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var idTypeTF: UITextField!
    @IBOutlet weak var idNumberTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var ssnLast4TF: UITextField!
    @IBOutlet weak var bankNameTF: UITextField!
    @IBOutlet weak var accHolderNameTF: UITextField!
    @IBOutlet weak var accNumberTF: UITextField!
    @IBOutlet weak var conirmAccNumTF: UITextField!
    @IBOutlet weak var routingnumTf: UITextField!
    @IBOutlet weak var selctBankProofTypeTF: UITextField!
    @IBOutlet weak var bankProofTF: UITextField!
    @IBOutlet weak var frontDocTF: UITextField!
    @IBOutlet weak var backDocTF: UITextField!
    
    let idTypeDrop = DropDown()
    let countryDrop = DropDown()
    let stateDrop = DropDown()
    let cityDrop = DropDown()
    let BankProofDrop = DropDown()
    
    var BankProofArr = ["Bank account statement","Voided cheque","Bank letterhead"]
    var idTypeArr = ["Driver License","Passport"]
    var selectedBankProof = ""
    
    var addBankViewModel = AddPayouttBankAccViewModel()
    var CountryStateCityVM = CountryStateViewModel()
    private var cancellables = Set<AnyCancellable>()
    var countryDetails = [CountryStateCityDataModel]()
    var arr_State_Details = [CountryStateCityDataModel]()
    var arr_City_Details = [CountryStateCityDataModel]()
    var countryCode = ""
    var PhoneCountryCode = ""
    var stateCode = ""
    var cityCode = ""
    var idType = ""
    var imagePicker1: ImagePicker!
    var documentPicker: DocumentPicker?
    var BankProofDOC = Data()
    var FrontDOC = Data()
    var BackDOC = Data()
    var fileTypeName = ""
    var pickMediaFor = ""
    private let textShort    = "Please wait..."
    private var timer: Timer?
    
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    let screenWidth = UIScreen.main.bounds.width
    var DOBArr = [String]()
    let validator = PhoneNumberValidator()
    let countryPicker = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeTF.text = "🇺🇸 +1"
        self.PhoneCountryCode = "+1"
        phoneNumTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        countryPicker.delegate = self
        
        phoneNumTF.delegate = self
        phoneNumTF.keyboardType = .numberPad
        
        bindVC()
        CountryStateCityVM.GetCountryStateCityApi()
        bindVC_State()
        bindVC_City()
        bindVC_AddBank()
        BgV.layer.cornerRadius = 15
        // Round top-left and top-right corners only
        BgV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.phoneNumTF.delegate = self
        routingnumTf.delegate = self
        
        toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        toolBar.sizeToFit()
        toolBar.tintColor = .systemBlue
        toolBar.isUserInteractionEnabled = true
 
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        doneButton.tintColor = .black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        dobTF.inputView = datePicker
        dobTF.inputAccessoryView = toolBar
        dobTF.delegate = self
        datePicker.minimumDate = .none
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        imagePicker1 = ImagePicker(presentationController: self, delegate: self)
        documentPicker = DocumentPicker(presentationController:self, delegate: self)
    }
    
    
    @objc func textFieldDidChange() {
        guard let number = phoneNumTF.text,
              let code = countryCodeTF.text else {
            return
        }
        let phoneNumber = (phoneNumTF.text ?? "")
        //let regionCode = expectedRegion // or use "IN" directly
        if phoneNumber != "" {
            let isValid = validator.isValidMobileNumber(countryCode: self.PhoneCountryCode, number: phoneNumber)
            print("Is valid: \(isValid)")
            
            if isValid != true {
                self.showAlert(for: "Please enter valid phone number")
                self.phoneNumTF.text = ""
            }
        }
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnAddBannk_Tap(_ sender: UIButton) {
        guard validation1() else {
            return
        }
        guard validation() else {
            return
        }
        addBankViewModel.H_AddbankAcount(firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", email: self.emailTF.text ?? "", phoneNumber: self.phoneNumTF.text ?? "", idType: self.idType, ssnLast4: self.ssnLast4TF.text ?? "", idNumber: self.idNumberTF.text ?? "", address: self.addressTF.text ?? "", country: self.countryCode, state: self.stateCode, city: self.cityTF.text ?? "", postalCode: self.postalCodeTF.text ?? "", bankName: self.bankNameTF.text ?? "", accountHolderName: self.accHolderNameTF.text ?? "", accountNumber: self.accNumberTF.text ?? "", accountNumberConfirmation: self.conirmAccNumTF.text ?? "", routingNumber: self.routingnumTf.text ?? "", dob: DOBArr, bankProofType: self.selectedBankProof, bankProofDocument: BankProofDOC, verificationDocumentFront: FrontDOC, verificationDocumentBack: BackDOC)
    }
    
    @IBAction func btn_IdTypeDrop(_ sender: UIButton) {
        self.idTypeDrop.anchorView = sender
        self.idTypeDrop.direction = .bottom
        self.idTypeDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.idTypeDrop.textColor = .black
        self.idTypeDrop.separatorColor = .clear
        self.idTypeDrop.selectionBackgroundColor = .clear
        self.idTypeDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.idTypeDrop.dataSource.removeAll()
        self.idTypeDrop.cellHeight = 35
        self.idTypeDrop.dataSource = idTypeArr
        
        self.idTypeDrop.selectionAction = { [unowned self] (index, item) in
            self.idTypeTF.text = item
            if index == 0{
                self.idType = "driver_license"
            }else{
                self.idType = "passport"
            }
        }
        self.idTypeDrop.show()
    }
    
    @IBAction func btn_Country(_ sender: UIButton) {
        self.countryDrop.anchorView = sender
        self.countryDrop.direction = .bottom
        self.countryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.countryDrop.textColor = .black
        self.countryDrop.separatorColor = .clear
        self.countryDrop.selectionBackgroundColor = .clear
        self.countryDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.countryDrop.dataSource.removeAll()
        self.countryDrop.cellHeight = 35
        self.countryDrop.dataSource = countryDetails.map {$0.name ?? ""}
        
        self.countryDrop.selectionAction = { [unowned self] (index, item) in
            
            self.countryTF.text = item
            self.stateTF.text = ""
            self.cityTF.text = ""
            self.postalCodeTF.text = ""
            self.countryCode = self.countryDetails[index].iso2 ?? ""
            self.stateCode = ""
            self.cityCode = ""
            CountryStateCityVM.GetStateCityApi(countryCode: self.countryCode)
        }
        self.countryDrop.show()
    }
    
    @IBAction func btn_State(_ sender: UIButton) {
        guard cityTF.text != "" || countryTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select country first")
            return
        }
        self.stateDrop.anchorView = sender
        self.stateDrop.direction = .bottom
        self.stateDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.stateDrop.textColor = .black
        self.stateDrop.separatorColor = .clear
        self.stateDrop.selectionBackgroundColor = .clear
        self.stateDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.stateDrop.dataSource.removeAll()
        self.stateDrop.cellHeight = 35
        self.stateDrop.dataSource = arr_State_Details.map {$0.name ?? ""}
        
        self.stateDrop.selectionAction = { [unowned self] (index, item) in
            
            self.stateTF.text = item
            self.cityTF.text = ""
            self.postalCodeTF.text = ""
            //            self.stateCode = self.arr_State_Details[index].iso2 ?? ""
            self.stateCode = self.arr_State_Details[index].iso2 ?? ""
            CountryStateCityVM.GetCityApi(countryCode:self.countryCode, stateCode: self.stateCode)
            //            self.API_TO_Get_Cities(Cities: cityCode)
        }
        self.stateDrop.show()
    }
    
    @IBAction func btn_city(_ sender: UIButton) {
        
        guard countryTF.text != "" || stateTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select country first")
            return
        }
        guard stateTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select state first")
            return
        }
        
        self.cityDrop.anchorView = sender
        self.cityDrop.direction = .bottom
        self.cityDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.cityDrop.textColor = .black
        self.cityDrop.separatorColor = .clear
        self.cityDrop.selectionBackgroundColor = .clear
        self.cityDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.cityDrop.dataSource.removeAll()
        self.cityDrop.cellHeight = 35
        self.cityDrop.dataSource = arr_City_Details.map {$0.name ?? ""}
        self.cityDrop.selectionAction = { [unowned self] (index, item) in
            self.cityTF.text = item
        }
        self.cityDrop.show()
    }
    
    @IBAction func Bank_Proof_Dropdown_Btn(_ sender: UIButton) {
        self.BankProofDrop.anchorView = sender
        self.BankProofDrop.direction = .bottom
        self.BankProofDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.BankProofDrop.textColor = .black
        self.BankProofDrop.separatorColor = .clear
        self.BankProofDrop.selectionBackgroundColor = .clear
        //self.BankProofDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.BankProofDrop.dataSource.removeAll()
        self.BankProofDrop.cellHeight = 35
        self.BankProofDrop.dataSource.append(contentsOf: self.BankProofArr)
        self.BankProofDrop.selectionAction = { [unowned self] (index, item) in
            self.selctBankProofTypeTF.text = item
            if item == "Bank account statement"{
                self.selectedBankProof = "bank_statement"
            }else if item == "Voided cheque"{
                self.selectedBankProof = "voided_check"
            }else{
                self.selectedBankProof = "bank_letterhead"
            }
        }
        self.BankProofDrop.show()
    }
    
    @IBAction func Bank_Proof_Doc_Btn(_ sender: UIButton) {
        self.pickMediaFor = "BankProof"
        guard selctBankProofTypeTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select proof of bank account first")
            return
        }
        
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func frontDocumentBtn(_ sender: UIButton) {
        self.pickMediaFor = "Front"
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func backDocumentBtn(_ sender: UIButton) {
        self.pickMediaFor = "Back"
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTF {
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
        }
    }
    
    @objc func doneButtonTapped() {
        if dobTF.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dobTF.text = dateFormatter.string(from: datePicker.date)
            let dateString = dobTF.text ?? ""
            let dateComponents = dateString.split(separator: "/").map { String($0) }

            if dateComponents.count == 3 {
                let formattedDate = [dateComponents[0],dateComponents[1], dateComponents[2]]
                self.DOBArr = formattedDate
                print(formattedDate) // Output: ["3", "5", "2025"]
            }
        }
        self.view.endEditing(true)
    }
    
    func presentCamera() {
        self.showImagePicker(selectedSource: .camera)
        let imagePicker = UIImagePickerController()
        
        // set its delegate, set its source type
        imagePicker.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to capture photo in this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(selectedSource : UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource)
        else {
            return
        }
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = selectedSource
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func openDocPicker(){
        documentPicker?.displayPicker()
        documentPicker?.pickerController?.allowsMultipleSelection = false
    }
    
    func didPickDocument(document: Document?) {
        if let pickedDoc = document {
            let FileURL = pickedDoc.fileURL
            /// do what you want with the file URL
            //   print(FileURL)
            
            let name = FileURL.lastPathComponent
            let fileName = name
            let fileArray = fileName.components(separatedBy: ".")
            let firstName = fileArray.first
            let finalFileName = fileArray.last
            self.fileTypeName = finalFileName ?? ""
            
            do {
                let DataFile = try Data(contentsOf: FileURL as URL)
                
                actionProgressStart(textShort)
                ProgressHUD.colorAnimation = .systemBlue
                ProgressHUD.colorProgress = .systemBlue
                
                //                self.BankImg_CoverDotted.isHidden = true
                if self.pickMediaFor == "BankProof"{
                    self.BankProofDOC = DataFile
                    self.bankProofTF.text = fileName
                }else if self.pickMediaFor == "Front"{
                    self.FrontDOC = DataFile
                    self.frontDocTF.text = fileName
                }else if self.pickMediaFor == "Back"{
                    self.BackDOC = DataFile
                    self.backDocTF.text = fileName
                }
                //                self.BankIMG.image = UIImage(named: "pdfpng") // docs
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    // progress bar.
    func actionProgressStart(_ status: String? = nil) {
        
        timer?.invalidate()
        timer = nil
        
        var intervalCount: CGFloat = 0.0
        
        ProgressHUD.progress(status, intervalCount/100)
        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
            intervalCount += 1
            ProgressHUD.progress(status, intervalCount/100)
            if (intervalCount >= 100) {
                self.actionProgressStop()
            }
        }
    }
    
    func actionProgressStop() {
        
        timer?.invalidate()
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ProgressHUD.succeed(interaction: false)
        }
    }
    
    //MARK:-imagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage ?? UIImage()
        let selectedName = info[.imageURL] as? URL ?? URL(string: "")
        let DataFile = selectedImage.jpegData(compressionQuality: 0.5) ?? Data()
        
        //        self.BankImg_CoverDotted.isHidden = true
        if self.pickMediaFor == "BankProof"{
            self.BankProofDOC = DataFile
            self.bankProofTF.text = "\(selectedName ?? URL(fileURLWithPath: ""))"
        }else if self.pickMediaFor == "Front"{
            self.FrontDOC = DataFile
            self.frontDocTF.text = "\(selectedName ?? URL(fileURLWithPath: ""))"
        }else if self.pickMediaFor == "Back"{
            self.BackDOC = DataFile
            self.backDocTF.text = "\(selectedName ?? URL(fileURLWithPath: ""))"
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddBankVC {
    
    func validation() -> Bool {
        
        if accHolderNameTF.text?.count == 0 && routingnumTf.text?.count == 0 && accNumberTF.text?.count == 0 && conirmAccNumTF.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmptyField)
            return false
        }
        
        
        if self.accHolderNameTF.text == "" || accHolderNameTF.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAccountName)
            return false
        }
        
        if self.routingnumTf.text == " " || routingnumTf.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mRoutingNumber)
            return false
        }
        
        if routingnumTf.text!.count < 9  {
            self.AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mValidRoutingNumber)
            return false
        }
        
        if self.accNumberTF.text == " " || accNumberTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBankAccount)
            return false
        }
        
        if self.conirmAccNumTF.text == " " || conirmAccNumTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mConfirmBankAccount)
            return false
        }
        if accNumberTF.text != conirmAccNumTF.text {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAccountmatch)
            return false
        }
        
        if self.bankProofTF.text == " "{
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mProofofbank)
            return false
        }
        
        if self.bankProofTF.text == ""  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBankProofDoc)
            return false
        }
        
        if self.frontDocTF.text == ""  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFrontID)
            return false
        }
        
        if self.backDocTF.text == ""  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBackID)
            return false
        }
        return true
    }
    
    
    func validation1() -> Bool {
        
        if firstNameTF.text?.count == 0 && lastNameTF.text?.count == 0 && emailTF.text?.count == 0 && phoneNumTF.text?.count == 0 && dobTF.text?.count == 0 &&  addressTF.text?.count == 0 && countryTF.text?.count == 0 && stateTF.text?.count == 0 && cityTF.text?.count == 0 && postalCodeTF.text?.count == 0{
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmptyField)
            return false
        }
        
        
        if self.firstNameTF.text == " " || firstNameTF.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFirstName)
            return false
        }
        
        if self.lastNameTF.text == " " || lastNameTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mLastName)
            return false
        }
        
        if self.emailTF.text == " " || emailTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmail)
            return false
        }
        
        if self.emailTF.text!.contains("@")  {
            if !self.isValidEmail(testStr: self.emailTF.text!) {
                AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mValidEmail)
                return false
            }
        }
        
        if self.phoneNumTF.text == " " || phoneNumTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPhoneNumber)
            return false
        }
        
        if self.dobTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mDob)
            return false
        }
        
//        if self.txt_PIN.text == " " || txt_PIN.text?.count == 0  {
//            
//            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPIN)
//            return false
//        }
//        if self.txt_SSN.text == " " || txt_SSN.text?.count == 0  {
//            
//            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPIN)
//            return false
//        }
        
        
        if self.addressTF.text == " " || addressTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAddress)
            return false
        }
        
 
        
        if self.stateTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mState)
            return false
        }
        
        if self.cityTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mCity)
            return false
        }
        
        if self.postalCodeTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPostalCode)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  accHolderNameTF {
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        } else if textField ==  firstNameTF && textField ==  lastNameTF{
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        }
        if textField == phoneNumTF {
            let currentText = phoneNumTF.text ?? ""
            // Create the updated text after replacement
            guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
            // Allow only numbers and a maximum of 10 digits
            let isNumeric = updatedText.allSatisfy { $0.isNumber }
           // return isNumeric && updatedText.count <= 10
            return isNumeric && updatedText.count <= 15
            //return isNumeric && updatedText.count <= 9 || updatedText.count <= 10 || updatedText.count <= 11
        }
        
//        else if textField == phoneNumTF{
//            guard let text = self.phoneNumTF.text else { return false }
//            let newString = (text as NSString).replacingCharacters(in: range, with: string)
//            
//            self.phoneNumTF.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
//            return false
//        }
        
        return true
    }
}

extension AddBankVC {
    func bindVC(){
        CountryStateCityVM.$getCountryStateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.countryDetails.removeAll()
                    self.countryDetails = response.data ?? []
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_State(){
        CountryStateCityVM.$getStateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        self.arr_State_Details.removeAll()
                        self.arr_State_Details = response.data ?? []
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_City(){
        CountryStateCityVM.$getCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        self.arr_City_Details.removeAll()
                        self.arr_City_Details = response.data ?? []
                    }
                })
            }.store(in: &cancellables)
    }
    
    
    func bindVC_AddBank(){
        addBankViewModel.$addBankDetailResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        if response.success == true{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }.store(in: &cancellables)
    }
}


extension AddBankVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
       // self.countryCode = code
        countryCodeTF.text = "\(flag) (\(code))"
        self.PhoneCountryCode = "\(code)"
        if (phoneNumTF.text ?? "") != "" {
            let phoneNumber = (phoneNumTF.text ?? "")
           // let isValid =  validator.isValidMobileNumber(countryCode: self.PhoneCountryCode, number: "\(self.PhoneCountryCode)\(phoneNumber)")
            let isValid = validator.isValidMobileNumber(
                countryCode: self.PhoneCountryCode,
                number: phoneNumber
            )
            print("Is valid: \(isValid)")
            if isValid != true {
                self.showAlert(for: "Please enter valid phone number")
                self.phoneNumTF.text = ""
            }
        }
    }
}

