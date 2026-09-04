//
//  ChooseLanguageCell.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class ChooseLanguageCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbl_CountryName: UILabel!
    @IBOutlet weak var lbl_LanguageTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_LanguageTitle.font = UIFont(name: "Poppins-Medium", size: 15.0)
        lbl_CountryName.font = UIFont(name: "Poppins-Regular", size: 14)
        viewMain.layer.cornerRadius = 15
        viewMain.layer.borderWidth = 1.25
        
    }
}
    
