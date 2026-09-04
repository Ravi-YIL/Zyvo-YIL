//
//  CardCell.swift
//  Zyvo
//
//  Created by ravi on 28/11/24.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var lbl_Preferred: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_cardNumber: UILabel!
    @IBOutlet weak var btnDot: UIButton!
    @IBOutlet weak var btnDot_View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
