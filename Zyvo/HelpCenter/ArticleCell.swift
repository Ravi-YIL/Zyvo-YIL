//
//  ArticleCell.swift
//  Zyvo
//
//  Created by ravi on 8/11/24.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
