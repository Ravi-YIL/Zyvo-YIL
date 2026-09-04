//
//  NeedMoreTimePopUpVC.swift
//  Zyvo
//
//  Created by ravi on 13/03/25.
//wswqswqswqswswqswqdswqdwdwdwdwdwdwdwdwdwdwdwdwdwdwdwdwdwd

import UIKit

class NeedMoreTimePopUpVC: UIViewController {

    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    
    var perHourRate: Int? = 0
    
    var backAction:(_ str : String ) -> () = { str in}
    override func viewDidLoad() {
        super.viewDidLoad()
        btnYes.layer.cornerRadius = btnYes.layer.frame.height / 2
        btnNo.layer.cornerRadius = btnNo.layer.frame.height / 2
        btnNo.layer.borderWidth = 1
        btnNo.layer.borderColor = UIColor.init(red: 74/255, green: 237/255, blue: 177/255, alpha: 1).cgColor

    }
    
    @IBAction func btnYEs_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("Yes")
        }
    }
    
    @IBAction func btnNo_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.backAction("No")
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
