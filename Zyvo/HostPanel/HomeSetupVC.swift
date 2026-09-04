//
//  HomeSetupVC.swift
//  Zyvo
//
//  Created by ravi on 31/12/24.
//

import UIKit
import DropDown
class HomeSetupVC: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var view_BedroomData: UIView!
    @IBOutlet weak var view_BedroomTitle: UIView!
    @IBOutlet weak var btnPeople: UIButton!
    
    @IBOutlet weak var btnProperty: UIButton!
    
    @IBOutlet weak var btnBedroom: UIButton!
    
    @IBOutlet weak var btnBathroom: UIButton!
    
    @IBOutlet weak var viewCancelReason: UIView!
    @IBOutlet weak var lbl_availibility: UILabel!
    @IBOutlet weak var lbl_typeofSpace: UILabel!
    @IBOutlet weak var lbl_Activity: UILabel!
    
    @IBOutlet weak var lbl_Cancellation: UILabel!
    
    @IBOutlet weak var lbl_instantBooking: UILabel!
    
    @IBOutlet weak var lbl_selfCheckIn: UILabel!
    
    @IBOutlet weak var lbl_allowPets: UILabel!
    @IBOutlet weak var lbl_booking: UILabel!
    @IBOutlet weak var lbl_amenties: UILabel!
    @IBOutlet weak var lbl_otherActivity: UIButton!
    @IBOutlet weak var btnAnyType: UIButton!
    @IBOutlet weak var btnRoom: UIButton!
    
    @IBOutlet weak var mainStackV: UIStackView!
    @IBOutlet weak var collecV_Activites: UICollectionView!
    @IBOutlet weak var collecV_OtherActivites: UICollectionView!
    
    @IBOutlet weak var view_allowPets: UIView!
    @IBOutlet weak var view_cancelReason: UIView!
    @IBOutlet weak var collecV_OtherActivitesHConstant: NSLayoutConstraint!
    @IBOutlet weak var collecV_AmentiesHConstant: NSLayoutConstraint!
    
    @IBOutlet weak var collecV_Amenties: UICollectionView!
    
    @IBOutlet weak var propertySizeTF: UITextField!
    @IBOutlet weak var noOfPplTF: UITextField!
    @IBOutlet weak var bedroomsTF: UITextField!
    @IBOutlet weak var bathroomsTF: UITextField!
    @IBOutlet weak var view_OtherActivity: UIView!
    @IBOutlet weak var otherActivityDropImg: UIImageView!
    var viewStatus = ""
    
    @IBOutlet weak var lbl_cancelReason: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnAllowInstantBooking: UIButton!
    @IBOutlet weak var btnSelfCheckIn: UIButton!
    @IBOutlet weak var btnallowPets: UIButton!
    let currentYear = Calendar.current.component(.year, from: Date())
    @IBOutlet var buttonCollection: [UIButton]!  // Connect all 8 buttons
    @IBOutlet var NoPeopleBtnColl: [UIButton]!  // Connect all 8 buttons
    @IBOutlet var bedroomsBtnColl: [UIButton]!
    @IBOutlet var bathRoomesBtnColl: [UIButton]!
    var previouslySelectedButton: UIButton?
    var prevSelNo_PplBtn: UIButton?
    var prevSelBedroomBtn: UIButton?
    var prevSelBathroomButton: UIButton?
    var arrSelectedLanguage :[String] = []
    var arrSelectedAmenties :[String] = []
    var arrSelectedActivity :[String] = []
    var arrSelectedOtherActivity :[String] = []
    
    let Times = ["30 minutes","1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var arrActivityImg = ["home22","staricon 1","cameraicon 1","cameraicon 2"]
    
    var arrActivityTitle = ["Stays","Event Space","Photo shoot","Meeting"]

    
    let arrAmentiesTitle: [String] = [
        "Free Parking",
        "Meal Included",
        "Elevator/Lift Access",
        "Wheelchair Accessible",
        "Smoking Allowed",
        "Non-Smoking Property",
        "Security Cameras",
        "Concierge Service",
        "Airport Shuttle Service",
        "Bike Rental",
        "Business Centre",
        "Conference/Meeting Facilities",
        "Spa/Wellness Centre",
        "Outdoor Space (Garden, Terrace)",
        "BBQ/Grill Area",
        "Games Room",
        "Ski-In/Ski-Out Access",
        "Waterfront Property",
        "Scenic Views",
        "Eco-Friendly/Green Certified",
        "Smart Home Technology",
        "Electric Vehicle Charging Station",
        "Yoga/Meditation Space",
        "On-Site Restaurant/Cafe",
        "Bar/Lounge Area",
        "Live Entertainment",
        "Pet Amenities (Pet Sitting, Pet Spa)",
        "Sports Facilities (Tennis Court, Golf Course)",
        "Cultural Experiences/Workshops",
        "Coffee/Tea Station"
    ]
    //
    var isShowMore: String = "no"
    var isShowMoreLanguage: String = "no"
    
    var arrOtherActivityTitle = ["Party","Film Shoot","Performance","Workshop","Corporate Event","Wedding","Dinner","Retreat","Pop-up","Networking","Fitness Class","Audio Recording","Pool"]
    
    var languages: [String] = ["English","Spanish","French","German"]
    var cancelReasonArr: [String] = ["24 Hrs","3 Days","7 Days","15 Days","30 Days"]
    let monthDropdown = DropDown()
    let yearDropdown = DropDown()
    let timeDropdown = DropDown()
    let cancelReasonDropdown = DropDown()
    var backAction: () -> () = {}
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBedroomViews()
        
        propertySizeTF.delegate = self
        noOfPplTF.delegate = self
        bedroomsTF.delegate = self
        bedroomsTF.delegate = self
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        view_OtherActivity.isHidden = true
        
        lbl_typeofSpace.font = UIFont(name: "Poppins", size: 15)!
      
//        lbl_availibility.font = UIFont(name: "Poppins", size: 15)!
//        lbl_Activity.font = UIFont(name: "Poppins", size: 15)!
        
        lbl_selfCheckIn.font = UIFont(name: "Poppins", size: 13)!
        
        lbl_instantBooking.font = UIFont(name: "Poppins", size: 13)!
       
        lbl_Cancellation.font = UIFont(name: "Poppins", size: 13)!
        lbl_allowPets.font = UIFont(name: "Poppins", size: 13)!

        lbl_cancelReason.font = UIFont(name: "Poppins", size: 16)!

        print(arrAmentiesTitle.count,"arrAmentiesTitle.count")
        
        let nib2 = UINib(nibName: "ActivityCell", bundle: nil)
        collecV_Activites?.register(nib2, forCellWithReuseIdentifier: "ActivityCell")
        collecV_Activites.delegate = self
        collecV_Activites.dataSource = self
        
        collecV_OtherActivites?.register(nib2, forCellWithReuseIdentifier: "ActivityCell")
        collecV_OtherActivites.delegate = self
        collecV_OtherActivites.dataSource = self
        
        let nib3 = UINib(nibName: "AmentiesCell", bundle: nil)
        collecV_Amenties?.register(nib3, forCellWithReuseIdentifier: "AmentiesCell")
        collecV_Amenties.delegate = self
        collecV_Amenties.dataSource = self
        
        viewCancelReason.layer.cornerRadius = viewCancelReason.layer.frame.height / 2
        viewCancelReason.layer.borderWidth = 1
        viewCancelReason.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
        // Set the first button as selected by default
        if let firstButton = buttonCollection.first {
            firstButton.backgroundColor = .white
            previouslySelectedButton = firstButton
        }
        if let firstButton = NoPeopleBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelNo_PplBtn = firstButton
        }
        if let firstButton = bedroomsBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelBedroomBtn = firstButton
        }
        if let firstButton = bathRoomesBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelBathroomButton = firstButton
        }
        
        self.propertySizeTF.delegate = self
        self.noOfPplTF.delegate = self
        self.bedroomsTF.delegate = self
        self.bathroomsTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("NotificationForEdit"), object: nil)
    }
    
    func updateBedroomViews() {
        let shouldShow = arrSelectedActivity.contains("Stays")

        view_BedroomData.isHidden = !shouldShow
        view_BedroomTitle.isHidden = !shouldShow
    }
    
    @objc func handleNotification(_ notification: Notification) {
        self.updatePropertyDetails()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == propertySizeTF{
            previouslySelectedButton?.backgroundColor = .clear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == noOfPplTF{
            prevSelNo_PplBtn?.backgroundColor = .clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == bedroomsTF{
            prevSelBedroomBtn?.backgroundColor = .clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == bathroomsTF{
            prevSelBathroomButton?.backgroundColor = .clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == propertySizeTF{
            if self.propertySizeTF.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.propertySize = propertySizeTF.text ?? ""
            }
        }else if textField == noOfPplTF{
            if self.noOfPplTF.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.no_Of_Ppl = noOfPplTF.text ?? ""
            }
            
        }else if textField == bedroomsTF{
            if self.bedroomsTF.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.bedrooms = bedroomsTF.text ?? ""
            }
            
        }else if textField == bathroomsTF{
            if self.bathroomsTF.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.bathrooms = bathroomsTF.text ?? ""
            }
        }
    }
    
    
    @IBAction func btnPeople_Tapped(_ sender: UIButton) {
        
        if noOfPplTF.isUserInteractionEnabled {

            guard let text = noOfPplTF.text, !text.isEmpty else { return }

            noOfPplTF.resignFirstResponder()
            noOfPplTF.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            noOfPplTF.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.noOfPplTF.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
    
    @IBAction func btnProperty_Tapped(_ sender: UIButton) {
        
        if propertySizeTF.isUserInteractionEnabled {

            guard let text = propertySizeTF.text, !text.isEmpty else { return }

            propertySizeTF.resignFirstResponder()
            propertySizeTF.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            propertySizeTF.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.propertySizeTF.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }

    @IBAction func btnBedroom_Tapped(_ sender: UIButton) {
        
        
        if bedroomsTF.isUserInteractionEnabled {

            guard let text = bedroomsTF.text, !text.isEmpty else { return }

            bedroomsTF.resignFirstResponder()
            bedroomsTF.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            bedroomsTF.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.bedroomsTF.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
    
    @IBAction func btnBathroom_Tapped(_ sender: UIButton) {
        
        if bathroomsTF.isUserInteractionEnabled {

            guard let text = bathroomsTF.text, !text.isEmpty else { return }

            bathroomsTF.resignFirstResponder()
            bathroomsTF.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            bathroomsTF.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.bathroomsTF.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
   
    

    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // updateCollectionViewHeight()
        
        collecV_OtherActivitesHConstant.constant = collecV_OtherActivites.contentSize.height
        collecV_AmentiesHConstant.constant = collecV_Amenties.contentSize.height
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.propertySizeTF.text = ""
        self.propertySizeTF.resignFirstResponder()
       
        // Set the previous button's background to clear
        previouslySelectedButton?.backgroundColor = .clear
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        previouslySelectedButton = sender
        SingltonClass.shared.propertySize = sender.title(for: .selected) ?? ""
    }
    
    @IBAction func noOf_PplBtns(_ sender: UIButton) {
        self.noOfPplTF.text = ""
        // Set the previous button's background to clear
        prevSelNo_PplBtn?.backgroundColor = .clear
        
        self.noOfPplTF.resignFirstResponder()
        self.noOfPplTF.text = ""
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        prevSelNo_PplBtn = sender
        SingltonClass.shared.no_Of_Ppl = sender.title(for: .selected) ?? ""
    }
    
    @IBAction func bedroom_Btns(_ sender: UIButton) {
        self.bedroomsTF.text = ""
        // Set the previous button's background to clear
        prevSelBedroomBtn?.backgroundColor = .clear
        
        self.bedroomsTF.resignFirstResponder()
        self.bedroomsTF.text = ""
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        prevSelBedroomBtn = sender
        SingltonClass.shared.bedrooms = sender.title(for: .selected) ?? ""
    }
    
    @IBAction func bathroom_Btns(_ sender: UIButton) {
       
        // Set the previous button's background to clear
        prevSelBathroomButton?.backgroundColor = .clear
        
        self.bathroomsTF.resignFirstResponder()
        self.bathroomsTF.text = ""
        
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        prevSelBathroomButton = sender
        SingltonClass.shared.bathrooms = sender.title(for: .selected) ?? ""
    }
    
    private func updateCollectionViewHeight() {
        // Calculate the number of rows needed
        let numberOfItems = collectionView(collecV_OtherActivites, numberOfItemsInSection: 0)
        let itemsPerRow: CGFloat = 4
        let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        
        // Set the item height and spacing
        let itemHeight: CGFloat = 90
        let padding: CGFloat = 10
        let totalPadding = (rows - 1) * padding
        let totalHeight = rows * itemHeight + totalPadding
        
        // Update the collection view height constraint
        collecV_OtherActivitesHConstant.constant = totalHeight
        
//        // Calculate the number of rows needed
//        let numberOfItems1 = collectionView(collecV_Amenties, numberOfItemsInSection: 0)
//        let itemsPerRow1: CGFloat = 2
//        let rows1 = ceil(CGFloat(numberOfItems1) / itemsPerRow1)
//        
//        // Set the item height and spacing
//        let itemHeight1: CGFloat = 51
//        let padding1: CGFloat = 10
//        let totalPadding1 = (rows1 - 1) * padding1
//        let totalHeight1 = rows1 * itemHeight1 + totalPadding1
//        // Update the collection view height constraint
//        collecV_AmentiesHConstant.constant = totalHeight1
        
        // Calculate the number of rows needed
        let numberOfItems1 = collectionView(collecV_Amenties, numberOfItemsInSection: 0)
        let itemsPerRow1: CGFloat = 2
        let rows1 = ceil(CGFloat(numberOfItems1) / itemsPerRow1)
        
        // Set the item height and spacing
        let itemHeight1: CGFloat = 41
        let padding1: CGFloat = 10
        let totalPadding1 = (rows1 - 1) * padding1
        let totalHeight1 = rows1 * itemHeight1 + totalPadding1
        // Update the collection view height constraint
        collecV_AmentiesHConstant.constant = totalHeight1
    }
    
    @IBAction func btnInstantBooking_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            btnAllowInstantBooking.setImage(UIImage(named: "selecticon"), for: .normal)
            SingltonClass.shared.instantBooking = "1"
        } else {
            sender.isSelected = false
            btnAllowInstantBooking.setImage(UIImage(named: "Deselecticon"), for: .normal)
            SingltonClass.shared.instantBooking = "0"
        }
    }
    
    @IBAction func btnSelfCheckIn_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            btnSelfCheckIn.setImage(UIImage(named: "selecticon"), for: .normal)
            SingltonClass.shared.selfCheck_in = "1"
        } else {
            sender.isSelected = false
            btnSelfCheckIn.setImage(UIImage(named: "Deselecticon"), for: .normal)
            SingltonClass.shared.selfCheck_in = "0"
        }
    }
    
    @IBAction func btnAllowPets_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            btnallowPets.setImage(UIImage(named: "selecticon"), for: .normal)
            SingltonClass.shared.allowPets = "1"
        } else {
            sender.isSelected = false
            btnallowPets.setImage(UIImage(named: "Deselecticon"), for: .normal)
            SingltonClass.shared.allowPets = "0"
        }
    }
    
    @IBAction func btnOtherActivity_Tap(_ sender: UIButton) {
        //        self.view_OtherActivity.isHidden = false
        if sender.isSelected == false{
            sender.isSelected = true
            self.view_OtherActivity.isHidden = false
            self.otherActivityDropImg.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            self.view_OtherActivity.isHidden = true
            self.otherActivityDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func btnSeeMore_Tap(_ sender: UIButton) {
        isExpanded.toggle() // Toggle the state
        sender.setTitle(isExpanded ? "Show Less" : "Show More", for: .normal)
        collecV_Amenties.reloadData()
    }
    
    @IBAction func btnSelectCancelReason_Tap(_ sender: UIButton) {
        // Set up the dropdown
        cancelReasonDropdown.anchorView = sender // Anchor dropdown to the button
        cancelReasonDropdown.dataSource = cancelReasonArr
        cancelReasonDropdown.direction = .any
        
        cancelReasonDropdown.backgroundColor = UIColor.white
        cancelReasonDropdown.cornerRadius = 10
        cancelReasonDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        cancelReasonDropdown.layer.shadowColor = UIColor.gray.cgColor
        cancelReasonDropdown.layer.shadowOpacity = 0.2
        cancelReasonDropdown.layer.shadowRadius = 10
        cancelReasonDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = cancelReasonDropdown.anchorView?.plainView.bounds.height {
            cancelReasonDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        cancelReasonDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        cancelReasonDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            self.lbl_cancelReason.text = "\(item)"
            if index == 0{
                SingltonClass.shared.cancellationDays = "24"
            }else if index == 1{
                SingltonClass.shared.cancellationDays = "72"
            }else if index == 2{
                SingltonClass.shared.cancellationDays = "168"
            }else if index == 3{
                SingltonClass.shared.cancellationDays = "360"
            }else{
                SingltonClass.shared.cancellationDays = "720"
            }
            // Perform any further actions as needed
        }
        // Show dropdown
        cancelReasonDropdown.show()
        
    }
    
    @IBAction func btnInfo_Tap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Your safety and peace of mind are our top priorities. ZYVO is proud to provide comprehensive liability insurance coverage for all bookings"
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .any // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 240, height: 80)
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnInfoCancel_Tap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Guest can cancel within selected time frame before confirmed booking time (only ONE selection can be made)"
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .any // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 240, height: 80)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func btnAnyType_Tap(_ sender: UIButton) {
        btnAnyType.backgroundColor = UIColor.white
        btnRoom.backgroundColor = UIColor.clear
        SingltonClass.shared.typeOfSpace = "entire_home"
        // btnEntireRoom.backgroundColor = UIColor.clear
    }
    @IBAction func btnRoom_Tap(_ sender: UIButton) {
        btnRoom.backgroundColor = UIColor.white
        btnAnyType.backgroundColor = UIColor.clear
        SingltonClass.shared.typeOfSpace = "private_room"
        
    }
    
    
    func updatePropertyDetails(){
        if SingltonClass.shared.typeOfSpace == "private_room"{
            btnRoom.backgroundColor = UIColor.white
            btnAnyType.backgroundColor = UIColor.clear
        }
        
        var isSizeMatched = false
        if SingltonClass.shared.propertySize == "0"{
            SingltonClass.shared.propertySize = "Any"
            isSizeMatched = true
        }
        for button in buttonCollection { // Assuming buttonCollection is an array of your buttons
            if button.title(for: .selected) == SingltonClass.shared.propertySize {
                button.backgroundColor = .white
                previouslySelectedButton = button
                isSizeMatched = true
            } else {
                button.backgroundColor = .clear
            }
        }
        if !isSizeMatched {
            self.propertySizeTF.text = SingltonClass.shared.propertySize
        }
        
        var isNoOfPplMatched = false
        if SingltonClass.shared.no_Of_Ppl == "0"{
            SingltonClass.shared.no_Of_Ppl = "Any"
            isNoOfPplMatched = true
        }
        for button in NoPeopleBtnColl { // Assuming buttonCollection is an array of your buttons
            if button.title(for: .selected) == SingltonClass.shared.no_Of_Ppl {
                button.backgroundColor = .white
                prevSelNo_PplBtn = button
                isNoOfPplMatched = true
            } else {
                button.backgroundColor = .clear
            }
        }
        if !isNoOfPplMatched {
            self.noOfPplTF.text = SingltonClass.shared.no_Of_Ppl
        }
        
        var isBedroom = false
        if SingltonClass.shared.bedrooms == "0"{
            SingltonClass.shared.bedrooms = "Any"
            isBedroom = true
        }
        
        for button in bedroomsBtnColl { // Assuming buttonCollection is an array of your buttons
            if button.title(for: .selected) == SingltonClass.shared.bedrooms {
                button.backgroundColor = .white
                prevSelBedroomBtn = button
                isBedroom = true
            } else {
                button.backgroundColor = .clear
            }
        }
        if !isBedroom {
            self.bedroomsTF.text = SingltonClass.shared.bedrooms
        }
        
        var isBathroom = false
        if SingltonClass.shared.bathrooms == "0"{
            SingltonClass.shared.bathrooms = "Any"
            isBathroom = true
        }
        for button in bathRoomesBtnColl { // Assuming buttonCollection is an array of your buttons
            if button.title(for: .selected) == SingltonClass.shared.bathrooms {
                button.backgroundColor = .white
                prevSelBathroomButton = button
                isBathroom = true
            } else {
                button.backgroundColor = .clear
            }
        }
        if !isBathroom {
            self.bathroomsTF.text = SingltonClass.shared.bathrooms
        }
        
        for i in SingltonClass.shared.activies{
            if arrActivityTitle.contains(i){
                self.arrSelectedActivity.append("\(i)")
            }else{
                self.arrSelectedOtherActivity.append("\(i)")
            }
        }
        self.collecV_Activites.reloadData()
        self.collecV_OtherActivites.reloadData()
        print(SingltonClass.shared.activies)
        
        for i in SingltonClass.shared.aminities{
            //            if arrAmentiesTitle.contains(i){
            self.arrSelectedAmenties.append("\(i)")
            //            }
        }
        self.collecV_Amenties.reloadData()
        
        if SingltonClass.shared.instantBooking == "1"{
            btnAllowInstantBooking.setImage(UIImage(named: "selecticon"), for: .normal)
            btnAllowInstantBooking.isSelected = true
        }
        
        if SingltonClass.shared.selfCheck_in == "1"{
            btnSelfCheckIn.setImage(UIImage(named: "selecticon"), for: .normal)
            btnSelfCheckIn.isSelected = true
        }
        
        if SingltonClass.shared.allowPets == "1"{
            btnallowPets.setImage(UIImage(named: "selecticon"), for: .normal)
            btnallowPets.isSelected = true
        }
        
        if SingltonClass.shared.cancellationDays == "24"{
            self.lbl_cancelReason.text = "24 Hrs"
        }else{
            if let cancellationHours = Int(SingltonClass.shared.cancellationDays ?? "0") {
                self.lbl_cancelReason.text = "\(cancellationHours / 24) days"
            } else {
                self.lbl_cancelReason.text = ""
            }
        }
        
    }
}

