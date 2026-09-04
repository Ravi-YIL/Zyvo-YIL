//
//  CardTblVCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 26/12/24.
//

import UIKit

class CardTblVCell: UITableViewCell {

    @IBOutlet weak var preferredLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var cardTypeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
