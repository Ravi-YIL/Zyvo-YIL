//
//  BankingDetailsCell.swift
//  Zyvo
//
//  Created by ravi on 19/11/24.
//

import UIKit

class BankingDetailsCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainV.layer.cornerRadius = mainV.layer.frame.height / 2
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor =  UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
    }

}
