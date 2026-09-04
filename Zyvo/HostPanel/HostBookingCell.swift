//
//  HostBookingCell.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit

class HostBookingCell: UITableViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btn1Width: NSLayoutConstraint!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_Date.font = UIFont(name: "Poppins", size: 15)!
        lbl_name.font = UIFont(name: "Poppins", size: 18)!
        btn1.titleLabel?.font = UIFont(name: "Poppins", size: 15)!
        btn2.titleLabel?.font = UIFont(name: "Poppins", size: 15)!
       
        // Initialization code
        btn1.layer.cornerRadius =   btn1.layer.frame.height / 2
        btn2.layer.cornerRadius =   btn2.layer.frame.height / 2
        viewImg.layer.cornerRadius =   viewImg.layer.frame.height / 2
        img.layer.cornerRadius = img.layer.frame.height / 2
        viewImg.layer.borderWidth = 3
        viewImg.layer.borderColor = UIColor(red: 234/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        
        viewMain.layer.cornerRadius =  20
        viewMain.layer.borderWidth = 1.75
        viewMain.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
