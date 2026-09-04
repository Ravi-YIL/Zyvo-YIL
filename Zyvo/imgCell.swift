//
//  imgCell.swift
//  Zyvo
//
//  Created by ravi on 11/10/24.
//

import UIKit

class imgCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.layer.cornerRadius = 10
     
        
    }

}
