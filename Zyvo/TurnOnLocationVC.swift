//
//  TurnOnLocationVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class TurnOnLocationVC: UIViewController,LocationPickerDelegate {
    
    var signUpWith = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate to receive location updates
        LocationPicker.shared.delegate = self
        
        // Listen for app returning from settings
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc func appDidBecomeActive() {
        // When the app returns from settings, check location again
        LocationPicker.shared.checkLocationPermission()
    }
    
    // MARK: - LocationManagerHelperDelegate Methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        UserDetail.shared.setAppLatitude("\(latitude)")
        UserDetail.shared.setAppLongitude("\(longitude)")
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
         vc.SignUpWith = self.signUpWith
                self.navigationController?.pushViewController(vc, animated:false)
        
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    
    @IBAction func btnTurnOn_Tap(_ sender: UIButton) {
        
        // Check permission and get location
        LocationPicker.shared.checkLocationPermission()
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
//        vc.SignUpWith = self.signUpWith
//        self.navigationController?.pushViewController(vc, animated:false)
    }
    
    @IBAction func btnNot_Now(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
        vc.SignUpWith = self.signUpWith
        self.navigationController?.pushViewController(vc, animated:false)
    }
}
