//
//  reasonCell.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit

class reasonCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_main: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view_main.layer.cornerRadius = 10
        view_main.layer.borderColor = UIColor.lightGray.cgColor
        view_main.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
