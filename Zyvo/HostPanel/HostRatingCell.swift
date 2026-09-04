//
//  RatingCell.swift
//  Zyvo
//
//  Created by ravi on 20/11/24.
//

import UIKit
import Cosmos

class HostRatingCell: UITableViewCell {

    @IBOutlet weak var view_img: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingV: CosmosView!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img.layer.cornerRadius = img.layer.frame.height / 2
    
        view_img.layer.cornerRadius = view_img.layer.frame.height / 2
        view_img.layer.borderWidth = 2.5
        view_img.layer.borderColor = UIColor.init(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.2).cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
