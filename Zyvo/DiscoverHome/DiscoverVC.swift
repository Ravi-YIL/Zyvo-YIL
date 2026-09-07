//
//  DiscoverVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import Combine
import CoreLocation

var isappliedField:Bool = false

class DiscoverVC: UIViewController,LocationPickerDelegate {
    //private let progressBar = SemiCircleProgressBar()
    @IBOutlet weak var lbl_seconds: UILabel!
    @IBOutlet weak var stackV_TimeLeft: UIStackView!
    @IBOutlet weak var lbl_minutes: UILabel!
    @IBOutlet weak var lbl_hours: UILabel!
    
    @IBOutlet weak var btnShowMap: UIButton!
    @IBOutlet weak var btnShowMapH_Constant: NSLayoutConstraint!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Where: UILabel!
    @IBOutlet weak var lbl_Activity: UILabel!
   
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Search: UIView!
    
    @IBOutlet weak var view_RemainingTime: UIView!
    // Timer properties
    var timer: Timer?
    var totalSeconds = 0 // Initial time in seconds
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    
    //var progressView: CustomArcProgressView!
       var progress: CGFloat = 0
    var isComingBackFromMap = false
    var hasSkippedLocation = false
    
    var comingFrom = ""
    //FilterData
    var timess: String = ""
    var startDates: Date?
    var endDates: Date?
    var isCountingUp = false
    var startTime = ""
    var endTime = ""
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
    var tax : Double? = 0
    var StartDatetime = ""
    var EndDatetime = ""
    var addOnsArr: [AddOn] = []
    var arrSelectedArr :[Int] = []
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    var zyvoServicePercentage : Double? = 0
    
    var parkDesc = ""
    var HostingRulesDesc = ""
    
    var getHomeDataArr : [HomeDataModel]?
    
    var getUserBooking : UserBookingModel?
    
    var getBookingArr : [UserBooking]?
    
    var getUserBookingPropertyArr : [UserProperty]?
   
    let calculator = TimeDifferenceCalculator()
    
    var lat = ""
    var lng = ""
    
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    
    var shouldFetchHomeData = true
    var progressBar: SemiCircleProgressBar?
    
    var progressView: CustomArcProgressView!
       
       var totalDuration: TimeInterval = 0
       var remainingTime: TimeInterval = 0
    
