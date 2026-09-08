//
//  HomeVCWithoutLoginVC.swift
//  Zyvo
//
//  Created by ravi on 11/10/24.
//

import UIKit
import Combine
import CoreLocation

class HomeVCWithoutLoginVC: UIViewController,LocationPickerDelegate {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Where: UILabel!
    @IBOutlet weak var lbl_Activity: UILabel!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Search: UIView!
    var isComingBackFromMap = false
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    var getHomeDataArr : [HomeDataModel]?
    
    var comingFrom = ""
    var timess: String = ""
    var shouldFetchHomeData = true
    var lat = ""
    var lng = ""
    
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(reloadHomeData),
               name: NSNotification.Name("ReloadHomeData"),
               object: nil
           )
        
        LocationPicker.shared.delegate = self
       // LocationPicker.shared.checkLocationPermission()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        bindVC()
       
        lbl_time.font = UIFont(name: "Poppins-Medium", size: 15)
        lbl_Where.font = UIFont(name: "Poppins-Medium", size: 15)
        lbl_Activity.font = UIFont(name: "Poppins-Medium", size: 15)
        let userID = UserDetail.shared.getUserId()
        let isProfileCompleted = UserDetail.shared.getisCompleteProfile()
        let isKeepMeLogin = UserDetail.shared.getKeepMeLogin()
        let fullName = UserDetail.shared.getName()
        print(isKeepMeLogin,"isKeepMeLogin")
        print(isProfileCompleted,fullName,isKeepMeLogin, "HomeVCWithoutLoginVC")
        if isKeepMeLogin == "Yes" {
        if userID != "" {
                if isProfileCompleted == "" || isProfileCompleted == "false" {
                    let stryB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stryB.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
                    vc.fullName = fullName
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    let logintype =  UserDetail.shared.getlogintType()
                    if logintype == "Host" {
                        let stryB = UIStoryboard(name: "Host", bundle: nil)
                        let vc = stryB.instantiateViewController(withIdentifier: "HostMyTabVC") as! HostMyTabVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                        self.navigationController?.pushViewController(vc, animated: false) }
                }
            } else {
                if isProfileCompleted == "" || isProfileCompleted == "false" {
                    let stryB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stryB.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
                    vc.fullName = fullName
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    let logintype =  UserDetail.shared.getlogintType()
                    if logintype == "Host" {
                        let stryB = UIStoryboard(name: "Host", bundle: nil)
                        let vc = stryB.instantiateViewController(withIdentifier: "HostMyTabVC") as! HostMyTabVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }  else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                        self.navigationController?.pushViewController(vc, animated: false) }
                }
            }
        }
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        
        let nib2 = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self
        
    }
    
    @objc func reloadHomeData() {

        self.getHomeDataArr = []
        self.collecV.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        checkLocationFlow()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationPicker.shared.delegate = self
        self.tabBarController?.tabBar.isHidden = false
        shouldFetchHomeData = true
        
        if isComingBackFromMap {
            isComingBackFromMap = false
            return
        }
        
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
    
    
    @objc func appDidBecomeActive() {
        // When the app returns from settings, check location again
  
        checkLocationFlow()
        
        print(latitude ?? 0.0,"latitude")
        print(longitude ?? 0.0,"longitude")
        
        UserDetail.shared.setAppLatitude("\(latitude ?? 0.0)")
        UserDetail.shared.setAppLongitude("\(longitude ?? 0.0)")
//        if canCallAPI(),
//             let lat = latitude, let lng = longitude {
//              
//             // viewModel.apiforGetHomeData()
//          }
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
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }

                    case .permissionRequired:
                        LocationPicker.shared.delegate = self
                        LocationPicker.shared.requestLocationAccess()
                        
                    }
                }
            }
        }
        
        vc.onSkip = { [weak self] in
            guard let self = self else { return }
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
    
   
    // MARK: - LocationManagerHelperDelegate Methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
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
        
        let errorCode = (error as NSError).code
        
        if errorCode == 0 {
            // Device location OFF
            presentLocationPopup(type: .deviceOff)
            
        } else {
            // Permission denied
            presentLocationPopup(type: .permissionDenied)
        }
    }
    
    @IBAction func btnShowMap_Tapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
         
        self.tabBarController?.tabBar.isHidden = true
        
        vc.comingFrom = "WithoutLogin"
        
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
    
    
    @IBAction func btnWhereTap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        // vc.timess = self.timess
        shouldFetchHomeData = true
        vc.comeFrom = "Where"
        vc.latitude = self.lat
        vc.longitude = self.lng
       
        vc.backAction = { str, str1 in
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
            }
            else {
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
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        shouldFetchHomeData = true
        //vc.timess = self.timess
        vc.comeFrom = "Time"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
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
        //        vc.timess = self.timess
        shouldFetchHomeData = true
        vc.comeFrom = "Activity"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
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
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
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
    @IBAction func btnLogin_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        shouldFetchHomeData = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
extension HomeVCWithoutLoginVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getHomeDataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = getHomeDataArr?[indexPath.item]
        cell.view_Instant.isHidden = true
        cell.btnCross.isHidden = true
        
        cell.lbl_NameHostedBy.text = (data?.hostName ?? "").abbreviatedHostName
        cell.lbl_AddressHostedby.text = data?.hostAddress ?? ""
        let hostProfileImgUrl = data?.hostProfileImageUrl ?? ""
       
        let imgURL = AppURL.imageURL + hostProfileImgUrl
        cell.imgHostedBy.loadImage(from:imgURL,placeholder: UIImage(named: ""))
        
      //  let imgbookingStar = data?.isStarHost ?? false
        
        
        let imgbookingStar = data?.isStarHost ?? false
        if imgbookingStar == false {
            cell.imgBookMark.isHidden = true
        }else {
            cell.imgBookMark.isHidden = false
        }
       
        let isInstantBookStatus =  data?.isInstantBook ?? 0
        
        if isInstantBookStatus == 0 {
            cell.view_Instant.isHidden = true
        } else {
            cell.view_Instant.isHidden = false
        }
      
        cell.lbl_name.numberOfLines = 0
        cell.lbl_name.lineBreakMode = .byWordWrapping
        cell.lbl_name.text = data?.title ?? ""
        let hour = data?.hourlyRate ?? ""
        let price = hour.formattedPriceString()
        if price != "" {
            cell.lbl_Time.text = "$\(price)/h"
        } else {
            cell.lbl_Time.text = ""
        }
       
        let reviewCount = data?.reviewCount ?? "(0)"
        cell.lbl_NumberOfUser.text = reviewCount > "(0)" ? "(\(reviewCount))" : "(0)"
        let rating = data?.rating ?? "(0.0)"
        if rating != "(0.0)" {
            cell.lbl_Rating.text = rating.formattedToDecimal()
        } else {
            cell.lbl_Rating.text = "0.0"
        }
        
        let distanceInMiles = data?.distanceMiles ?? "0"
        cell.lbl_Distance.text = "\(distanceInMiles) miles away"
        cell.imgArr = data?.images ?? []
        let imagesCount = data?.images?.count ?? 0
        if imagesCount == 1{
            cell.pageV.isHidden = true
        }else{
            cell.pageV.isHidden = false   // <-- add this
            cell.pageV.currentPage = 0
            cell.pageV.numberOfPages = data?.images?.count ?? 0
        }
//        cell.pageV.currentPage = 0
//        cell.pageV.numberOfPages = data?.images?.count ?? 0
        cell.CollecV.reloadData()
        
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        cell.btnInstantBook.tag = indexPath.row
        cell.btnInstantBook.addTarget(self, action: #selector(InstantBook(_:)), for: .touchUpInside)
        cell.btnCross.isHidden = true
      
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            vc.propertyID = "\(data?.propertyID ?? 0)"
            vc.comingFrom = "WithoutLogin"
            shouldFetchHomeData = true
            vc.backAction = { [weak self] str in
                self?.viewModel.apiforGetHomeData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
         
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func InstantBook(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension HomeVCWithoutLoginVC:UICollectionViewDelegateFlowLayout {
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

extension HomeVCWithoutLoginVC {
    func bindVC() {

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
                    print(self.getHomeDataArr ?? [], "HOME DATA")
                    self.collecV.reloadData()
                    
                case .failure(let error):
                    self.getHomeDataArr = []
                    self.collecV.setEmptyView(message: error.localizedDescription)
                    self.collecV.reloadData()
                    
                case .none:
                    break
                }
            }.store(in: &cancellables)

    }
}
