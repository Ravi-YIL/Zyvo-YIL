//
//  HostBookingsIncludeCollVCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 21/02/25.
//

import UIKit

class HostBookingsIncludeCollVCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var bgV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgV.layer.cornerRadius = 15
        bgV.layer.borderWidth = 1.0
        bgV.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
