//
//  GuestCell.swift
//  Zyvo
//
//  Created by ravi on 7/11/24.
//

import UIKit

class GuestCell: UICollectionViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        lbl_Detail.isHidden = true
        img.layer.cornerRadius = 20

    }

}
