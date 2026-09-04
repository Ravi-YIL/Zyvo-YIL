//
//  CancelBookingPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit

class CancelBookingPopUpVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var backAction: (_ _str: String) -> () = {_str in}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnYes.layer.cornerRadius = btnYes.layer.frame.height / 2
        
        
        btnCancel.layer.cornerRadius = btnCancel.layer.frame.height / 2
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.init(red: 74/255, green: 237/255, blue: 177/255, alpha: 1).cgColor
    }
    
    @IBAction func btnYes_Tap(_ sender: UIButton) {
        self.dismiss(animated: true) {
           self.backAction("Yes")
        }
        
    }
    @IBAction func btnCancel_Tap(_ sender: UIButton) {
        self.dismiss(animated: true) {
           self.backAction("Cancel")
        }
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.backAction("Cross")
    }
}
