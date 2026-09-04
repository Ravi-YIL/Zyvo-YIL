//
//  AmentiesCell.swift
//  Zyvo
//
//  Created by ravi on 10/12/24.
//

import UIKit

class AmentiesCell: UICollectionViewCell {
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var btnLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var btnCheck: UIButton!
    
    // Closure to handle button click
        var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Add target to the button
        // 🔥 MOST IMPORTANT
           lbl_title.setContentHuggingPriority(.required, for: .vertical)
           lbl_title.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl_title.numberOfLines = 0
        lbl_title.lineBreakMode = .byWordWrapping
        btnCheck.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc private func buttonClicked() {
            // Trigger the closure when the button is clicked
            buttonAction?()
        }
}
