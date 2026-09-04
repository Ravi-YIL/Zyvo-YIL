//
//  AddMoreTimeCell.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit

class AddMoreTimeCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var editicon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.cornerRadius = viewMain.layer.frame.height / 2
        viewMain.layer.borderWidth = 1
        viewMain.layer.borderColor = UIColor.lightGray.cgColor
    }

}
