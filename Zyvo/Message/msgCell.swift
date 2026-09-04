//
//  msgCell.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit

class msgCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbl_PropertyTitle: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var view_online: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var mainV: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lbl_PropertyTitle.text = nil
        lbl_time.text = nil
        lbl_message.text = nil
        userName.text = nil
        userImg.image = UIImage(named: "img1")
        view_online.isHidden = true
    }
    
    // MARK: - Private Setup
    private func setupUI() {
        img.makeCircular()
        img.contentMode = .scaleAspectFill
        
        mainV.layer.cornerRadius = 10
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1).cgColor
        
        img.layer.cornerRadius = img.layer.frame.height / 2
      
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 4
        view_Photo.layer.borderColor = UIColor(red: 234/255, green: 239/255, blue: 244/255, alpha: 0.9).cgColor
    }
}

