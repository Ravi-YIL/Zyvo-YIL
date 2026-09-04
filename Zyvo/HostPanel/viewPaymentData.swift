//
//  viewPaymentData.swift
//  Zyvo
//
//  Created by ravi on 3/01/25.
//

import UIKit

class viewPaymentData: UIView {

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_Personname: UILabel!
    @IBOutlet weak var btnpaymentStatus: UIButton!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    func configure(btnpaymentStatus:UIButton){
        
        btnpaymentStatus.layer.cornerRadius = btnpaymentStatus.layer.frame.height / 2
        img.layer.cornerRadius = img.layer.frame.height / 2
    }
    
}
