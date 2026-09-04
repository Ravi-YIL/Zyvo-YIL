//
//  AddCardVC.swift
//  Zyvo
//
//  Created by ravi on 28/11/24.
//

import UIKit
import Stripe
import DropDown
import Combine
import GooglePlaces

class AddCardVC: UIViewController, GMSAutocompleteFetcherDelegate {
    
    
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
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zipcode: UIView!
    
    @IBOutlet weak var view_month: UIView!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_card: UIView!
    
    @IBOutlet weak var view_year: UIView!
    
    @IBOutlet weak var txt_CVV: UITextField!
    @IBOutlet weak var txt_Year: UITextField!
    
    @IBOutlet weak var txt_Month: UITextField!
    
    @IBOutlet weak var view_CVV: UIView!
    
    @IBOutlet weak var txt_street: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_zipcode: UITextField!
    @IBOutlet weak var txt_card: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    var iconChecked = false
    var combined = ""
    var month = ""
    var year = ""
    let arrMonth = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    let currentYear = Calendar.current.component(.year, from: Date())
    var years: [String] = []
    
    let monthDropdown = DropDown()
    
    let yearDropdown = DropDown()
    
    private var viewModel = MailingAddressViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getSavedAddress : MailingAddressModel?
    
    var backAction: () -> () = {}
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    let dropDownLocation = DropDown()
    
    var isAddressSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
     //   )
        
        
        // Initialize Google Autocomplete Fetcher
              let filter = GMSAutocompleteFilter()
              filter.type = .noFilter // You can change this to .address, .establishment, etc.
              
              fetcher = GMSAutocompleteFetcher(filter: filter)
              fetcher.delegate = self
              self.txt_street.delegate = self
        
        txt_street.addTarget(
            self,
            action: #selector(streetTextChanged(_:)),
            for: .editingChanged
        )
        
        txt_CVV.addTarget(
            self,
            action: #selector(cvvChanged(_:)),
            for: .editingChanged
        )
        
        bindVC()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        years = (currentYear...currentYear+100).map { "\($0)" }
        
        self.txt_name.delegate = self
        self.txt_card.delegate = self
        self.txt_CVV.delegate = self
        self.txt_street.delegate = self
        
        
        let tap = UITapGestureRecognizer(
             target: self,
             action: #selector(dismissKeyboard)
         )
         
         tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)
        
        
        if let poppinsFont = UIFont(name: "Poppins-Regular", size: 14) {
            txt_name.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Name",placeholderColor: .black)
            txt_card.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Card Number",placeholderColor: .black)
            txt_street.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Street",placeholderColor: .black)
            
            txt_Month.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Month",placeholderColor: .black)
            
            txt_Year.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Year",placeholderColor: .black)
            
            txt_CVV.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "CVV",placeholderColor: .black)
            
            txt_city.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "City",placeholderColor: .black)
            txt_state.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "State",placeholderColor: .black)
            txt_zipcode.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Zipcode",placeholderColor: .black)
        }
        
        btnSubmit.layer.cornerRadius = btnSubmit.layer.frame.height / 2
        view_Zipcode.layer.cornerRadius = view_Zipcode.layer.frame.height / 2
        view_Zipcode.layer.borderWidth = 1.5
        view_Zipcode.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_State.layer.cornerRadius = view_State.layer.frame.height / 2
        view_State.layer.borderWidth = 1.5
        view_State.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_City.layer.cornerRadius = view_City.layer.frame.height / 2
        view_City.layer.borderWidth = 1.5
        view_City.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Street.layer.cornerRadius = view_Street.layer.frame.height / 2
        view_Street.layer.borderWidth = 1.5
        view_Street.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_year.layer.cornerRadius = view_year.layer.frame.height / 2
        view_year.layer.borderWidth = 1.5
        view_year.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_month.layer.cornerRadius = view_month.layer.frame.height / 2
        view_month.layer.borderWidth = 1.5
        view_month.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_CVV.layer.cornerRadius = view_CVV.layer.frame.height / 2
        view_CVV.layer.borderWidth = 1.5
        view_CVV.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_name.layer.cornerRadius = view_name.layer.frame.height / 2
        view_name.layer.borderWidth = 1.5
        view_name.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_card.layer.cornerRadius = view_card.layer.frame.height / 2
        view_card.layer.borderWidth = 1.5
        view_card.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        setupDropDown()
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func cvvChanged(_ textField: UITextField) {
        if (textField.text ?? "").count == 3 {
            textField.resignFirstResponder()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {

        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    
    @objc func streetTextChanged(_ textField: UITextField) {

        if isAddressSelected {
            return
        }

        guard let text = textField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {

            dropDownLocation.hide()
            return
        }

        fetcher?.sourceTextHasChanged(text)
    }
    func setupDropDown() {

        dropDownLocation.anchorView = txt_street
        dropDownLocation.direction = .top
        dropDownLocation.topOffset = CGPoint(x: 0, y: txt_street.bounds.height - 60)

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

            self.isAddressSelected = true

            let prediction = self.predictions[index]

            GMSPlacesClient.shared().fetchPlace(
                fromPlaceID: prediction.placeID,
                placeFields: [.formattedAddress, .addressComponents, .coordinate, .name],
                sessionToken: nil
            ) { place, error in

                guard let place = place else { return }

                self.fillAddressFields(from: place)

                self.dropDownLocation.hide()
                self.txt_street.resignFirstResponder()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isAddressSelected = false
                }
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
        txt_street.text = !street.isEmpty
            ? street
            : (place.name ?? place.formattedAddress ?? "")

        txt_city.text = city
        txt_state.text = state
        txt_zipcode.text = zip

        print("Street:", txt_street.text ?? "")
        print("City:", city)
        print("State:", state)
        print("Zip:", zip)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_name {
            textField.resignFirstResponder()
            txt_card.becomeFirstResponder()
        } else if textField == txt_card {
            textField.resignFirstResponder()
            
        }else if textField == txt_CVV {
            textField.resignFirstResponder()
        }
        
        // callFunc()
        return true
    }
    
    
    @IBAction func btnMonth_Tap(_ sender: UIButton) {
        self.month = ""
        // Set up the dropdown
        monthDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        monthDropdown.dataSource = arrMonth
        monthDropdown.direction = .bottom
        
        monthDropdown.bottomOffset = CGPoint(x: 3, y:(monthDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        monthDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected Index: \(index)")
            print("Selected Month: \(item)")
            
            self?.txt_Month.text = "\(item)"
            self?.month = String(format: "%02d", index + 1)
            self?.combined = "\(self?.month ?? "")/\(self?.year ?? "")"
            print(self?.combined ?? "","numberOnly")
            
        }
        monthDropdown.show()
    }
    @IBAction func btnYear_Tap(_ sender: UIButton) {
        // Set up the dropdown
        self.year = ""
        yearDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        yearDropdown.dataSource = years
        yearDropdown.direction = .bottom
        
        yearDropdown.bottomOffset = CGPoint(x: 3, y:(yearDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        yearDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected Year: \(item)")
            self?.txt_Year.text = "\(item)"
            self?.year = "\(item)"
            self?.combined = "\(self?.month ?? "")/\(self?.year ?? "")"
            let text = "\(item)"
            print(self?.combined ?? "","numberOnly")
        }
        yearDropdown.show()
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        
        if txt_name.text == "" {
            self.popupAlert(title: "", message: "Please enter Card Holder Name!", actionTitles: ["Okay!"], actions:[{action1 in}])
            /// return false
        }
        else if txt_card.text?.count == 0  {
            
            self.popupAlert(title: "", message: "Please enter Card Number!", actionTitles: ["Okay!"], actions:[{action1 in}])
            //return false
        } else if txt_card.text?.count == 16 {
            self.popupAlert(title: "", message: "Please enter Correct Card Number!", actionTitles: ["Okay!"], actions:[{action1 in}])
            //return false
        }
        else if txt_Month.text?.count == 0 {
            self.popupAlert(title: "", message: "Please select month!", actionTitles: ["Okay!"], actions: [{ _ in }])
            return
        } else if txt_Year.text?.count == 0 {
            self.popupAlert(title: "", message: "Please select year!", actionTitles: ["Okay!"], actions: [{ _ in }])
            return
        }
        else if txt_CVV.text?.count != 3 {
            self.popupAlert(title: "", message: "Please enter CVV Code", actionTitles: ["Okay!"], actions:[{action1 in}])
            // return false
        } else if txt_street.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter street", actionTitles: ["Okay!"], actions:[{action1 in}])
            // return false
        } else if txt_city.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter city", actionTitles: ["Okay!"], actions:[{action1 in}])
            // return false
        } else if txt_state.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter state", actionTitles: ["Okay!"], actions:[{action1 in}])
            // return false
        }else if txt_zipcode.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter zip", actionTitles: ["Okay!"], actions:[{action1 in}])
            // return false
        } else {
            callFunc()
        }
        //        self.dismiss(animated: true)
        //        self.backAction()
    }
    
    @IBAction func btnCheck_Tap(_ sender: UIButton) {
        if iconChecked == false {
            iconChecked = true
            viewModel.apiForGetSavedAddress()
            btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
        } else {
            iconChecked = false
            btnCheck.setImage(UIImage(named: "uncheckedicon"), for: .normal)
            self.txt_street.text = "Street"
            self.txt_city.text = "City"
            self.txt_state.text = "State"
            self.txt_zipcode.text = "Zipcode"
        }
    }
    
    func callFunc() {
        // self.addCardBtn.isUserInteractionEnabled = false
        let cardParams = STPCardParams()
        //         cardParams.number = "4242424242424242"
        //         cardParams.expMonth = 10
        //         cardParams.expYear = 2026
        //         cardParams.cvc = "123"
        
        // let fullName = combined
        // let fullNameArr = fullName.components(separatedBy: "/")
        cardParams.name = txt_name.text
        cardParams.number = txt_card.text
        cardParams.expMonth = UInt(self.month)!
        cardParams.expYear = UInt(self.year)!
        cardParams.cvc = txt_CVV.text
        cardParams.addressZip = self.txt_zipcode.text
        cardParams.addressCity = self.txt_state.text
        cardParams.addressState = self.txt_state.text
        cardParams.addressLine1 = self.txt_street.text
        
        print(cardParams,"cardParams")
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token111 = token, error == nil else {
                // Present error to user...
                let UserInfo = error.unsafelyUnwrapped.localizedDescription
                self.showAlert(for: UserInfo)
                return
            }
            
            print(token111.tokenId as Any,"token id")
            
            self.viewModel.apiForAddCard(tokenStripe: "\(token111.tokenId as Any)")
            
        }
    }
}

