//
//  ServiceCell.swift
//  Zyvo
//
//  Created by ravi on 20/02/25.
//

import UIKit

class ServiceCell: UICollectionViewCell {

    @IBOutlet weak var lbl_serviceName: UILabel!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_serviceName.font = UIFont(name: "poppins-regular", size: 15)
        // Initialization code
        mainV.layer.cornerRadius = 10
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor =  UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
    }

}
