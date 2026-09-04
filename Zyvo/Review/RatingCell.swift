//
//  RatingCell.swift
//  Zyvo
//
//  Created by ravi on 20/11/24.
//

import UIKit
import Cosmos
class RatingCell: UITableViewCell {

    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var starimg1: UIImageView!
    @IBOutlet weak var starimg2: UIImageView!
    @IBOutlet weak var starimg3: UIImageView!
    @IBOutlet weak var starimg4: UIImageView!
    @IBOutlet weak var starimg5: UIImageView!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var view_img: UIView!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbl_name.font = UIFont(name: "poppin-semi-bold", size: 20)
        lbl_desc.font = UIFont(name: "poppins", size: 17)
        
        viewRating.isUserInteractionEnabled = false
        
       // img.layer.cornerRadius = img.layer.frame.height / 2
        
        img.makeCircular()
        img.contentMode = .scaleAspectFill
    
        view_img.layer.cornerRadius = view_img.layer.frame.height / 2
        view_img.layer.borderWidth = 3.0
        view_img.layer.borderColor = UIColor.init(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.1).cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