    var timer2: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(reloadHomeData),
               name: NSNotification.Name("ReloadHomeData"),
               object: nil
           )
        
        FirebaseChatManager.shared.connect()

        self.view_RemainingTime.isHidden = true
        self.stackV_TimeLeft.isHidden = true
        
        self.setupProgressView()
       
       LocationPicker.shared.delegate = self
       // LocationPicker.shared.checkLocationPermission()
        // NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        bindVC()
    
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        let nib2 = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 10
        
    }
    
    @objc func reloadHomeData() {

        self.getHomeDataArr = []
        self.collecV.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        shouldFetchHomeData = true
        checkLocationFlow()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isTimeExtend = UserDetail.shared.getisTimeExtend()
        let currentDate = Date()
        
        // Format for current date (e.g., 2025-05-09)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        // Format for current date and time (e.g., 2025-05-09 14:35:20)
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDateTime = dateTimeFormatter.string(from: currentDate)
        print("Current Date: \(formattedDate) | Current Date and Time: \(formattedDateTime)")
        
        // Updating your view model
        self.viewModel.bookingStart = formattedDateTime
        self.viewModel.bookingDate = formattedDate
        self.viewModel.apiforGetBookedPropertyTimer()
        
        // }

       // LocationPicker.shared.checkLocationPermission()
        LocationPicker.shared.delegate = self
        self.tabBarController?.tabBar.isHidden = false

        shouldFetchHomeData = true
        
        if isComingBackFromMap {
            isComingBackFromMap = false
            return
        }

        guard canCallAPI() else {
            checkLocationFlow()
            return
        }

        let savedLat = UserDetail.shared.getAppLatitude()
        let savedLng = UserDetail.shared.getAppLongitude()
        
        
        print(savedLat,"savedLat")
        print(savedLng,"savedLng")

        if !savedLat.isEmpty && !savedLng.isEmpty && savedLat != "0.0" && savedLng != "0.0" && savedLat != "0" && savedLng != "0" {
            viewModel.latitude = savedLat
            viewModel.longitude = savedLng
            
            self.lat  = savedLat
            self.lng  = savedLng
          
            if isappliedField == false || (getHomeDataArr == nil || getHomeDataArr?.isEmpty == true) {
                viewModel.apiforGetHomeData()
                shouldFetchHomeData = false
            }
        } else {

            checkLocationFlow()
        }
    }
  
    
    func canCallAPI() -> Bool {
        return CLLocationManager.locationServicesEnabled() &&
               (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways)
    }
    
    @objc func appDidBecomeActive() {
        // Do not check location flow on background to foreground transition
    }

    func checkLocationFlow() {
        if hasSkippedLocation {
            return
        }
        // Device OFF
        if !CLLocationManager.locationServicesEnabled() {
            presentLocationPopup(type: .deviceOff)
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .notDetermined:
            presentLocationPopup(type: .permissionRequired)
            
        case .denied, .restricted:
            presentLocationPopup(type: .permissionDenied)
            
        case .authorizedWhenInUse, .authorizedAlways:
            // ✅ Only call this ONCE
            LocationPicker.shared.requestLocationAccess()
            
        @unknown default:
            break
        }
    }
    
    
    func presentLocationPopup(type: LocationPopupType) {
        
        // Prevent multiple popups
        if presentedViewController is LocationPopUPVC { return }
        
        self.getHomeDataArr = []
        self.collecV.restore()
        self.collecV.reloadData()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationPopUPVC") as! LocationPopUPVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        vc.popupType = type
        
        print(type,"type")

        vc.onTurnOn = { [weak self, weak vc] in
            guard let self = self else { return }

            vc?.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    switch type {

                    case .deviceOff :
                        self.showLocationServicesAlert()
                    case .permissionDenied:
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil) }
                    case .permissionRequired:
                        LocationPicker.shared.delegate = self
                        LocationPicker.shared.requestLocationAccess()
                        
                    }
                }
            }
        }
        
        vc.onSkip = { [weak self] in
            guard let self = self else { return }
            self.hasSkippedLocation = true
            LocationPicker.shared.stopUpdatingLocation()
            UserDetail.shared.setAppLatitude("0.0")
            UserDetail.shared.setAppLongitude("0.0")
            self.lat = "0.0"
            self.lng = "0.0"
            self.latitude = 0.0
            self.longitude = 0.0
            self.viewModel.latitude = "0.0"
            self.viewModel.longitude = "0.0"
            self.shouldFetchHomeData = false
            self.getHomeDataArr = []
            self.collecV.restore()
            self.collecV.reloadData()
            self.viewModel.apiforGetHomeData()
        }
        
        present(vc, animated: true)
    }
    
    
    func showLocationServicesAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable Location Services from\nSettings → Privacy & Security → Location Services",
            preferredStyle: .alert
        )
        
        // OK button (no action)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func didUpdateLocation(latitude: Double, longitude: Double) {
        hasSkippedLocation = false
        print("Latitude: \(latitude), Longitude: \(longitude)")
        self.latitude = latitude
        self.longitude = longitude
        self.lat = "\(latitude)"
        self.lng = "\(longitude)"
        
        // Save actual device GPS location
        UserDetail.shared.setDeviceLatitude("\(latitude)")
        UserDetail.shared.setDeviceLongitude("\(longitude)")

        UserDetail.shared.setAppLatitude("\(latitude)")
        UserDetail.shared.setAppLongitude("\(longitude)")
        self.viewModel.latitude = "\(latitude)"
        self.viewModel.longitude = "\(longitude)"
        
        shouldFetchHomeData = false
        self.viewModel.apiforGetHomeData()
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // MARK: - Timer Methods
    
    func startTimer(hours: Int, minutes: Int, seconds: Int) {
        // Convert hours, minutes, and seconds to total seconds
        totalSeconds = hours * 3600 + minutes * 60 + seconds
        
        // Invalidate any existing timer
        timer?.invalidate()
        
        // Start a new timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if totalSeconds > 0 {
            totalSeconds -= 1 // Decrease the total seconds
            printTimeComponents(from: totalSeconds)
            
            //  Convert totalSeconds back to hours, minutes, and seconds
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            
            let isNeedMoreOpenOnce = UserDetail.shared.getisNeedMoreOpenOnce()
            if hours == 0, minutes <= 30, seconds == 0 {
                let isTimeExtend = UserDetail.shared.getisTimeExtend()
                if isNeedMoreOpenOnce != "No" {
                    if isTimeExtend == "No" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeedMoreTimePopUpVC") as! NeedMoreTimePopUpVC
                        vc.backAction = { [weak self] str in
                            guard let self = self else { return }
                            print(str, "Data Recieved")
                            
                            if str == "Yes" {
                                self.presentAddMoreTimePopUp()
                            }
                            if str == "No" {
                                UserDetail.shared.setisNeedMoreOpenOnce("No")
                            }
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
        } else {
            timer?.invalidate() // Stop the timer when it reaches zero
            print("Timer finished!")
        }
    }
    
    func printTimeComponents(from seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        // Format the values with leading zeros
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        let formattedSeconds = String(format: "%02d", seconds)
        
        self.lbl_hours.text = "\(formattedHours)"
        self.lbl_minutes.text = "\(formattedMinutes)"
        self.lbl_seconds.text = "\(formattedSeconds)"
    }
    
    deinit {
        timer?.invalidate()
        timer2?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction func btnWhereTap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        shouldFetchHomeData = true
        vc.comeFrom = "Where"
        vc.latitude = self.lat
        vc.longitude = self.lng

        vc.backAction = { [weak self] str, str1 in
            guard let self = self else { return }
            print(str, str1, "data Recieved")

            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    self.lat = devLat
                    self.lng = devLng
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude(self.lat)
                    UserDetail.shared.setAppLongitude(self.lng)
                }
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"

                if let data = str, data.count > 0 {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = data
                    self.collecV.reloadData()
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    // MARK: - Price Calculation Helpers
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        let discountAmount = totalPrice * (discountPercent / 100)
        let discountedPrice = totalPrice - discountAmount
        let taxAmount = discountedPrice * (taxPercent / 100)
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        let finalPrice = discountedPrice + taxAmount
        return (totalPrice, discountAmount, discountedPrice, roundedTaxAmount, finalPrice)
    }
    
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        let taxAmount = totalPrice * (taxPercent / 100)
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        let finalPrice = totalPrice + taxAmount
        return (roundedTaxAmount, finalPrice)
    }
    
    // MARK: - Time Extension Popup Helper
    
    private func presentAddMoreTimePopUp() {
        let addMoreTimeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        addMoreTimeVC.perHourRate = self.perHourRate ?? 0
        addMoreTimeVC.backAction = { [weak self] str, str2 in
            guard let self = self else { return }
            print(str, str2, "dataReceived")
            self.booking_hours = str
            self.booking_amount = Double(str2) ?? 0.0
            self.DiscountPercentage = Double(self.getUserBookingPropertyArr?.first?.bulkDiscountRate ?? "")
            self.taxPercentage = Double(self.getUserBookingPropertyArr?.first?.tax ?? "")
            self.bookingID = ("\(self.getBookingArr?.first?.bookingID ?? 0)")
            self.hostName = self.getUserBookingPropertyArr?.first?.hostedBy ?? ""
            self.propertyName = self.getUserBookingPropertyArr?.first?.propertyTitle ?? ""
            
            self.propertyRating = self.getUserBookingPropertyArr?.first?.reviewsTotalRating ?? ""
            self.propertyNumberofReview = "(\(self.getUserBookingPropertyArr?.first?.reviewsTotalCount ?? "") reviews)"
            
            let image = self.getUserBookingPropertyArr?.first?.hostProfileImage ?? ""
            let imgURL = AppURL.imageURL + image
            self.profileIMGURL = imgURL
            
            self.StartDatetime = self.getBookingArr?.first?.bookingStart ?? ""
            self.EndDatetime = self.getBookingArr?.first?.finalBookingEnd ?? ""
            self.booking_date = self.getBookingArr?.first?.bookingDate ?? ""
            self.property_id = "\(self.getUserBookingPropertyArr?.first?.propertyID ?? 0)"
            self.parkDesc = "\(self.getUserBookingPropertyArr?.first?.parkingRules ?? "")"
            self.HostingRulesDesc = "\(self.getUserBookingPropertyArr?.first?.hostRules ?? "")"
            
            let cleaningFees = self.getUserBookingPropertyArr?.first?.cleaningFee ?? ""
            if let doubleValue = Double(cleaningFees) {
                self.ClearningFee = doubleValue
                print(self.ClearningFee ?? 0.0, "ClearningFee")
            }
            
            let zyvoServiceFees = self.getUserBookingPropertyArr?.first?.serviceFee ?? ""
            if let doubleValue = Double(zyvoServiceFees) {
                self.zyvoServicePercentage = doubleValue
                self.zyvoServiceFee = ((self.booking_amount ?? 0.0) * doubleValue) / 100.0
                print(self.zyvoServiceFee ?? 0.0, "zyvoServiceFee")
            }
            if let addonPrices = self.getBookingArr?.first?.totalAddonPrice {
                if let doubleValue = Double("\(addonPrices)") {
                    self.AddonOnsPrice = doubleValue
                    print(self.AddonOnsPrice ?? 0, "AddonOnsPrice")
                }
            }
            if let propertySize = self.getUserBookingPropertyArr?.first?.propertySize {
                self.propertyDistanceInMiles = "\(propertySize)"
                print(self.propertyDistanceInMiles, "propertyDistanceInMiles")
            }
            
            let bookingStart = self.getBookingArr?.first?.bookingStart ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = dateFormatter.date(from: bookingStart) {
                dateFormatter.dateFormat = "hh:mm a"
                let formattedTime = dateFormatter.string(from: date)
                self.startTime = formattedTime
                print(formattedTime)
            }
            
            let bookingEnd = self.getBookingArr?.first?.bookingEnd ?? ""
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = dateFormatter.date(from: bookingEnd) {
                dateFormatter.dateFormat = "hh:mm a"
                let formattedTime = dateFormatter.string(from: date)
                self.endTime = formattedTime
                print(formattedTime)
            }
            
            self.addOnsArr = self.getUserBookingPropertyArr?.first?.addOns ?? []
            
            print(self.booking_hours ?? 0, self.booking_amount ?? 0.0, "self.booking_hours,self.booking_amount")
            
            let extraVC = self.storyboard?.instantiateViewController(withIdentifier: "ExtraTimeExtentionVC") as! ExtraTimeExtentionVC
            
            if (self.booking_hours ?? 0) > (self.minBookhours ?? 0) {
                let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                print("================================WithDiscount====================================")
                print("Total Price: \(result.totalPrice)")
                print("Discount Amount (\(String(describing: self.DiscountPercentage))%) : \(result.discountAmount)")
                print("Discounted Price: \(result.discountedPrice)")
                print("Tax Amount (\(String(describing: self.taxPercentage ?? 0.0))%): \(result.taxAmount)")
                self.taxAmount = result.taxAmount
                self.DiscountAmount = result.discountAmount
                print("Final Price: \(result.finalPrice)")
                
            } else {
                let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                print("================================WithoutDiscount====================================")
                print("Tax Amount: \(result.taxAmount)")
                self.taxAmount = result.taxAmount
                self.DiscountAmount = 0.0
                print("Final Price After Tax: \(result.finalPrice)")
            }
            extraVC.awardStatus = self.getBookingArr?.first?.isHostStar ?? false
            extraVC.bookingID = ("\(self.getBookingArr?.first?.bookingID ?? 0)")
            extraVC.startTime = self.startTime
            extraVC.endTime = self.endTime
            extraVC.hostName = self.hostName
            extraVC.propertyDistanceInMiles = self.propertyDistanceInMiles
            extraVC.propertyName = self.propertyName
            extraVC.propertyRating = self.propertyRating
            extraVC.propertyNumberofReview = self.propertyNumberofReview
            extraVC.propertyIMGURL = self.propertyIMGURL
            extraVC.perHourRate = self.perHourRate
            extraVC.booking_start = self.StartDatetime
            extraVC.booking_end = self.EndDatetime
            extraVC.booking_hours = self.booking_hours ?? 0
            extraVC.booking_amount = self.booking_amount
            extraVC.property_id = self.property_id
            extraVC.booking_date = self.booking_date
            extraVC.taxAmount = self.taxAmount
            extraVC.minBookhours = self.minBookhours
            extraVC.DiscountAmount = self.DiscountAmount
            extraVC.ClearningFee = (self.ClearningFee ?? 0.0)
            extraVC.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
            extraVC.AddonOnsPrice = self.AddonOnsPrice ?? 0.0
            extraVC.addOnsArr = self.addOnsArr
            extraVC.arrSelectedArr = self.arrSelectedArr
            extraVC.profileIMGURL = self.profileIMGURL
            extraVC.parkDesc = self.parkDesc
            extraVC.HostingRulesDesc = self.HostingRulesDesc
            extraVC.DiscountPercentage = self.DiscountPercentage
            extraVC.taxPercentage = self.taxPercentage
            extraVC.zyvoServiceFeePercentage = self.zyvoServicePercentage
            
            self.navigationController?.pushViewController(extraVC, animated: true)
        }
        addMoreTimeVC.modalPresentationStyle = .overFullScreen
        self.present(addMoreTimeVC, animated: true)
    }
    
    @IBAction func btnExtratime_Tap(_ sender: UIButton) {
        let isNeedMoreOpenOnce = UserDetail.shared.getisNeedMoreOpenOnce()
        print(isNeedMoreOpenOnce)
        if isNeedMoreOpenOnce == "No" || isNeedMoreOpenOnce == ""  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeedMoreTimePopUpVC") as! NeedMoreTimePopUpVC
            vc.backAction = { [weak self] str in
                guard let self = self else { return }
                if str == "Yes" {
                    UserDetail.shared.setisNeedMoreOpenOnce("No")
                }
                
                print(str,"Data Recieved")
                if str == "Yes" {
                    self.presentAddMoreTimePopUp()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Time"
        shouldFetchHomeData = true
        vc.backAction = { [weak self] str, str1 in
            guard let self = self else { return }
            print(str, str1, "data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    self.lat = devLat
                    self.lng = devLng
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude(self.lat)
                    UserDetail.shared.setAppLongitude(self.lng)
                }
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func btnActivity_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        shouldFetchHomeData = true
        vc.comeFrom = "Activity"
        vc.backAction = { [weak self] str, str1 in
            guard let self = self else { return }
            print(str, str1, "data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    self.lat = devLat
                    self.lng = devLng
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude(self.lat)
                    UserDetail.shared.setAppLongitude(self.lng)
                }
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
    }
    
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.timess = self.timess
        vc.latitude = self.lat
        vc.longitude = self.lng
        vc.backAction = { [weak self] str, str1 in
            guard let self = self else { return }
            print(str, str1, "data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    self.lat = devLat
                    self.lng = devLng
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude(self.lat)
                    UserDetail.shared.setAppLongitude(self.lng)
                }
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.comingFrom = ""
        timer?.invalidate()
        timer = nil
        timer2?.invalidate()
        timer2 = nil
    }
    
    @IBAction func btnshowMap_Tap(_ sender: UIButton) {
        
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.isComingBackFromMap = true
        vc.getHomeDataArr = self.getHomeDataArr ?? []
        
        vc.backActionHomeData = { [weak self] data in

            guard let self = self else { return }

            self.isComingBackFromMap = true

            if let data = data {
                self.getHomeDataArr = data
                self.collecV.reloadData()
            }
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 14.0, *)
extension DiscoverVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(getHomeDataArr?.count ?? 0,"DATA Result count")
        return getHomeDataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = getHomeDataArr?[indexPath.item]
        cell.view_Instant.isHidden = true
        cell.btnCross.isHidden = true
        let isInstantBookStatus =  data?.isInstantBook ?? 0
        if isInstantBookStatus == 0 {
            cell.view_Instant.isHidden = true
        } else {
            cell.view_Instant.isHidden = false
        }
        cell.lbl_NameHostedBy.text = data?.hostName ?? ""
        cell.lbl_AddressHostedby.text = data?.hostAddress ?? ""
        let hostProfileImgUrl = data?.hostProfileImageUrl ?? ""
       
        let imgURL = AppURL.imageURL + hostProfileImgUrl
        cell.imgHostedBy.loadImage(from:imgURL,placeholder: UIImage(named: ""))
        cell.lbl_name.numberOfLines = 0
        cell.lbl_name.lineBreakMode = .byWordWrapping
        cell.lbl_name.text = data?.title ?? ""
      
        var hour = data?.hourlyRate ?? ""
        let price = hour.formattedPriceString()
        if price != "" {
            cell.lbl_Time.text = "$\(price)/h"
        } else {
            cell.lbl_Time.text = ""
        }
        
        let imgbookingStar = data?.isStarHost ?? false
        if imgbookingStar == false {
            cell.imgBookMark.isHidden = true
        }else {
            cell.imgBookMark.isHidden = false
        }
        
        cell.imgArr = data?.images ?? []
        let imagesCount = data?.images?.count ?? 0
        if imagesCount == 1{
            cell.pageV.isHidden = true
        }else{
            cell.pageV.isHidden = false   // <-- add this
            cell.pageV.currentPage = 0
            cell.pageV.numberOfPages = data?.images?.count ?? 0
        }
        
        cell.CollecV.reloadData()
        let reviewCount = data?.reviewCount ?? "(0)"
        cell.lbl_NumberOfUser.text = reviewCount > "(0)" ? "(\(reviewCount))" : "(0)"
        let rating = data?.rating ?? "(0.0)"
        if rating != "(0.0)" {
            cell.lbl_Rating.text = rating.formattedToDecimal()
        } else {
            cell.lbl_Rating.text = "0.0"
        }
        let heartStatus = data?.isInWishlist ?? 0
        let distanceInMiles = data?.distanceMiles ?? "0"
        cell.lbl_Distance.text = "\(distanceInMiles) miles away"
        if heartStatus == 0 {
            cell.btnHeart.setImage(UIImage(named: "hearticons"), for: .normal)
        } else {
            cell.btnHeart.setImage(UIImage(named: "day"), for: .normal)
        }
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btnInstantBook.tag = indexPath.row
        cell.btnInstantBook.addTarget(self, action: #selector(btnInstantBook(_:)), for: .touchUpInside)
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            if let mainTabVC = self.tabBarController as? MainTabVC {
                mainTabVC.progressBar?.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                shouldFetchHomeData = true
                vc.propertyDistanceInMiles = data?.distanceMiles ?? ""
                vc.backAction = { [weak self, weak mainTabVC] str in
                    if str == "Ravi" {
                        mainTabVC?.progressBar?.isHidden = false
                    }
                    self?.viewModel.apiforGetHomeData()
                }
                vc.propertyID = "\(data?.propertyID ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Heloo")
        guard let getHomeDataArr = getHomeDataArr, indexPath.item < getHomeDataArr.count else { return }
        let data = getHomeDataArr[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.hidesBottomBarWhenPushed = true
        vc.propertyID = "\(data.propertyID ?? 0)"
        vc.propertyDistanceInMiles = data.distanceMiles ?? ""
        vc.backAction = { [weak self] str in
            self?.viewModel.apiforGetHomeData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnInstantBook(_ sender: UIButton) {
        guard let getHomeDataArr = getHomeDataArr, sender.tag < getHomeDataArr.count else { return }
        let data = getHomeDataArr[sender.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.propertyID = "\(data.propertyID ?? 0)"
        vc.propertyDistanceInMiles = data.distanceMiles ?? ""
        vc.backAction = { [weak self] str in
            self?.viewModel.apiforGetHomeData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let getHomeDataArr = getHomeDataArr, sender.tag < getHomeDataArr.count else { return }
        
        
        //fatalError("Crash was triggered")
        
        
        let data = getHomeDataArr[sender.tag]
        let heartStatus = data.isInWishlist ?? 0
        let propertyIDString = "\(data.propertyID ?? 0)"
        
        if heartStatus == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToWishListPopUpVC") as! AddToWishListPopUpVC
            vc.modalPresentationStyle = .overFullScreen
            vc.propertyID = propertyIDString
            vc.backAction = { [weak self] str in
                guard let self = self else { return }
                print(str, "Data Recieved")
                if str == "SaveItemInWishlist" {
                    self.viewModel.apiforGetHomeData()
                }
                if str == "Ravi" {
                    let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateWishListVC") as! CreateWishListVC
                    createVC.propertyID = propertyIDString
                    createVC.backAction = { [weak self] str in
                        guard let self = self else { return }
                        print(str, "Created")
                        self.viewModel.apiforGetHomeData()
                    }
                    self.present(createVC, animated: false)
                }
            }
            self.present(vc, animated: false)
        } else {
            print("Remove From wishlist")
            self.viewModel.apiforRemoveFromWishlist(propertyID: propertyIDString)
        }
    }
    
      func setupProgressView() {
          
          progressView = CustomArcProgressView()
          progressView.translatesAutoresizingMaskIntoConstraints = false   // ✅ MUST
          
          view_RemainingTime.addSubview(progressView)
          
          NSLayoutConstraint.activate([
              progressView.leadingAnchor.constraint(equalTo: view_RemainingTime.leadingAnchor),
              progressView.trailingAnchor.constraint(equalTo: view_RemainingTime.trailingAnchor),
              progressView.topAnchor.constraint(equalTo: view_RemainingTime.topAnchor),
              progressView.bottomAnchor.constraint(equalTo: view_RemainingTime.bottomAnchor)
          ])
      }
      
      // MARK: - Secondary Timer Methods
      
      func startTimer() {
          timer2?.invalidate()
          
          timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
              guard let self = self else { return }
              if self.remainingTime > 0 {
                  self.remainingTime -= 1
                  let progress = 1 - (self.remainingTime / self.totalDuration)
                  
                  DispatchQueue.main.async {
                      self.progressView.setProgress(CGFloat(progress))
                  }
                  
                  self.updateTimeLabel()
              } else {
                  self.timer2?.invalidate()
                  self.timer2 = nil
              }
          }
          
          if let t2 = timer2 {
              RunLoop.current.add(t2, forMode: .common)
          }
      }
      
      // MARK: - Time Label
      func updateTimeLabel() {
          let totalSec = Int(remainingTime)
          let hours = totalSec / 3600
          let minutes = (totalSec % 3600) / 60
          let seconds = totalSec % 60
          
          print("\(hours)h \(minutes)m \(seconds)s")
          
          lbl_hours.text = "\(hours)"
          lbl_minutes.text = "\(minutes)"
          lbl_seconds.text = "\(seconds)"
          
          let isNeedMoreOpenOnce = UserDetail.shared.getisNeedMoreOpenOnce()
          if hours == 0, minutes <= 30, seconds == 0 {
              let isTimeExtend = UserDetail.shared.getisTimeExtend()
              if isNeedMoreOpenOnce != "No" {
                  if isTimeExtend == "No" {
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeedMoreTimePopUpVC") as! NeedMoreTimePopUpVC
                      vc.backAction = { [weak self] str in
                          guard let self = self else { return }
                          print(str, "Data Recieved")
                          
                          if str == "Yes" {
                              self.presentAddMoreTimePopUp()
                          }
                          if str == "No" {
                              UserDetail.shared.setisNeedMoreOpenOnce("No")
                          }
                      }
                      vc.modalPresentationStyle = .overFullScreen
                      self.present(vc, animated: true)
                  }
              }
          }
      }
}

@available(iOS 14.0, *)
extension DiscoverVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 1 cell per row
        
        let titleText = getHomeDataArr?[indexPath.item].title ?? ""
        let font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let availableWidth = max(100, cellWidth - 110)
        
        let titleBoundingRect = (titleText as NSString).boundingRect(
            with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        let isMultiLine = ceil(titleBoundingRect.height) > 24
        let cellHeight: CGFloat = isMultiLine ? 410 : 390
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension DiscoverVC {
    func bindVC() {
        viewModel.$chatTokenModelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    let chatToken = response.data?.token ?? ""
                    UserDefaults.standard.set(chatToken, forKey:"twilioToken")
                    print(chatToken,"chatToken")
                    UserDetail.shared.setChatToken(chatToken)
                })
            }.store(in: &cancellables)
        
        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.getHomeDataArr?.removeAll()
                    if response.success ?? false {
                        self.getHomeDataArr = response.data
                        if self.getHomeDataArr?.count == 0 || self.getHomeDataArr == nil {
                            self.collecV.setEmptyView(message: response.message ?? "No properties found for your location")
                        } else {
                            self.collecV.restore()
                        }
                    } else {
                        self.getHomeDataArr = []
                        self.collecV.setEmptyView(message: response.message ?? "No properties found for your location")
                    }
                    print(self.getHomeDataArr ?? [], "HOME DATA YAHI HAI")
                    self.collecV.reloadData()
                    
                case .failure(let error):
                    self.getHomeDataArr = []
                    self.collecV.setEmptyView(message: error.localizedDescription)
                    self.collecV.reloadData()
                    
                case .none:
                    break
                }
            }.store(in: &cancellables)

        
        viewModel.$getWishlistRemoveResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.viewModel.apiforGetHomeData()
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$getUserBookingResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        DispatchQueue.main.async {
                            self.getUserBooking = response.data
                            self.getUserBookingPropertyArr = self.getUserBooking?.properties
                            self.getBookingArr = self.getUserBooking?.bookings
                            
                            if let minBookhours = self.getUserBookingPropertyArr?.first?.minBookingHours,
                               let minBookhoursInt = Double(minBookhours) {
                                print("minBookhoursInt : \(minBookhoursInt)")
                                self.minBookhours = Int(minBookhoursInt)
                            } else {
                                print("Invalid hourly rate")
                            }
                            
                            if let hourlyRateString = self.getUserBookingPropertyArr?.first?.hourlyRate,
                               let hourlyRateInt = Double(hourlyRateString) {
                                print("Hourly Rate: \(hourlyRateInt)")
                                self.perHourRate = Int(hourlyRateInt)
                            } else {
                                print("Invalid hourly rate")
                            }
                     
                            if let bookingStartTimeStr = self.getUserBooking?.bookings?.first?.bookingStart,
                               let bookingEndTimeStr = self.getUserBooking?.bookings?.first?.finalBookingEnd {
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.timeZone = TimeZone.current
                                
                                print(bookingStartTimeStr, "booking Start time")
                                print(bookingEndTimeStr, "booking End time")
                                
                                if let bookingStartTime = dateFormatter.date(from: bookingStartTimeStr),
                                   let bookingEndTime = dateFormatter.date(from: bookingEndTimeStr) {
                                    
                                    let currentTime = Date()
                                    
                                    // ✅ CASE 1: Booking already ended
                                    if currentTime >= bookingEndTime {
                                        self.progressView.setProgress(1.0, animated: false)
                                        
                                        self.btnShowMap.isHidden = false
                                        self.btnShowMapH_Constant.constant = 35
                                        self.view_RemainingTime.isHidden = true
                                        self.stackV_TimeLeft.isHidden = true
                                        
                                        print("Booking time has already ended.")
                                        return
                                    }
                                    
                                    // CASE 2: Booking not started yet
                                    let effectiveCurrentTime = max(currentTime, bookingStartTime)
                                    
                                    // TOTAL duration (start → end)
                                    let totalDuration = bookingEndTime.timeIntervalSince(bookingStartTime)
                                    
                                    //  ELAPSED time (start → current)
                                    let elapsedTime = max(0, effectiveCurrentTime.timeIntervalSince(bookingStartTime))
                                    
                                    // REMAINING time (current → end)
                                    let remainingTime = bookingEndTime.timeIntervalSince(effectiveCurrentTime)
                                    
                                    print("Total:", totalDuration)
                                    print("Elapsed:", elapsedTime)
                                    print("Remaining:", remainingTime)
                                    
                                    //  Assign
                                    self.totalDuration = totalDuration
                                    self.remainingTime = remainingTime
                                    
                                    //  INITIAL PROGRESS (IMPORTANT 🔥)
                                    let progress = elapsedTime / totalDuration
                                    
                                    self.progressView.setInitialProgress(CGFloat(progress))
                                    
                                    //  START TIMER
                                    self.startTimer()
                                    
                                    //  UI SHOW
                                    UserDetail.shared.setisTimeExtend("No")
                                    self.btnShowMap.isHidden = false
                                    self.btnShowMapH_Constant.constant = 150
                                    self.view_RemainingTime.isHidden = false
                                    self.stackV_TimeLeft.isHidden = false
                                    
                                    CurrentDateTimer.shared.stopTimer()
                                } else {
                                    print("Invalid date format")
                                }
                            }
                        }
                    } else {
                        self.btnShowMap.isHidden = false
                        self.btnShowMapH_Constant.constant = 35
                        self.view_RemainingTime.isHidden = true
                        self.stackV_TimeLeft.isHidden = true
                    }
                })
            }.store(in: &cancellables)
    }
    
    func calculateTimeComponents(from timeInterval: TimeInterval) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return (hours, minutes, seconds)
    }
}
