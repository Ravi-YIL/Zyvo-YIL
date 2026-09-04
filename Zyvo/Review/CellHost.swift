//
//  CellHost.swift
//  Zyvo
//
//  Created by ravi on 19/11/24.
//

import UIKit

class CellHost: UICollectionViewCell {

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lbl_title.font = UIFont(name: "Poppins", size: 18.5)!
        self.lbl_title.font = UIFont(name: "Poppins", size: 16)!
        
        mainV.layer.cornerRadius = 15
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor =  UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
    }

}
