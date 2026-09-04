//
//  HostPropertiesHomeVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import DropDown
import Combine
import CoreLocation

class HostPropertiesHomeVC: UIViewController, UIPopoverPresentationControllerDelegate, LocationPickerDelegate {
 
   
    

    @IBOutlet weak var view_Balance: UIView!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var collecV_H: NSLayoutConstraint!
    @IBOutlet weak var earningAmountLbl: UILabel!
    @IBOutlet weak var view_CollectionContainer: UIView!
    @IBOutlet weak var view_AddNewPlace: UIView!
    @IBOutlet weak var scrollView_Main: UIScrollView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    let filterDropdown = DropDown()
    var type = "total"
    var filtersArr = ["   Total earning","   Future earning"]
    private var cancellables = Set<AnyCancellable>()
    private var EarningViewModel = HostEarningViewModel()
    private var viewModel = PropertyListViewModel()
    var propertyDataArr = [PropertyListModel]()
    let dotDropdown = DropDown()
    var dotArr = ["     Edit","     Delete"]
    var lat : Double?
    var lot : Double?
    var shouldFetchPropertyData = true
    var hasPaymentMethod: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        LocationPicker.shared.delegate = self
        bindVC_ForEarningData()
        view_Balance.layer.cornerRadius = view_Balance.layer.frame.height / 2
        view_Balance.layer.borderWidth = 1
        view_Balance.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        let nib2 = UINib(nibName: "PlaceCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "PlaceCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shouldFetchPropertyData = true
        EarningViewModel.getHostEarning(type: self.type, hostID: UserDetail.shared.getUserId())
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        checkLocationFlow()
    }
    
    
    func canCallAPI() -> Bool {
        return CLLocationManager.locationServicesEnabled() &&
               (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways)
    }
    
    
    func checkLocationFlow() {
        // ✅ Device OFF
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
    
    
//    @objc func appDidBecomeActive() {
//        // When the app returns from settings, check location again
//       // LocationPicker.shared.checkLocationPermission()
//      //  shouldFetchHomeData = true   // IMPORTANT
//        self.getHomeDataArr = []
//        self.collecV.reloadData()
//        checkLocationFlow()
//        
//        if canCallAPI(),
//             let lat = latitude, let lng = longitude {
//              
//            viewModel.apiforGetAllPropertyData(lat: lat, lot: lot)
//          }
//    }
    
    func presentLocationPopup(type: LocationPopupType) {
        
        // Prevent multiple popups
        if presentedViewController is LocationPopUPVC { return }
        
        let sb = UIStoryboard(name: "Main", bundle: nil) // 👈 your storyboard name
        let vc = sb.instantiateViewController(withIdentifier: "LocationPopUPVC") as! LocationPopUPVC
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
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }

                    case .permissionRequired:
                        LocationPicker.shared.delegate = self
                        LocationPicker.shared.requestLocationAccess()
                        
                    }
                }
            }
        }
        
        vc.onSkip = {
            // Optional
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
    
    func didFailWithError(error: Error) {
        
        let errorCode = (error as NSError).code
        
        if errorCode == 0 {
            // Device location OFF
            presentLocationPopup(type: .deviceOff)
            
        } else {
            // Permission denied
            presentLocationPopup(type: .permissionDenied)
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateAddNewPlaceLayout()
    }
    
    private func updateAddNewPlaceLayout() {
        scrollView_Main?.layoutIfNeeded()
        if propertyDataArr.isEmpty {
            view_CollectionContainer?.isHidden = true
            collecV_H?.constant = 0
            let availableHeight = (scrollView_Main?.bounds.height ?? 0) > 0 ? (scrollView_Main?.bounds.height ?? 0) : (self.view.bounds.height - 250)
            let centerOffset = max(10, (availableHeight - 220) / 2 - 20)
            stackViewTopConstraint?.constant = centerOffset
        } else {
            view_CollectionContainer?.isHidden = false
            stackViewTopConstraint?.constant = 10
            updateCollectionViewHeight()
        }
    }
    
    
    
    private func updateCollectionViewHeight() {
        // Calculate the number of rows needed
        let numberOfItems = collectionView(collecV, numberOfItemsInSection: 0)
        guard numberOfItems > 0 else {
            collecV_H.constant = 0
            return
        }
        let itemsPerRow: CGFloat = 1
        let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        // Set the item height and spacing
        let itemHeight: CGFloat = 380
        let padding: CGFloat = 0
        let totalPadding = (rows - 1) * padding
        let totalHeight = rows * itemHeight + totalPadding
        // Update the collection view height constraint
        collecV_H.constant = totalHeight
    }
    
    @IBAction func btnInfo(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Future Earnings-\nTotal earnings - This is calculated by aggregating all earnings since the host signed up on Zyvo till the date shown (Dynamic Real Time Updates is expected)\nFuture Earnings - This filter dynamically calculates and updates the amount shown to reflect the total revenue that hosts are expected to earn from existing future bookings over the next 90 days. It provides hosts with a real-time snapshot of their anticipated earnings from confirmed bookings during the specified timeframe.\n\nNote: This filter's content is dynamic and adjusts in real-time as new bookings are confirmed or existing bookings are modified within the 90-day window.\n- Hosts can view changes to their future earnings and associated properties as bookings are added, updated, or canceled, providing them with an up-to-date overview of their upcoming revenue stream."
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .up // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 350, height: 300)
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnAddNewPlace_Tap(_ sender: UIButton) {
//        if !hasPaymentMethod {
//            presentPayoutSetupPopup()
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
        SingltonClass.shared.selfCheck_in =    "0"
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
        SingltonClass.shared.miniHrsPric_HrsMini = "2"
        SingltonClass.shared.miniHrsPric_perHrs = "10"
        SingltonClass.shared.bulkDis_HrsMini = "2"
        SingltonClass.shared.bulkDis_Discount = "15"
        SingltonClass.shared.addCleaningFees = ""
        SingltonClass.shared.avilabilityMonth = ["all"]
        SingltonClass.shared.avilabilityDays = "all"
        SingltonClass.shared.avilabilityHrsFrom = ""
        SingltonClass.shared.avilabilityHrsTo = ""
        SingltonClass.shared.addOns.removeAll()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnfilter_Tap(_ sender: UIButton) {
        // Set up the dropdown
        filterDropdown.anchorView = sender // Anchor dropdown to the button
        filterDropdown.dataSource = filtersArr
        filterDropdown.direction = .bottom
        
        filterDropdown.backgroundColor = UIColor.white
        filterDropdown.cornerRadius = 10
        filterDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        filterDropdown.layer.shadowColor = UIColor.gray.cgColor
        filterDropdown.layer.shadowOpacity = 0.2
        filterDropdown.layer.shadowRadius = 10
        filterDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = filterDropdown.anchorView?.plainView.bounds.height {
            filterDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        filterDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        filterDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            if index == 0{
                self.type = "total"
            }else{
                self.type = "future"
            }
            EarningViewModel.getHostEarning(type: self.type, hostID: UserDetail.shared.getUserId())
            // Perform any further actions as needed
        }
        // Show dropdown
        filterDropdown.show()
    }
}
extension HostPropertiesHomeVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propertyDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.hostedByLbl.text = "Hosted by \(propertyDataArr[indexPath.item].fname ?? "") \(propertyDataArr[indexPath.item].lname ?? "")"
        cell.addressLbl.text = propertyDataArr[indexPath.item].address
        let imgURL = AppURL.imageURL + (propertyDataArr[indexPath.row].profileImage ?? "")
        cell.HostedByImg.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
        cell.titleLbl.numberOfLines = 0
        cell.titleLbl.lineBreakMode = .byWordWrapping
        cell.titleLbl.text = propertyDataArr[indexPath.item].title
        cell.milesLbl.text = "\(propertyDataArr[indexPath.item].distanceMiles ?? "") miles away"
        cell.totalRatingCount.text = "(\(propertyDataArr[indexPath.item].propertyReviewCount ?? ""))"
        
       // cell.ratingLbl.text = propertyDataArr[indexPath.item].propertyRating
        if let rating = Double(propertyDataArr[indexPath.item].propertyRating ?? "") {
            cell.ratingLbl.text = String(format: "%.1f", rating)
        } else {
            cell.ratingLbl.text = "0.0"
        }
        
        let stringNumber = propertyDataArr[indexPath.item].hourlyRate ?? ""
        if let doubleValue = Double(stringNumber) {
            let intValue = Int(doubleValue)
            let result = String(intValue)
            cell.pricePerHourLbl.text = "$\(result)/h"
        }
        
        cell.btnDot.tag = indexPath.row
        cell.imgArr = propertyDataArr[indexPath.item].propertyImages ?? []
        cell.collecV.reloadData()
        
        if propertyDataArr[indexPath.item].isInstantBook == 1 {
            cell.view_Instant.isHidden = false
        }else {
            cell.view_Instant.isHidden = true
        }
        
        //        cell.btnHeart.tag = indexPath.row
        cell.btnDot.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            // Example: Navigate to a new view controller
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewListingVC") as! CreateNewListingVC
            vc.propertyID = self.propertyDataArr[indexPath.item].propertyID
            vc.lat = self.lat
            vc.lot = self.lot
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Heloo")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewListingVC") as! CreateNewListingVC
        vc.propertyID = self.propertyDataArr[indexPath.item].propertyID
        vc.lat = self.lat
        vc.lot = self.lot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = dotArr
        dotDropdown.direction = .bottom
        
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Set the width of the dropdown
        if let anchorView = dotDropdown.anchorView?.plainView {
            dotDropdown.width = anchorView.frame.width + 60// Match the width of the anchor view
        }
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -80, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dotDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected: \(item)")
            var iselect = "\(item)"
            if index == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeletePropertyVC") as! DeletePropertyVC
                vc.propertyId = propertyDataArr[sender.tag].propertyID ?? 0
                vc.backAction = { str in
                if str == "Yes" {
                    self.propertyDataArr.remove(at: sender.tag)
                    self.collecV.reloadData()
                    }
                }
                
                self.navigationController?.present(vc, animated: true)
            }else{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HostPlaceMngmntVC") as! HostPlaceMngmntVC
                nextVC.comesFrom = "edit"
                nextVC.propertyId = propertyDataArr[sender.tag].propertyID ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            // Perform any further actions as needed
        }
        // Show dropdown
        dotDropdown.show()
    }
}

