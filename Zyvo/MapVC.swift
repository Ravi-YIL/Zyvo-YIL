//
//  MapVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//
//

import UIKit
import GoogleMaps
import CoreLocation
import Combine

class MapVC: UIViewController,GMSMapViewDelegate,LocationPickerDelegate {
    
    var backActionHomeData:(([HomeDataModel]?) -> Void)?
    
    var backAction:(_ str : String ) -> () = { str in}
    var onBack: (() -> Void)?
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var mapV: GMSMapView!
    private var lastMarkerDataCount: Int = 0
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    var comingFrom = ""
    private var locationFetched = false
    private var markerMap: [String: GMSMarker] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    
    var getHomeDataArr : [HomeDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let styleJSON = """
        [
          {
            "elementType": "labels",
            "stylers": [
              { "visibility": "On" }
            ]
          }
        ]
        """

        do {
            mapV.mapStyle = try GMSMapStyle(jsonString: styleJSON)
        } catch {
            print(error)
        }
        
        if #available(iOS 14.0, *) {
            bindVC()
        } else {
            // Fallback on earlier versions
        }
        
        LocationPicker.shared.delegate = self
//        LocationPicker.shared.checkLocationPermission()
//        checkLocationFlow()
        
        self.mapV.delegate = self
        
        let savedLatStr = UserDetail.shared.getAppLatitude()
        let savedLngStr = UserDetail.shared.getAppLongitude()
        if let savedLat = Double(savedLatStr), let savedLng = Double(savedLngStr), savedLat != 0.0, savedLng != 0.0 {
            self.latitude = savedLat
            self.longitude = savedLng
            let camera = GMSCameraPosition.camera(withLatitude: savedLat, longitude: savedLng, zoom: 15.0)
            self.mapV.camera = camera
            self.viewModel.apiforGetHomeData()
        } else {
            UserDetail.shared.setAppLatitude("0.0")
            UserDetail.shared.setAppLongitude("0.0")
            self.latitude = 0.0
            self.longitude = 0.0
            self.viewModel.apiforGetHomeData()
        }
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func appDidBecomeActive() {
        // When the app returns from settings, check location again
       // LocationPicker.shared.checkLocationPermission()
       // checkLocationFlow()
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
    
    
    func presentLocationPopup(type: LocationPopupType) {
        
        // Prevent multiple popups
        if presentedViewController is LocationPopUPVC { return }
        
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
        
        vc.onSkip = {
            
            UserDetail.shared.setAppLatitude("0.0")
            UserDetail.shared.setAppLongitude("0.0")
            
            self.latitude = 0.0
            self.longitude = 0.0
            self.viewModel.latitude = "0.0"
            self.viewModel.longitude = "0.0"
            
            self.viewModel.apiforGetHomeData()
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
    
    //  MARK: - LocationManagerHelperDelegate Methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        if locationFetched { return }
        locationFetched = true

        self.latitude = latitude
        self.longitude = longitude
        
        print(self.latitude ?? 0.0,"self.latitude")
        print(self.longitude ?? 0.0,"longitude")
        
        let customlat = UserDetail.shared.getAppLatitude()
        let customlong = UserDetail.shared.getAppLongitude()
        
        // Save actual device GPS location
        UserDetail.shared.setDeviceLatitude("\(latitude)")
        UserDetail.shared.setDeviceLongitude("\(longitude)")
        
        if customlat == "" || customlong == "" || customlat == "0.0" || customlong == "0.0" || customlat == "0" || customlong == "0" {
            UserDetail.shared.setAppLatitude("\(self.latitude ?? 0.0)")
            UserDetail.shared.setAppLongitude("\(self.longitude ?? 0.0)")
        }
        else {
            if let customLatDouble = Double(customlat), let customLngDouble = Double(customlong) {
                self.latitude = customLatDouble
                self.longitude = customLngDouble
            }
        }

        if self.getHomeDataArr?.count == 0 {
            self.viewModel.apiforGetHomeData()
        } else {
            // Prevent repeated reload
            if self.lastMarkerDataCount == getHomeDataArr?.count {
                return
            }
            self.lastMarkerDataCount = getHomeDataArr?.count ?? 0
            self.showMarkers(data: getHomeDataArr ?? [])
        }
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
    
    @IBAction func btnWhereTap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Where"
        vc.latitude = "\(self.latitude ?? 0.0)"
        vc.longitude = "\(self.longitude ?? 0.0)"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude("\(self.latitude ?? 0.0)")
                    UserDetail.shared.setAppLongitude("\(self.longitude ?? 0.0)")
                }
                self.viewModel.apiforGetHomeData()
            }  else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    guard let homeDataArr = self.getHomeDataArr, !homeDataArr.isEmpty else { return }
                    self.showMarkers(data: homeDataArr)

                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Time"
        vc.latitude = "\(self.latitude ?? 0.0)"
        vc.longitude = "\(self.longitude ?? 0.0)"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude("\(self.latitude ?? 0.0)")
                    UserDetail.shared.setAppLongitude("\(self.longitude ?? 0.0)")
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
                    guard let homeDataArr = self.getHomeDataArr, !homeDataArr.isEmpty else { return }
                    self.showMarkers(data: homeDataArr)

                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
        
    }
    @IBAction func btnActivity_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        vc.comeFrom = "Activity"
        vc.latitude = "\(self.latitude ?? 0.0)"
        vc.longitude = "\(self.longitude ?? 0.0)"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                let devLat = UserDetail.shared.getDeviceLatitude()
                let devLng = UserDetail.shared.getDeviceLongitude()
                if !devLat.isEmpty && !devLng.isEmpty {
                    UserDetail.shared.setAppLatitude(devLat)
                    UserDetail.shared.setAppLongitude(devLng)
                    if let latD = Double(devLat), let lngD = Double(devLng) {
                        self.latitude = latD
                        self.longitude = lngD
                    }
                } else {
                    UserDetail.shared.setAppLatitude("\(self.latitude ?? 0.0)")
                    UserDetail.shared.setAppLongitude("\(self.longitude ?? 0.0)")
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
                    
                    guard let homeDataArr = self.getHomeDataArr, !homeDataArr.isEmpty else { return }
                    
                    self.showMarkers(data: homeDataArr)

                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
    }
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        
    }
    
    @IBAction func btnshowList_Tap(_ sender: UIButton) {
        self.backAction("Ravi")
        backActionHomeData?(self.getHomeDataArr)
        self.navigationController?.popViewController(animated: true)
    }
    

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        print("Marker Tapped")

        guard let data = marker.userData as? HomeDataModel else {
            print("Failed to cast userData")
            return true
        }

        print("PropertyID:", data.propertyID ?? 0)
        print("Price:", data.hourlyRate ?? "")

        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.comingFrom = self.comingFrom
        vc.propertyID = "\(data.propertyID ?? 0)"
        vc.propertyDistanceInMiles = data.distanceMiles ?? ""

        navigationController?.pushViewController(vc, animated: true)

        return true
    }
}

