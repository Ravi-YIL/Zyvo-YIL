//
//  LocationPopUPVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 21/04/26.
//

import UIKit

class LocationPopUPVC: UIViewController {
    
    var onTurnOn: (() -> Void)?
       var onSkip: (() -> Void)?
    
    var popupType: LocationPopupType = .permissionRequired

    override func viewDidLoad() {
        super.viewDidLoad()

            
            switch popupType {
                
            case .deviceOff:
                print("Device off")
                break
                
            case .permissionRequired:
                print("Permission Required")
                break
                
            case .permissionDenied:
                print("Permission Denied")
                break
            }
       
    }
    
    @IBAction func btnTurnOnLocation_Tapped(_ sender: UIButton) {
        dismiss(animated: true) {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  self.onTurnOn?()
              }
          }
    }

  
    @IBAction func btnNotNow_Tapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.onSkip?()
        }
    }
    
}

enum LocationPopupType {
    case deviceOff
    case permissionRequired
    case permissionDenied
}
