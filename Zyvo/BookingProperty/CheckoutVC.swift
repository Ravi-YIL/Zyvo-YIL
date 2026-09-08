//
//  CheckoutVC.swift
//  Zyvo
//
//  Created by ravi on 28/11/24.
//

import UIKit
import DropDown
import Combine
import PassKit

class CheckoutVC: UIViewController {
    
    @IBOutlet weak var cancelPopUpBtn: UIButton!
    @IBOutlet weak var deletePopUpBtn: UIButton!
    @IBOutlet var DeleteView: UIView!
    @IBOutlet weak var btnShowMoreAddOns: UIButton!
    @IBOutlet weak var lbl_respondHours: UILabel!
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var lbl_HostRulesDesc: UILabel!
    @IBOutlet weak var lbl_timeFromTo: UILabel!
    @IBOutlet weak var lbl_parkingDesc: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_HostContactCard: UIView!
    @IBOutlet weak var view_MessageHost: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var imgDownArrowDebitCard: UIImageView!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var StackAbove: UIStackView!
    @IBOutlet weak var btnConfirmPay: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var stackV_MessageHost: UIStackView!
    @IBOutlet weak var view_MessageHostDesc: UIView!
    @IBOutlet weak var hostMessageTextView: UITextView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_availableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var btnMsgHost: UIButton!
    @IBOutlet weak var viewMain_SelectTimeFromTo: UIView!
    @IBOutlet weak var lbl_BookingDetailsTitle: UILabel!
    @IBOutlet weak var viewOutSideSelectDate: UIView!
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnShowMessageHost: UIButton!
    @IBOutlet weak var view_CreditDebitCard: UIView!
    @IBOutlet weak var btnAddNewCard: UIButton!
    @IBOutlet weak var btnSaveChangesDates: UIButton!
    @IBOutlet weak var view_Hours: UIView!
    @IBOutlet weak var view_Calendar: UIView!
    @IBOutlet weak var view_time2: UIView!
    @IBOutlet weak var view_AddmoreTime: UIView!
    @IBOutlet weak var view_SelectDate: UIView!
    @IBOutlet weak var refundPolicyLbl: UILabel!
    @IBOutlet weak var btnSelectYear: UIButton!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var view_date: UIView!
    @IBOutlet weak var view_month: UIView!
    @IBOutlet weak var view_year: UIView!
    @IBOutlet weak var viewFrom_hours: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var viewFrom_mnt: UIView!
    @IBOutlet weak var viewFrom_AMPM: UIView!
    @IBOutlet weak var viewTo_hours: UIView!
    @IBOutlet weak var viewTo_mnt: UIView!
    @IBOutlet weak var viewTo_AMPM: UIView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var view_ShowMoreAddOns: UIView!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_propertyName: UILabel!
    @IBOutlet weak var lbl_BookingDate: UILabel!
    @IBOutlet weak var view_addMoreTime: UIView!
    @IBOutlet weak var lbl_CDate: UILabel!
    @IBOutlet weak var lbl_cyear: UILabel!
    @IBOutlet weak var lbl_cmonth: UILabel!
    @IBOutlet weak var lbl_cdate: UILabel!
    @IBOutlet weak var lbl_Abovehours: UILabel!
    @IBOutlet weak var lbl_belowhours: UILabel!
    @IBOutlet weak var lbl_finalPrice: UILabel!
    @IBOutlet weak var lbl_hoursPrice: UILabel!
    @IBOutlet weak var view_CleaningFee: UIView!
    @IBOutlet weak var lbl_AddOnsAmount: UILabel!
    @IBOutlet weak var lbl_tax: UILabel!
    @IBOutlet weak var lbl_ZyvoServiceFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var viewBelow_SelectTime: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    
    @IBOutlet weak var lbl_AddOnsTitle: UILabel!
    @IBOutlet weak var view_mainAddsOns: UIView!
    @IBOutlet weak var view_TaxFee: UIView!
    let hoursDropdown = DropDown()
    
    let dotDropdown = DropDown()
    
    let dateDropDown = DropDown()
    let monthDropDown = DropDown()
    let yearDropDown = DropDown()
    let yearStrings = stride(from: 2024, through: 2100, by: 1).map { String($0) }
    
    let daysArr = (1...31).map { String($0) }
    
