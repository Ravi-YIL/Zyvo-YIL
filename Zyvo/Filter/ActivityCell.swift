//
//  ActivityCell.swift
//  Zyvo
//
//  Created by ravi on 14/11/24.
//

import UIKit

class ActivityCell: UICollectionViewCell {

    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbl_Name.font = UIFont.init(name: "Poppins-Regular", size: 12)!
        
        view_Main.layer.borderWidth = 1.5
//        view_Main.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 1).cgColor
        view_Main.layer.cornerRadius = 10
    }

}
