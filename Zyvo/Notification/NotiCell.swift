//
//  NotiCell.swift
//  Zyvo
//
//  Created by ravi on 6/11/24.
//

import UIKit

class NotiCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var mainV: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Background
           mainV.backgroundColor = UIColor(white: 0.96, alpha: 1)
           
           // Corner Radius
           mainV.layer.cornerRadius = 16
           
           // Border
        mainV.layer.borderWidth = 1.0
           mainV.layer.borderColor = UIColor.lightGray.cgColor
           
           // Shadow
           mainV.layer.shadowColor = UIColor.black.cgColor
           mainV.layer.shadowOpacity = 0.12
           mainV.layer.shadowOffset = CGSize(width: 0, height: 4)
           mainV.layer.shadowRadius = 8
           
           // IMPORTANT
           mainV.layer.masksToBounds = false
        
//        // Add the shadow properties
//        mainV.layer.shadowColor = UIColor.lightGray.cgColor
//        mainV.layer.shadowOpacity = 1.0 // Opacity between 0.0 and 1.0
//        mainV.layer.shadowOffset = CGSize(width: 0, height: 0) // X = 0, Y = 0
//        mainV.layer.shadowRadius = 4 // Blur radius


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
     
}