    var monthNamesArr = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    let arrHours = ["1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    private let spacing:CGFloat = 16.0
    var indexCard: String = ""
    var Host_count = 4
    var showRefundPolicy = "no"
    var StartDatetime = ""
    var EndDatetime = ""
    var bookingHours : Int? = 0
    var bookingAmount : Double? = 0.0
    var propertyID = ""
    var profileIMGURL = ""
    var propertyIMGURL = ""
    var propertyName = ""
    var propertyRating = ""
    var propertyNumberofReview = ""
    var propertyDistanceInMiles = ""
    var hostName = ""
    var bookingID = ""
    var cardID = ""
    var property_id = ""
    var booking_start = ""
    var startTime = ""
    var endTime = ""
    var booking_end = ""
    var booking_date = ""
    var booking_hours : Int? = 0
    var perHourRate : Int? = 0
    var minBookhours : Int? = 0
    var total_amount : Double? = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var zyvoServicePercentage : Double? = 0
    var tax : Double? = 0
    var awardStatus : Bool = false
    var channelName = ""
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    var parkDesc = ""
    var HostingRulesDesc = ""
    var hostProfileImg = ""
    var guestProfileImg = ""
    var isCardOpen = "no"
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var guestName = ""
    var hostID = 0
    var card_id = ""
    var customerID = ""
    var indx : Int? = 0
    let addons = [[String: Any]]()
    var addOnsArr: [AddOn] = []
    var getCardArr : [Card]?
    var arrSelectedArr :[Int] = []
    var addOnsNeddToSend: [[String: Any]] = []
    var isReadMore: Bool = false
    var fulladdOnsArr: [AddOn] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel = BookingPropertyViewModel()
    
    private var viewModel1 = BookingDetailsViewModel()
    
    var getJoinChannelDetails : JoinChanelModel?
    private var selectedHostMessage = "I have a doubt"
    
    var bookingResult : BookingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDeleteView()
        setupVerificationViews()
        
        btnShowMoreAddOns.titleLabel?.font = UIFont(name: "Poppins-regular", size: 15)
        self.lbl_AddOnsTitle.font = UIFont(name: "Poppins-Medium", size: 22)
        
        let rawText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.
"""

        self.refundPolicyLbl.attributedText = NSAttributedString.createAttributedRefundPolicy(from: rawText)
        
        self.lbl_BookingDate.font = UIFont(name: "Poppins", size: 16)!
        self.lbl_belowhours.font = UIFont(name: "Poppins", size: 16)!
        self.lbl_timeFromTo.font = UIFont(name: "Poppins", size: 16)!
        self.lbl_BookingDetailsTitle.font = UIFont(name: "Poppins-Medium", size: 22)!
        
        
        bindVC()
        
        if self.fulladdOnsArr.count == 0 {
            self.view_mainAddsOns.isHidden = true
        } else {
            self.view_mainAddsOns.isHidden = false
        }
        
        let addonsARRDATA = self.fulladdOnsArr
        if addonsARRDATA.count > 4 {
            
            self.view_ShowMoreAddOns.isHidden = false
            self.fulladdOnsArr = addonsARRDATA
            self.addOnsArr = Array(self.fulladdOnsArr.prefix(4))
            self.collecV_Host.reloadData()
            self.collVH.constant = 320
        } else {
            self.view_ShowMoreAddOns.isHidden = true
            self.addOnsArr = addonsARRDATA
            
        }
        
        if self.awardStatus == false {
            self.imgHostStar.isHidden = true
        } else {
            self.imgHostStar.isHidden = false
        }
        
        viewModel.apiForGetSavedCard()
        
        let guestID = Int(UserDetail.shared.getUserId())
        let hostID = self.hostID
        
        self.channelName = ChatChannelName.make(
            guestId: "\(guestID ?? 0)",
            hostId: "\(hostID)"
        )
        print(self.channelName,"self.channelName")
        print(guestID ?? 0, hostID, self.propertyID, "ASDFASDF")
        
        let inputDate = "\(booking_date)"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM, d yyyy"
            let outputDate = outputFormatter.string(from: date)
            
            print(outputDate) // Output: March, 4 2025
            self.lbl_BookingDate.text = "\(outputDate)"
        }
        
        if (booking_hours ?? 0) > 1 {
            self.lbl_Abovehours.text = "\(booking_hours ?? 0) hours"
            self.lbl_belowhours.text = "\(booking_hours ?? 0) hours"
        } else {
            self.lbl_Abovehours.text = "\(booking_hours ?? 0) hour"
            self.lbl_belowhours.text = "\(booking_hours ?? 0) hour"
        }
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
        
        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
        let finalPrice = "\(totalAmount)"
        self.lbl_finalPrice.text = "$\(finalPrice.formattedPriceString())"
        
        self.lbl_name.text = self.hostName.abbreviatedHostName
        
        self.lbl_timeFromTo.text = "From \(self.startTime) to \(self.endTime)"
        
        self.total_amount = totalAmount
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imgProfile.loadImage(from:profileIMGURL,placeholder: UIImage(named: "user"))
        
        self.imgProperty.layer.cornerRadius = 20
        self.imgProperty.contentMode = .scaleAspectFill
        
        self.imgProperty.loadImage(from:propertyIMGURL,placeholder: UIImage(named: "no_image (1)"))
        self.lbl_Distance.text = self.propertyDistanceInMiles  + " miles away"
        self.lbl_propertyName.text = self.propertyName
        self.lbl_rating.text  = self.propertyRating
        self.lbl_numberOfReview.text  = "(\(self.propertyNumberofReview))"
        
        if parkDesc == "" {
            self.lbl_parkingDesc.text = "No Rules"
        }else{
            self.lbl_parkingDesc.text = parkDesc
        }
        if HostingRulesDesc == "" {
            self.lbl_HostRulesDesc.text = "No Rules"
        }else{
            self.lbl_HostRulesDesc.text = HostingRulesDesc
        }
 
        self.lbl_propertyName.text = self.propertyName
        self.lbl_rating.text = self.propertyRating
       // self.lbl_numberOfReview.text = self.propertyNumberofReview
        
        let hourPrice = "\(self.booking_amount ?? 0.0)"
        self.lbl_hoursPrice.text = "$\(hourPrice.formattedPriceString())"
        let cleaningFees = "\(self.ClearningFee ?? 0.0)"
        view_CleaningFee.isHidden = true
       if cleaningFees != "0.0" {
           self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPriceString())"
           view_CleaningFee.isHidden = false
        }
       
        let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
        view_ZyvoServiceFee.isHidden = true
       if zyvoServiceFees != "0.0" {
           self.lbl_ZyvoServiceFee.text = "$\(zyvoServiceFees.formattedPriceString())"
           view_ZyvoServiceFee.isHidden = false
        }
        
        let taxFees = "\(self.taxAmount ?? 0.0)"
        view_TaxFee.isHidden = true
       if taxFees != "0.0" {
           self.lbl_tax.text = "$\(taxFees.formattedPriceString())"
           view_TaxFee.isHidden = false
        }
        
        let addonFees = "\(self.AddonOnsPrice ?? 0.0)"
        let addonPrice = "$\(addonFees.formattedPriceString())"
        if addonFees == "0.0" {
            self.view_AddOns.isHidden = true
        } else {
            self.view_AddOns.isHidden = false
            self.lbl_AddOnsAmount.text = addonPrice }
        
        print(DiscountAmount ?? 0.0,"DiscountAmount")
        
        if DiscountAmount == 0.0 || DiscountAmount == nil {
            view_Discount.isHidden = true
        } else {
            view_Discount.isHidden = false
            let DiscountAmountFee = "\(self.DiscountAmount ?? 0.0)"
            let DiscountAmountFees = "\(DiscountAmountFee.formattedPriceString())"
            self.lbl_discount.text = "-$\(DiscountAmountFees)"
        }
        
        viewHold_MessageHost.isHidden = true
        view_MessageHostDesc.isHidden = true
        hostMessageTextView.text = ""
        // StackAbove draws the visible card border. The outer container must
        // remain borderless to avoid a second nested outline.
        view_HostContactCard.layer.cornerRadius = 0
        view_HostContactCard.layer.borderWidth = 0
        view_HostContactCard.layer.borderColor = UIColor.clear.cgColor
        view_MessageHost.layer.cornerRadius = 20
        view_MessageHost.layer.borderWidth = 1.5
        view_MessageHost.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AddmoreTime.layer.cornerRadius = view_AddmoreTime.layer.frame.height / 2
        view_AddmoreTime.layer.borderWidth = 1.5
        view_AddmoreTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AddmoreTime.isHidden = true
        
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_availableDays.layer.cornerRadius = 10
        view_availableDays.layer.borderWidth = 1.5
        view_availableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_otherReason.layer.cornerRadius = 10
        view_otherReason.layer.borderWidth = 1.5
        view_otherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_MessageHostDesc.layer.cornerRadius = 10
        view_MessageHostDesc.layer.borderWidth = 1.5
        view_MessageHostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 10
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 10
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Card.isHidden = true
        view_Card.layer.cornerRadius = 20
        view_Card.layer.borderWidth = 1.5
        view_Card.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        StackAbove.layer.cornerRadius = 15
        StackAbove.layer.borderWidth = 1.5
        StackAbove.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        tblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        viewOutSideSelectDate.isHidden = true
        btnSaveChangesDates.layer.cornerRadius = 10
        
        view_SelectDate.layer.cornerRadius = 10
        view_SelectDate.layer.borderWidth = 1.5
        view_SelectDate.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_date.layer.cornerRadius = 10
        view_date.layer.borderWidth = 1.5
        view_date.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_month.layer.cornerRadius = 10
        view_month.layer.borderWidth = 1.5
        view_month.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_year.layer.cornerRadius = 10
        view_year.layer.borderWidth = 1.5
        view_year.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Hours.layer.cornerRadius = view_Hours.layer.frame.height / 2
        view_Hours.layer.borderWidth = 1.5
        view_Hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Calendar.layer.cornerRadius = view_Calendar.layer.frame.height / 2
        view_Calendar.layer.borderWidth = 1.5
        view_Calendar.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_time2.layer.cornerRadius = view_time2.layer.frame.height / 2
        view_time2.layer.borderWidth = 1.5
        view_time2.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_CreditDebitCard.layer.cornerRadius = view_CreditDebitCard.layer.frame.height / 2
        view_CreditDebitCard.layer.borderWidth = 1.5
        view_CreditDebitCard.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewMain_SelectTimeFromTo.isHidden = true
        
        viewBelow_SelectTime.layer.cornerRadius = 10
        viewBelow_SelectTime.layer.borderWidth = 1.5
        viewBelow_SelectTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewFrom_hours.layer.cornerRadius = 10
        viewFrom_hours.layer.borderWidth = 1.5
        viewFrom_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_mnt.layer.cornerRadius = 10
        viewFrom_mnt.layer.borderWidth = 1.5
        viewFrom_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_AMPM.layer.cornerRadius = 10
        viewFrom_AMPM.layer.borderWidth = 1.5
        viewFrom_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewTo_hours.layer.cornerRadius = 10
        viewTo_hours.layer.borderWidth = 1.5
        viewTo_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_mnt.layer.cornerRadius = 10
        viewTo_mnt.layer.borderWidth = 1.5
        viewTo_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_AMPM.layer.cornerRadius = 10
        viewTo_AMPM.layer.borderWidth = 1.5
        viewTo_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        btnConfirmPay.layer.cornerRadius = btnConfirmPay.layer.frame.height / 2
        btnAddNewCard.layer.cornerRadius = btnAddNewCard.layer.frame.height / 2
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        let nib = UINib(nibName: "CellHost", bundle: nil)
        collecV_Host?.register(nib, forCellWithReuseIdentifier: "CellHost")
        collecV_Host.delegate = self
        collecV_Host.dataSource = self
        collVH.constant = 80
        updateCollectionViewHeight()
        
        view_Details.layer.cornerRadius = 20
        view_Details.layer.borderWidth = 1.5
        view_Details.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnShowMessageHost.layer.cornerRadius = 10
        btnShowMessageHost.layer.borderWidth = 1
        btnShowMessageHost.layer.borderColor = UIColor.black.cgColor
        
    }
    
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        
        collecV_Host.layoutIfNeeded()
        let contentHeight1 = collecV_Host.contentSize.height
        collVH.constant = contentHeight1
        // Update the layout of the view
        self.view.layoutIfNeeded()
    }
    // Helper function to format price
    func formatPrice(_ amount: Double?) -> String {
        return "$\(String(format: "%.2f", amount ?? 0.0))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        updateMessageHostVisibility()
    }

    private func updateMessageHostVisibility() {
        let currentUserID = UserDetail.shared.getUserId().trimmingCharacters(in: .whitespacesAndNewlines)
        let canMessageHost = !currentUserID.isEmpty && hostID > 0 && currentUserID != "\(hostID)"
        view_HostContactCard.isHidden = !canMessageHost
        if !canMessageHost {
            viewHold_MessageHost.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ((self.tabBarController?.tabBar.isHidden) != nil) {
            var frame = view.frame
            frame.size.height = UIScreen.main.bounds.height
            view.frame = frame
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        selectedHostMessage = "I have a doubt"
        view_MessageHostDesc.isHidden = true
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_availableDays.backgroundColor = UIColor.white
        view_otherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        selectedHostMessage = "Available days"
        view_MessageHostDesc.isHidden = true
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        selectedHostMessage = "Others"
        view_MessageHostDesc.isHidden = false
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnSendMessageHost_Tap(_ sender: UIButton) {
        let senderID = UserDetail.shared.getUserId().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !senderID.isEmpty, hostID > 0, senderID != "\(hostID)" else { return }
        if selectedHostMessage == "Others",
           hostMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(for: "Please enter your message")
            return
        }
        view.endEditing(true)
        channelName = ChatChannelName.make(guestId: senderID, hostId: "\(hostID)")
        viewModel1.apiForJoinChannel(senderId: senderID, receiverId: "\(hostID)", groupChannel: channelName, userType: "guest")
    }
    
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isParkingRulesOpen == "no" {
            view_ParkingDesc.isHidden = false
            isParkingRulesOpen = "Yes"
        } else {
            view_ParkingDesc.isHidden = true
            isParkingRulesOpen = "no"
        }
    }
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isHostTingRulesOpen == "no" {
            view_HostDesc.isHidden = false
            isHostTingRulesOpen = "Yes"
        } else {
            view_HostDesc.isHidden = true
            isHostTingRulesOpen = "no"
        }
    }
    
    @IBAction func btnCreditDebit_Tap(_ sender: UIButton) {
        if isCardOpen == "no" {
            view_Card.isHidden = false
            isCardOpen = "yes"
            imgDownArrowDebitCard.image = UIImage(named: "União 106")
        } else {
            view_Card.isHidden = true
            isCardOpen = "no"
            imgDownArrowDebitCard.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.backAction = {
            self.viewModel.apiForGetSavedCard()
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func btnSelectDate_Tap(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnConfirmPay_Tap(_ sender: UIButton) {
        
        viewModel.property_id = self.property_id
        viewModel.booking_start = self.booking_start
        viewModel.booking_end = self.booking_end
        viewModel.booking_date = self.booking_date
        viewModel.booking_hours = self.booking_hours ?? 0
        viewModel.booking_amount =  self.booking_amount ?? 0.0
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + addOns
        
        self.total_amount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        viewModel.total_amount = self.total_amount ?? 0.0
        
        addOnsNeddToSend = arrSelectedArr.filter { $0 < addOnsArr.count }.map { index in
            let addOn = addOnsArr[index]
            return [
                // Replace with actual properties of AddOn
                "name": addOn.name ?? "",
                "price": addOn.price ?? ""
            ]
        }
        if self.getCardArr?.count == 0  || self.getCardArr?.count ==  nil {
            self.showAlert(for: "Please add card")
        }  else if self.getCardArr?.count == 1 {
            self.card_id = self.getCardArr?[0].cardID ?? ""
            viewModel.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel.cardID = self.card_id
            viewModel.customer_id =  self.customerID
            viewModel.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            
            viewModel.apiForBookingProperty(adsOns:addOnsNeddToSend)
        }
        else {
            if let preferredCardID = getCardArr?.compactMap({ $0.isPreferred == true ? $0.cardID : nil }).first {
                print("Preferred Card ID: \(preferredCardID)")
                self.card_id = "\(preferredCardID)"
            } else {
                print("No preferred card found")
            }
            
            viewModel.cardID = self.card_id
            viewModel.customer_id =  self.customerID
            viewModel.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel.apiForBookingProperty(adsOns:addOnsNeddToSend)
        }
        
    }
    
    
    @objc func startApplePay() {

        // Total Amount Calculation

        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0

        let addTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + addOns

        self.total_amount = addTotalAmount - (self.DiscountAmount ?? 0.0)

        // Payment Request

        let paymentRequest = PKPaymentRequest()

        paymentRequest.merchantIdentifier = "merchant.YesITLab.ZyvoLLC"
        
        paymentRequest.supportedNetworks = [
            .visa,
            .masterCard,
            .amex,
            .discover
        ]

        paymentRequest.merchantCapabilities = .capability3DS

        paymentRequest.countryCode = "US"

        paymentRequest.currencyCode = "USD"

        // Payment Summary

        var paymentItems: [PKPaymentSummaryItem] = []

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Booking Amount",
                amount: NSDecimalNumber(value: bookingAmount)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Cleaning Fee",
                amount: NSDecimalNumber(value: cleaningFee)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Service Fee",
                amount: NSDecimalNumber(value: serviceFee)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Tax",
                amount: NSDecimalNumber(value: tax)
            )
        )

        if addOns > 0 {

            paymentItems.append(
                PKPaymentSummaryItem(
                    label: "Add Ons",
                    amount: NSDecimalNumber(value: addOns)
                )
            )
        }

        if (self.DiscountAmount ?? 0.0) > 0 {

            paymentItems.append(
                PKPaymentSummaryItem(
                    label: "Discount",
                    amount: NSDecimalNumber(value: -(self.DiscountAmount ?? 0.0))
                )
            )
        }

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Zyvo",
                amount: NSDecimalNumber(value: self.total_amount ?? 0.0)
            )
        )

        paymentRequest.paymentSummaryItems = paymentItems

        // Present Apple Pay

        guard let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {

            showAlert(for: "Unable to present Apple Pay")
            return
        }

        controller.delegate = self

        present(controller, animated: true)
    }
    
    @IBAction func btnPaymentUsingApplePay_Tap(_ sender: UIButton) {
        
        if PKPaymentAuthorizationViewController.canMakePayments() {
            
            startApplePay()
            
        } else {
            
            showAlert(for: "Apple Pay is not available on this device")
        }
    }
    @IBAction func btnShowMessageHost_Tap(_ sender: UIButton) {
        let senderID = UserDetail.shared.getUserId().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !senderID.isEmpty, hostID > 0, senderID != "\(hostID)" else { return }
        viewHold_MessageHost.isHidden.toggle()
        view.endEditing(true)
    }
    
    @IBAction func btnHours_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnbelowSelectDate_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        dateDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dateDropDown.dataSource = daysArr
        dateDropDown.direction = .bottom
        
        dateDropDown.bottomOffset = CGPoint(x: 3, y:(dateDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dateDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        dateDropDown.show()
    }
    
    @IBAction func btnAddMoreTime_Tap(_ sender: UIButton) {
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        //        vc.backAction = {
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TotalAmountPopUpVC") as! TotalAmountPopUpVC
        //            vc.modalPresentationStyle = .overCurrentContext
        //            self.present(vc, animated: true)
        //        }
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnbelowMonth_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        monthDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        monthDropDown.dataSource = monthNamesArr
        monthDropDown.direction = .bottom
        
        monthDropDown.bottomOffset = CGPoint(x: 3, y:(monthDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        monthDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        monthDropDown.show()
    }
    @IBAction func btnbelowYear_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        yearDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        yearDropDown.dataSource = yearStrings
        yearDropDown.direction = .bottom
        
        yearDropDown.bottomOffset = CGPoint(x: 3, y:(yearDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        yearDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        yearDropDown.show()
    }
    
    private func setupVerificationViews() {
       
        setupFullScreenSubview(DeleteView)
    }
    private func setupFullScreenSubview(_ subview: UIView) {
        subview.frame = self.view.bounds
        self.view.addSubview(subview)
        subview.isHidden = true
    }
    
    func setDeleteView() {
        //  self.deletePopUpMainView.layer.cornerRadius = 0
          self.DeleteView.layer.cornerRadius = 26
          //self.deletePopUpLbl.layer.cornerRadius = 0
          self.deletePopUpBtn.layer.cornerRadius = self.cancelPopUpBtn.frame.height/2
          self.cancelPopUpBtn.layer.cornerRadius = self.cancelPopUpBtn.frame.height/2
          self.cancelPopUpBtn.layer.borderWidth = 1
          self.cancelPopUpBtn.layer.borderColor = UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1).cgColor

      }

    
    @IBAction func showMoreRefundPolicyBtn(_ sender: UIButton){
        if showRefundPolicy == "no"{
            self.showRefundPolicy = "yes"
           
            let rawText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.

2. Guest cancellations
If a guest cancels, the refundable amount is calculated using the cancellation terms that were presented before the booking was confirmed. The app will show the expected refund, when available, before the guest completes the cancellation.
• A cancellation is effective only after it is submitted through ZYVO and the booking status changes to cancelled.
• Not attending, arriving late, leaving early, or using less time than booked does not automatically create a right to a refund.
• Any fee identified as non-refundable before payment will remain non-refundable unless required by law or ZYVO determines otherwise for a qualifying booking issue.
• If a refund is approved, it is returned to the original payment method whenever possible.

3. Host cancellations
If a host cancels a confirmed booking, the guest will generally receive a refund of the amounts paid for that booking. ZYVO may also take account action when a host repeatedly cancels confirmed bookings, including limiting the host’s ability to accept future bookings or publish listings.
A host should not ask a guest to cancel on the host’s behalf. If the host cannot honor a booking, the host should cancel it through ZYVO so the booking history and refund can be handled correctly.

4. Space unavailable or materially different
Guests should contact ZYVO promptly if they arrive and the booked space is unavailable, unsafe for the booked use, inaccessible despite following the host’s instructions, or materially different from the listing in a way that prevents the intended booking from reasonably taking place.
Depending on the circumstances and the evidence available, ZYVO may issue a full refund, a partial refund, account credit where legally permitted, or another appropriate resolution. Guests may be asked to provide photos, video, messages, receipts, or other information that helps us review the issue.

5. Booking interruptions and early termination
If a booking begins but cannot reasonably continue because of a qualifying issue with the space or host access, ZYVO may consider a partial or full refund based on the portion of the booking affected. Refunds are not guaranteed for issues caused by the guest, members of the guest’s party, or a use that violates the listing rules or these Terms.

6. Cleaning fees, platform fees and taxes
Whether cleaning fees, platform fees, taxes, or other charges are refunded depends on the cancellation terms, the timing and reason for the cancellation, and applicable law. Any amount that will not be refunded should be shown in the cancellation summary before the cancellation is finalized whenever the product supports that calculation.

7. Payment processing time
ZYVO may approve or initiate a refund quickly, but the time it takes to appear in a guest’s account depends on the bank, card issuer, wallet provider, or payment processor. Processing times can vary and are outside ZYVO’s direct control.

8. Chargebacks and payment disputes
If there is a problem with a booking, guests should contact ZYVO first so we can review it. Filing a chargeback does not guarantee a refund and may pause ZYVO’s internal review while the payment provider investigates. Users must provide accurate information in any payment dispute.

9. Fraud, abuse and policy violations
ZYVO may deny or reverse a refund where there is evidence of fraud, fabricated claims, chargeback abuse, unauthorized payment activity, misuse of the platform, or a material violation of the booking rules or Terms & Conditions, subject to applicable law.

10. How to request help with a refund
Open the affected booking and select the available help or support option. Include the booking details and a short explanation of what happened. For active or time-sensitive bookings, contact support as soon as possible so the issue can be reviewed while the booking details are still current.
"""

            self.refundPolicyLbl.attributedText = NSAttributedString.createAttributedRefundPolicy(from: rawText)
            
            sender.setTitle("Read less", for: .normal)
            
        }else{
            self.showRefundPolicy = "no"
            sender.setTitle("Read more", for: .normal)
            
            let rawText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.
"""

            self.refundPolicyLbl.attributedText = NSAttributedString.createAttributedRefundPolicy(from: rawText)
            
        }
    }
    
    @IBAction func btnShowMore_Tap(_ sender: UIButton) {
       
            isReadMore.toggle()

              if isReadMore {
                  // See Less state — show all
                  addOnsArr = fulladdOnsArr
                  sender.setTitle("Show Less", for: .normal)

                  // Reload and update height
                  self.collecV_Host.reloadData()
                  self.collecV_Host.layoutIfNeeded()
                  let contentHeight = self.collecV_Host.collectionViewLayout.collectionViewContentSize.height
                  self.collVH.constant = contentHeight
              } else {
                  // See More state — show limited
                  addOnsArr = Array(fulladdOnsArr.prefix(4))
                  sender.setTitle("Show More", for: .normal)
                  self.collVH.constant = 320
              }

              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }

       
    }
    
    @IBAction func btnSelectTimeFromTo_Tap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveChangesTimeFromTo_Tap(_ sender: Any) {
        viewMain_SelectTimeFromTo.isHidden = true
    }
    
    @IBAction func btnConfirm_Tapped(_ sender: UIButton) {
        
        self.viewModel.apiForDeleteSavedCard(cardID: indexCard)
        
    }
    @IBAction func btnCancel_Tapped(_ sender: UIButton) {
        
        self.DeleteView.isHidden = true
        
    }
    @IBAction func btnSaveChangesSelectDate_Tap(_ sender: UIButton) {
        viewOutSideSelectDate.isHidden = true
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = totalPrice * (discountPercent / 100)
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = totalPrice - discountAmount
        
        // Step 3: Calculate Tax Amount
        let taxAmount = discountedPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = discountedPrice + taxAmount
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, roundedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = totalPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (roundedTaxAmount, finalPrice)
    }
}

extension CheckoutVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return addOnsArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        if collectionView == collecV_Host {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
        let data = addOnsArr[indexPath.row]
        cell.lbl_title.text = data.name
        var hour = data.price ?? ""
        let price = hour.formattedPriceString()
        if price != "" {
            cell.lbl_price.text = "$\(price) / Item"
        } else {
            cell.lbl_price.text = ""
        }
        if arrSelectedArr.contains(indexPath.row){
            cell.mainV.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        }else{
            cell.mainV.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 1).cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecV_Host{
            if arrSelectedArr.contains(indexPath.row){
                if let index = arrSelectedArr.firstIndex(of: indexPath.row) {
                    arrSelectedArr.remove(at: index)
                }
            }else{
                self.arrSelectedArr.append(indexPath.row)
            }
            updateTotalPrice(index : indexPath.row)
            
            self.collecV_Host.reloadData()
            
        }
    }
    func updateTotalPrice(index : Int) {
        let total = arrSelectedArr.reduce(0) { sum, index in
            let price = Double(addOnsArr[index].price ?? "0") ?? 0.0
            return sum + price
        }
        
        print("Total Price: $\(total)")
        self.AddonOnsPrice = total
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        var addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + total
        
        let totalAmount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        let totalsum = "\(totalAmount)"
        
        self.lbl_finalPrice.text = "$\(totalsum.formattedPriceString())"
        
        self.total_amount = totalAmount
        let priceAddOn = "\(self.AddonOnsPrice ?? 0.0)"
        
        if priceAddOn == "0.0" {
            self.view_AddOns.isHidden = true
        }else {
            self.view_AddOns.isHidden = false
        }
        self.lbl_AddOnsAmount.text = "$\(priceAddOn.formattedPriceString())"
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10 // Adjust spacing as needed
        let numberOfColumns: CGFloat = 1
        let totalSpacing = (numberOfColumns - 1) * spacing
        
        let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
        let itemHeight: CGFloat = 70 // Fixed height as per your code
        print(itemWidth,itemHeight,"itemWidth,itemHeight")
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

extension CheckoutVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCardArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let data = getCardArr?[indexPath.row]
        cell.lbl_cardNumber.text = ("**** **** **** \(data?.last4 ?? "")")
        cell.btnDot.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if data?.isPreferred == true {
            cell.lbl_Preferred.isHidden = false
        } else {
            cell.lbl_Preferred.isHidden = true
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = getCardArr?[indexPath.row]
//        self.indx = indexPath.row
//        self.viewModel.apiForSetPreferredCard(cardID: data?.cardID ?? "")
//    }
    
    
    @objc func buttonTapped(_ sender: UIButton) {

        let buttonPosition = sender.convert(CGPoint.zero, to: tblV)

        guard let indexPath = tblV.indexPathForRow(at: buttonPosition),
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

                self.DeleteView.isHidden = false
               
                self.tabBarController?.setTabBarHidden(true, animated: false)

                // Direct delete karna ho to:
                // self.viewModel.apiForDeleteSavedCard(cardID: self.indexCard)
            }
        }

        dotDropdown.show()
    }
}
extension CheckoutVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$bookingPropertyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.message ?? "")
                    self.bookingResult = response.data
                    self.bookingID = "\(self.bookingResult?.booking?.id ?? 0)"
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutConfirmationVC") as! CheckOutConfirmationVC
                    vc.startTime = self.startTime
                    vc.channelName = self.channelName
                    vc.hostID = self.hostID
                    vc.endTime = self.endTime
                    vc.awardStatus = self.awardStatus
                    
                    vc.hostName = self.hostName
                    vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                    vc.propertyName = self.propertyName
                    vc.propertyRating = self.propertyRating
                    vc.propertyNumberofReview =  self.propertyNumberofReview
                    vc.propertyIMGURL =  self.propertyIMGURL
                    vc.perHourRate = self.perHourRate
                    vc.booking_start = self.StartDatetime
                    vc.booking_end = self.EndDatetime
                    vc.booking_hours = self.booking_hours ?? 0
                    vc.booking_amount = self.booking_amount
                    vc.property_id = self.property_id
                    vc.propertyID = self.property_id
                    vc.booking_date = self.booking_date
                    vc.bookingID = self.bookingID
                    // vc.addOnsNeddToSend = self.addOnsNeddToSend
                    vc.taxAmount =  self.taxAmount
                    vc.minBookhours = self.minBookhours
                    vc.DiscountAmount = self.DiscountAmount
                    vc.ClearningFee = (self.ClearningFee ?? 0.0)
                    vc.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
                    vc.AddonOnsPrice = self.AddonOnsPrice ?? 0.0
                    vc.addOnsArr = self.addOnsArr
                    vc.arrSelectedArr = self.arrSelectedArr
                    vc.profileIMGURL = self.profileIMGURL
                    vc.parkDesc = self.parkDesc
                    vc.HostingRulesDesc = self.HostingRulesDesc
                    vc.DiscountPercentage = self.DiscountPercentage
                    vc.taxPercentage = self.taxPercentage
                    vc.zyvoServicePercentage = self.zyvoServicePercentage
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getCardArr = response.data?.cards
                    
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    self.tblV.reloadData()
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
        
        viewModel1.$getJoinChannelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getJoinChannelDetails = response.data
                    
                    var senderID =  self.getJoinChannelDetails?.senderID ?? ""
                    var receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                    
                    let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                    self.guestProfileImg = AppURL.imageURL + guestIMG
                    
                    let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                    self.hostProfileImg = AppURL.imageURL + HostIMG
                    
                    let stryB = UIStoryboard(name: "Chat", bundle: nil)
                    if let vc = stryB.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                        vc.uniqueConversationName = self.channelName
                        vc.Message = self.selectedHostMessage == "Others"
                            ? self.hostMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                            : self.selectedHostMessage
                        self.viewHold_MessageHost.isHidden = true
                        vc.friend_id = "\(receiverID)"
                        vc.SenderID = senderID
                        vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                        vc.hostName = (self.getJoinChannelDetails?.receiverName ?? self.hostName).abbreviatedHostName
                        vc.hostProfileImg = self.hostProfileImg
                        vc.guesttProfileImg =  self.guestProfileImg
                        self.tabBarController?.tabBar.isHidden = true
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
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
                    self.DeleteView.isHidden = true
                  //  self.deletePopUpMainView.isHidden = true
                    self.tabBarController?.setTabBarHidden(false, animated: false)
                    self.getCardArr?.remove(at: self.indx ?? 0)
                    self.tblV.reloadData()
                
                })
            }.store(in: &cancellables)
        
        
    }
}


extension CheckoutVC: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {

        // MARK: Payment Token

        // MARK: Booking Parameters

        viewModel.property_id = self.property_id
        viewModel.booking_start = self.booking_start
        viewModel.booking_end = self.booking_end
        viewModel.booking_date = self.booking_date
        viewModel.booking_hours = self.booking_hours ?? 0
        viewModel.booking_amount = self.booking_amount ?? 0.0
        viewModel.total_amount = self.total_amount ?? 0.0
        viewModel.service_fee = "\(self.zyvoServiceFee ?? 0.0)"
        viewModel.tax = "\(self.taxAmount ?? 0.0)"
        viewModel.discount_amount = "\(self.DiscountAmount ?? 0.0)"
        viewModel.customer_id = self.customerID

        // Send token to backend

        do {

            let paymentData = payment.token.paymentData

            let jsonObject = try JSONSerialization.jsonObject(with: paymentData, options: [])

            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])

            let tokenString = String(data: jsonData, encoding: .utf8) ?? ""

            viewModel.apple_pay_token = tokenString

        } catch {
            print(error)
        }
     

        // MARK: Add Ons

        addOnsNeddToSend = arrSelectedArr
            .filter { $0 < addOnsArr.count }
            .map { index in

                let addOn = addOnsArr[index]

                return [
                    "name": addOn.name ?? "",
                    "price": addOn.price ?? ""
                ]
            }

        // MARK: API Call

        viewModel.apiForBookingPropertybyApplePay(adsOns: addOnsNeddToSend) { success, message in

            DispatchQueue.main.async {

                if success {

                    // Apple Pay Success

                    completion(
                        PKPaymentAuthorizationResult(
                            status: .success,
                            errors: nil
                        )
                    )

                    // Dismiss Apple Pay

                    controller.dismiss(animated: true)

                } else {

                    // Apple Pay Failed

                    completion(
                        PKPaymentAuthorizationResult(
                            status: .failure,
                            errors: nil
                        )
                    )

                    self.showAlert(for: message)
                }
            }
        }
    }

    // MARK: Dismiss Apple Pay

    func paymentAuthorizationViewControllerDidFinish(
        _ controller: PKPaymentAuthorizationViewController
    ) {

        controller.dismiss(animated: true)
    }
}

extension NSAttributedString {
    static func createAttributedRefundPolicy(from text: String, baseFontSize: CGFloat = 16.5) -> NSAttributedString {
        let regularFont = UIFont(name: "Poppins-Regular", size: baseFontSize) ?? UIFont.systemFont(ofSize: baseFontSize)
        let semiboldFont = UIFont(name: "Poppins-SemiBold", size: baseFontSize) ?? UIFont(name: "Poppins-Bold", size: baseFontSize) ?? UIFont.boldSystemFont(ofSize: baseFontSize)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .left

        let fullAttributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: regularFont,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label
            ]
        )

        let headings = [
            "1. How refunds are determined",
            "2. Guest cancellations",
            "3. Host cancellations",
            "4. Space unavailable or materially different",
            "5. Booking interruptions and early termination",
            "6. Cleaning fees, platform fees and taxes",
            "7. Payment processing time",
            "8. Chargebacks and payment disputes",
            "9. Fraud, abuse and policy violations",
            "10. How to request help with a refund"
        ]

        let nsString = text as NSString
        for heading in headings {
            var searchRange = NSRange(location: 0, length: nsString.length)
            while searchRange.location < nsString.length {
                let foundRange = nsString.range(of: heading, options: [], range: searchRange)
                if foundRange.location != NSNotFound {
                    fullAttributedString.addAttribute(.font, value: semiboldFont, range: foundRange)
                    searchRange.location = foundRange.location + foundRange.length
                    searchRange.length = nsString.length - searchRange.location
                } else {
                    break
                }
            }
        }

        return fullAttributedString
    }
}