extension HomeSetupVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Activites {
            return arrActivityTitle.count
        } else if collectionView == collecV_Amenties {
            return isExpanded ? arrAmentiesTitle.count : min(4, arrAmentiesTitle.count)
        }   else {
            return arrOtherActivityTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Activites {
            let cell = collecV_Activites.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            cell.img.image = UIImage(named: arrActivityImg[indexPath.row])
            cell.lbl_Name.text = arrActivityTitle[indexPath.row]
            if arrSelectedActivity.contains(arrActivityTitle[indexPath.row]){
                cell.view_Main.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
            }else{
                cell.view_Main.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 0.50).cgColor
            }
            return cell
        } else if collectionView == collecV_Amenties {
            let cell = collecV_Amenties.dequeueReusableCell(withReuseIdentifier: "AmentiesCell", for: indexPath) as! AmentiesCell
           
//            if indexPath.row % 2 == 0 {
//                cell.btnLeadingConst.priority = .defaultHigh
//            } else {
//                cell.btnLeadingConst.priority = .defaultLow
//            }
            
            cell.lbl_title.text = arrAmentiesTitle[indexPath.item]
            //Configure the button action
            if arrSelectedAmenties.contains(arrAmentiesTitle[indexPath.item]){
                cell.btnCheck.setImage(UIImage(named: "Check"), for: .normal)
            }else{
                cell.btnCheck.setImage(UIImage(named: "blankIcon"), for: .normal)
            }
            cell.btnCheck.tag = indexPath.item
            cell.btnCheck.addTarget(self, action: #selector(buttonSelectAmenties(_:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = collecV_OtherActivites.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            cell.img.image = UIImage(named: arrOtherActivityTitle[indexPath.item])
            cell.lbl_Name.text = arrOtherActivityTitle[indexPath.item]
            if arrSelectedOtherActivity.contains(arrOtherActivityTitle[indexPath.item]){
                cell.view_Main.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
            }else{
                cell.view_Main.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 0.50).cgColor
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecV_Activites{
            if arrSelectedActivity.contains(arrActivityTitle[indexPath.row]){
                if let index = arrSelectedActivity.firstIndex(of: arrActivityTitle[indexPath.row]) {
                    arrSelectedActivity.remove(at: index)
                    SingltonClass.shared.activies.remove(at: index)
                }
            }else{
                self.arrSelectedActivity.append(arrActivityTitle[indexPath.row])
                SingltonClass.shared.activies.append(arrActivityTitle[indexPath.row])
            }
            
            updateBedroomViews()
            
            print(arrSelectedActivity,"<<<<< arrSelectedActivity")
            
            self.collecV_Activites.reloadData()
            
        }else if collectionView == collecV_OtherActivites{
            if arrSelectedOtherActivity.contains(arrOtherActivityTitle[indexPath.item]){
                if let index = arrSelectedOtherActivity.firstIndex(of: arrOtherActivityTitle[indexPath.item]) {
                    arrSelectedOtherActivity.remove(at: index)
                    SingltonClass.shared.other_Activities.remove(at: index)
                }
            }else{
                self.arrSelectedOtherActivity.append(arrOtherActivityTitle[indexPath.item])
                SingltonClass.shared.other_Activities.append(arrOtherActivityTitle[indexPath.item])
            }
            print(arrSelectedOtherActivity,"<<<<< arrSelectedOtherActivity")
            self.collecV_OtherActivites.reloadData()
        }
    }
    
    @objc func buttonSelectAmenties(_ sender: UIButton){
        if arrSelectedAmenties.contains(arrAmentiesTitle[sender.tag]){
            if let index = arrSelectedAmenties.firstIndex(of: arrAmentiesTitle[sender.tag]) {
                arrSelectedAmenties.remove(at: index)
                SingltonClass.shared.aminities.remove(at: index)
            }
        }else{
            self.arrSelectedAmenties.append(arrAmentiesTitle[sender.tag])
            SingltonClass.shared.aminities.append(arrAmentiesTitle[sender.tag])
        }
        print()
        self.collecV_Amenties.reloadData()
    }
    
}

extension HomeSetupVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collecV_Amenties {
            
            let numberOfColumns: CGFloat = 2
            let padding: CGFloat = 10
            
            let collectionViewWidth = collecV_Amenties.frame.width
            let totalSpacing = padding * (numberOfColumns - 1)
            let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
            
            let text = arrAmentiesTitle[indexPath.row]
            
            // 🔥 Calculate dynamic height based on text
            let textHeight = text.height(
                withConstrainedWidth: cellWidth - 41, // label padding adjust karo
                font: UIFont.systemFont(ofSize: 14)
            )
            
            let finalHeight = textHeight + 35 // top + bottom + checkbox space
            
            return CGSize(width: cellWidth, height: max(50, finalHeight))
            
           // return CGSize(width: (collectionView.bounds.size.width / 2) - 6, height: 50)
        }  else {
            let numberOfColumns: CGFloat = 4  // Number of columns
            let padding: CGFloat = 10  // Total padding between cells (adjust as needed)
            // Calculate cell width
            let collectionViewWidth = collectionView.frame.width
            let totalSpacing = padding * (numberOfColumns - 1)  // Total space between cells
            let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
            return CGSize(width: cellWidth, height: 80)  // Set desired height
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust to set space between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust to set space between rows
    }
    
}
