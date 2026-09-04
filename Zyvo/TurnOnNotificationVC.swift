//
//  TurnOnNotificationVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class TurnOnNotificationVC: UIViewController {
    
    var signUpWith = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func btnTurnOn_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnLocationVC") as! TurnOnLocationVC
        vc.signUpWith = self.signUpWith
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnNotNow_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnLocationVC") as! TurnOnLocationVC
        vc.signUpWith = self.signUpWith
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
