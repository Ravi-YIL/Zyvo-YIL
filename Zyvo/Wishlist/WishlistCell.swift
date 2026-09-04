//
//  WishlistCell.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit

class WishlistCell: UICollectionViewCell {

    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lbl_SavedCount: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img.contentMode = .scaleAspectFill
        self.img.layer.cornerRadius = 20
        self.img.clipsToBounds = true
        self.btnCross.isHidden = true
    }

}
