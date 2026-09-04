//
//  HostNotificationPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit

class HostNotificationPopUpVC: UIViewController {
    
    var backAction:(_ str : String ) -> () = { str in}

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.dismiss(animated: false) {
                self.backAction("Ravis")
            }
        }
       
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: false)
                 
    }
    

    @IBAction func btnOkay_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("Ravis")
        }
    }

}
