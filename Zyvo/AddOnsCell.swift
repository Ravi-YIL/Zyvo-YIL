//
//  AddOnsCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 27/11/25.
//

import UIKit

class AddOnsCell:UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var btnAddnewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddnewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgAddicon: UIImageView!
    @IBOutlet weak var imgicon: UIImageView!
    @IBOutlet weak var txt_Workname: UITextField!
    @IBOutlet weak var btnAddWork: UIButton!
    @IBOutlet weak var view_Type: UIView!
    @IBOutlet weak var view_AddNew: UIView!
   
    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    var typess:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        view_AddNew.layer.cornerRadius = view_AddNew.layer.frame.height / 2
        view_AddNew.layer.borderWidth = 1.5
        view_AddNew.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
        
        view_main.layer.cornerRadius = view_main.layer.frame.height / 2
        view_main.layer.borderWidth = 1.5
        view_main.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
        self.lbl_title.font = UIFont(name: "Poppins", size: 16)!
        self.txt_Workname.font = UIFont(name: "Poppins", size: 16)!
        view_Type.layer.cornerRadius = view_Type.layer.frame.height / 2
        view_Type.layer.borderWidth = 1.5
        view_Type.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
    }
    
//    override func layoutSubviews() {
//           super.layoutSubviews()
//           // Ensure view_main adjusts its width based on lbl_title
//        lbl_title.sizeToFit()
//       }

//    private func setupConstraints() {
//        // Fix the height of view1 to 150
//        NSLayoutConstraint.activate([
//            view_Type.topAnchor.constraint(equalTo: contentView.topAnchor),
//            view_Type.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            view_Type.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            view_Type.heightAnchor.constraint(equalToConstant: 150)
//        ])
//    }
}