struct MapDataModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [MapData]?
}
struct MapData: Codable {
    let id: Int?
    let location, latitude, longitude, hourly_rate: String?

    enum CodingKeys: String, CodingKey {
        case id, location, latitude, longitude,hourly_rate
       
    }
}

//@available(iOS 14.0, *)
extension MapVC {
    func bindVC() {

        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }

                result?.handle(success: { response in

                    self.getHomeDataArr = response.data ?? []

                    if self.getHomeDataArr?.isEmpty ?? true {
                        self.showMarkers(data: [])
                        self.showToast(response.message ?? "No properties found for your current location.")
                        return
                    }

                    self.showMarkers(data: self.getHomeDataArr ?? [])

                })
            }
            .store(in: &cancellables)
    }
//    func bindVC() {
//        
//        viewModel.$getHomeDataResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                    
//                    guard let data = response.data else { return }
//
////                    // Prevent repeated reload
////                    if self.lastMarkerDataCount == data.count {
////                        return
////                    }
////
////                    self.lastMarkerDataCount = data.count
//                    self.getHomeDataArr = data
//                    self.showMarkers(data: data)
//                }
//                )
//            }.store(in: &cancellables)
//    }

    
    func showMarkers(data: [HomeDataModel]) {

        // Remove old markers
        mapV.clear()
        markerMap.removeAll()

        var bounds = GMSCoordinateBounds()

        // Track duplicate coordinates
        var coordinateCount: [String: Int] = [:]
        var addedCoordinates: [CLLocationCoordinate2D] = []

        for item in data {

            guard let lat = Double(item.latitude ?? ""),
                  let lon = Double(item.longitude ?? "") else {
                continue
            }

            let propertyKey = "\(item.propertyID ?? 0)"

            // Coordinate key for duplicate detection
            let coordinateKey = "\(lat)_\(lon)"

            let count = coordinateCount[coordinateKey] ?? 0
            coordinateCount[coordinateKey] = count + 1

            // Offset duplicate markers slightly
            let offset = Double(count) * 0.00005

            let adjustedLat = lat + offset
            let adjustedLon = lon + offset

            let coordinate = CLLocationCoordinate2D(
                latitude: adjustedLat,
                longitude: adjustedLon
            )

            let marker = GMSMarker()
            marker.position = coordinate
            marker.userData = item

            if let customView = Bundle.main.loadNibNamed(
                "MapPin",
                owner: self,
                options: nil
            )?.first as? MapPin {

                customView.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: 120,
                    height: 40
                )

                customView.updateView(
                    price: item.hourlyRate ?? ""
                )

                customView.layer.borderWidth = 0.75
                customView.layer.borderColor = UIColor.lightGray.cgColor
                customView.layer.cornerRadius = 20
                customView.layer.masksToBounds = true
                customView.backgroundColor = .white

                marker.iconView = customView
            }

            marker.map = mapV

            markerMap[propertyKey] = marker

            bounds = bounds.includingCoordinate(coordinate)
            addedCoordinates.append(coordinate)

            print("PropertyID:", item.propertyID ?? 0)
            print("Marker Lat:", adjustedLat)
            print("Marker Lng:", adjustedLon)
        }

        // Camera handling
        if !addedCoordinates.isEmpty {
            let camera = GMSCameraPosition.camera(
                withTarget: addedCoordinates[0],
                zoom: 15.0
            )
            mapV.animate(to: camera)
        } else {
            let savedLatStr = UserDetail.shared.getAppLatitude()
            let savedLngStr = UserDetail.shared.getAppLongitude()
            
            if let savedLat = Double(savedLatStr), let savedLng = Double(savedLngStr), savedLat != 0.0, savedLng != 0.0 {
                let camera = GMSCameraPosition.camera(
                    withTarget: CLLocationCoordinate2D(latitude: savedLat, longitude: savedLng),
                    zoom: 15.0
                )
                mapV.animate(to: camera)
            }
        }
    }
}

extension String {
    func formattedPriceString() -> String {
        guard let price = Double(self) else { return "" }
        return price.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(price))
            : String(format: "%.2f", price)
    }
}


extension Double {
    func formattedPrice() -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0
        ? String(Int(self))
        : String(format: "%.2f", self)
    }
}

extension Int {
    func formattedPrice() -> String {
        return String(self)
    }
}
