//
//  HostFilterVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit

class HostFilterVC: UIViewController {

    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnCancelled: UIButton!
    @IBOutlet weak var viewHoldButton: UIView!
    var backAction:(_ _value : String ) -> () = { _value in}
    var filterType = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if filterType == "completed"{
            btnCompleted.layer.backgroundColor = UIColor.white.cgColor
            btnPending.layer.backgroundColor = UIColor.clear.cgColor
            btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
        }else if filterType == "pending"{
            btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
            btnPending.layer.backgroundColor = UIColor.white.cgColor
            btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
        }else if filterType == "cancelled"{
            btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
            btnPending.layer.backgroundColor = UIColor.clear.cgColor
            btnCancelled.layer.backgroundColor = UIColor.white.cgColor
        } else {
            btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
            btnPending.layer.backgroundColor = UIColor.clear.cgColor
            btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
        }
        viewHoldButton.applyRoundedStyle()
        btnCompleted.layer.cornerRadius = btnCompleted.layer.frame.height / 2
        btnCancelled.layer.cornerRadius = btnCancelled.layer.frame.height / 2
        btnPending.layer.cornerRadius = btnPending.layer.frame.height / 2
        
    }
    
    @IBAction func btnCompleted_Tap(_ sender: UIButton) {
        filterType = "completed"
        btnCompleted.layer.backgroundColor = UIColor.white.cgColor
        btnPending.layer.backgroundColor = UIColor.clear.cgColor
        btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @IBAction func btnCleanAll_Tap(_ sender: UIButton) {
        self.filterType = ""
        btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
        btnPending.layer.backgroundColor = UIColor.clear.cgColor
        btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
        self.backAction(self.filterType)
        self.dismiss(animated: true)
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        self.backAction(self.filterType)
        self.dismiss(animated: true)
    }
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnPending_Tap(_ sender: UIButton) {
        filterType = "pending"
        btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
        btnPending.layer.backgroundColor = UIColor.white.cgColor
        btnCancelled.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @IBAction func btnCancelled_Tap(_ sender: UIButton) {
        filterType = "cancelled"
        btnCompleted.layer.backgroundColor = UIColor.clear.cgColor
        btnPending.layer.backgroundColor = UIColor.clear.cgColor
        btnCancelled.layer.backgroundColor = UIColor.white.cgColor
    }
    
   
}
