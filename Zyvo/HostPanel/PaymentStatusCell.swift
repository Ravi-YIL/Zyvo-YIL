//
//  PaymentStatusCell.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit

class PaymentStatusCell: UICollectionViewCell {

    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var mainVH_Constant: NSLayoutConstraint!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var view_title: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_title.applyRoundedStyle()
        btnStatus.layer.cornerRadius = btnStatus.layer.frame.height / 2
    }

}