extension UITextField {
    func setCustomFontAndPlaceholder(
        textFont: UIFont,
        placeholderText: String,
        placeholderColor: UIColor
    ) {
        self.font = textFont
        self.textColor = .black // Optional
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: textFont
            ]
        )
    }
}

extension UILabel {
    func setCustomFontAndText(text: String, font: UIFont, textColor: UIColor) {
        self.font = font
        self.text = text
        self.textColor = textColor
    }
}

extension AddCardVC {
    func bindVC() {
        viewModel.$getSavedAddress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getSavedAddress = response.data
                    print(self.getSavedAddress ?? "","Saved Address")
                    print(self.getSavedAddress?.streetAddress ?? "")
                    print(self.getSavedAddress?.city ?? "")
                    print(self.getSavedAddress?.state ?? "")
                    print(self.getSavedAddress?.zipCode ?? "")
                    self.txt_street.text = self.getSavedAddress?.streetAddress ?? ""
                    self.txt_city.text = self.getSavedAddress?.city ?? ""
                    self.txt_state.text = self.getSavedAddress?.state ?? ""
                    self.txt_zipcode.text = self.getSavedAddress?.zipCode ?? ""
                })
            }.store(in: &cancellables)
        
        
        //Add CARD
        viewModel.$addCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        if response.success == true{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.dismiss(animated: true) {
                                    self.backAction()
                                }
                            }
                        }
                    }
                })
            }.store(in: &cancellables)
    }
}

extension AddCardVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == txt_street {

            if isAddressSelected {
                return true
            }

            let currentText = textField.text ?? ""

            guard let stringRange = Range(range, in: currentText) else {
                return true
            }

            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            fetcher?.sourceTextHasChanged(updatedText)

            return true
        }

        else   if textField == txt_name {
            if range.location == 30 {
                return false
            }
        }
        if textField == txt_card {
            if range.location == 19 {
                return false
            }
            if string.count == 0 {
                return true
            }
            if !self.pavan_checkNumberOrAlphabet(Str: string) || string == " " {
                return false
            }
            if (range.location == 4) || (range.location == 9) || (range.location == 14) {  let str = "\(textField.text!) "
                textField.text = str
            }
            return true
        }
        if textField == txt_CVV {
            if range.location == 3 {
                return false
            }
            if string.count == 0 {
                return true
            }
            if !self.pavan_checkNumberOrAlphabet(Str: string) || string == " " {
                return false
            }
            return true
        }
        
        if textField == txt_name {
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
        //callFunc()
        return true
    }
   
    func isValidExpiryDate(_ text: String) -> Bool {
        let components = text.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]) else { return false }
        // Valid MM range
        guard (1...12).contains(month) else { return false }
        // Current date
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date()) % 100 // get last 2 digits
        let currentMonth = calendar.component(.month, from: Date())
        if year < currentYear {
            return false
        } else if year == currentYear {
            return month >= currentMonth
        } else {
            return true
        }
    }
}