extension HostPropertiesHomeVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 1 cell per row
        
        // Return the size with fixed height
        return CGSize(width: cellWidth, height: 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HostPropertiesHomeVC {
 func bindVC() {
        viewModel.$getPropertyListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                     if let hasPayment = response.hasPaymentMethod {
                         self.hasPaymentMethod = hasPayment
                     }
                     self.propertyDataArr.removeAll()
                     self.propertyDataArr = response.data ?? []
                     print(self.propertyDataArr,"HOME DATA")
                     self.collecV.reloadData()
                     self.updateAddNewPlaceLayout()
                })
            }.store(in: &cancellables)
    }
    
    func presentPayoutSetupPopup() {
        let popupVC = PayoutSetupPopupVC()
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.onOkay = { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 3
        }
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func bindVC_ForEarningData() {
        EarningViewModel.$getEarningsResult
               .receive(on: DispatchQueue.main)
               .sink { [weak self] result in
                   guard let self = self else{return}
                   result?.handle(success: { response in
                       let data = response.data
                       self.earningAmountLbl.text = "$\(data?.amount ?? "")"
                   })
               }.store(in: &cancellables)
       }
  }

extension HostPropertiesHomeVC: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        func didUpdateLocation(latitude: Double, longitude: Double) {
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            self.lat = latitude
            self.lot = longitude
            
            UserDetail.shared.setAppLatitude( "\(self.lat ?? 0.0)")
            UserDetail.shared.setAppLongitude( "\(self.lot ?? 0.0)")
            if shouldFetchPropertyData {
                shouldFetchPropertyData = false
                viewModel.apiforGetAllPropertyData(lat: latitude, lot: longitude)
            }
        //}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

// MARK: - Payout Setup Requirement Popup VC
class PayoutSetupPopupVC: UIViewController {
    
    var onOkay: (() -> Void)?
    
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
    
    private let closeButton: UIButton = {
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
    
    private let okayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Go to Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1.0)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let bgTap = UITapGestureRecognizer(target: self, action: #selector(bgTapped))
        bgTap.cancelsTouchesInView = false
        view.addGestureRecognizer(bgTap)
        
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(separatorView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(okayButton)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        okayButton.addTarget(self, action: #selector(okayTapped), for: .touchUpInside)
        
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
            
            okayButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 28),
            okayButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            okayButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            okayButton.heightAnchor.constraint(equalToConstant: 48),
            okayButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func bgTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    @objc private func okayTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onOkay?()
        }
    }
}

