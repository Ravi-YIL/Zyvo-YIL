//
//  HostCardCell.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit

class HostCardCell: UICollectionViewCell {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnPrimary: UIButton!
    @IBOutlet weak var bank_CardNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPrimary.layer.cornerRadius = btnPrimary.layer.frame.height / 2
    }

}
