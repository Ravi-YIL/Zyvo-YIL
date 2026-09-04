//
//  HostSuccessPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit

class HostSuccessPopUpVC: UIViewController {
    var backAction:(_ str : String ) -> () = { str in}
    @IBOutlet weak var lbl_Details: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_Details.font =    UIFont(name: "Poppins", size: 15)!

       
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) 
    }
    

    @IBAction func btnOkay_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
           // self.backAction("Ravi")
        }
    }
}
