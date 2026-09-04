//
//  LocationPicker.swift
//  MyAirSpa_YesITLabs
//
//  Created by YATIN  KALRA on 05/12/23.





import Foundation
import CoreLocation
import UIKit

protocol LocationPickerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(error: Error)
}

class LocationPicker: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationPicker() // Singleton instance
    private var locationManager: CLLocationManager
    weak var delegate: LocationPickerDelegate?

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Check and request location permission
    func checkLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationAccessAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func requestLocationAccess() {
        if !CLLocationManager.locationServicesEnabled() {
            delegate?.didFailWithError(error: NSError(domain: "LocationOff", code: 0))
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
            
        case .denied, .restricted:
            delegate?.didFailWithError(error: NSError(domain: "PermissionDenied", code: 1))
            
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        handleAuthStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthStatus(status)
    }
    
    private func handleAuthStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            delegate?.didFailWithError(error: NSError(domain: "PermissionDenied", code: 1))
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    /// Start getting user location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        if let location = locationManager.location {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            if lat != 0.0 && lng != 0.0 {
                delegate?.didUpdateLocation(latitude: lat, longitude: lng)
            }
        }
    }
    
    /// Stop location updates
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Show alert to enable location access
    private func showLocationAccessAlert() {
        guard let topController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alertController = UIAlertController(
            title: "Location Access Needed",
            message: "Please enable location access in Settings to get your current location.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })

        topController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            delegate?.didUpdateLocation(latitude: latitude, longitude: longitude)
            stopUpdatingLocation() // Stop updates after getting location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}




