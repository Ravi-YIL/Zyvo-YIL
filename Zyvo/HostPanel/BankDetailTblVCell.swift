//
//  BankDetailTblVCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 15/01/25.
//

import UIKit

class BankDetailTblVCell: UITableViewCell {

    @IBOutlet weak var bankDetailLbl: UILabel!
    @IBOutlet weak var bankDetailView: UIView!
    @IBOutlet weak var bankDotBtn: UIButton!
    @IBOutlet weak var bankPrefferdV: UIView!
    
    @IBOutlet weak var cardDetailLbl: UILabel!
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var cardDotBtn: UIButton!
    @IBOutlet weak var cardPrefferdV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
