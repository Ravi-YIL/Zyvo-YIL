//
//  MasterCell.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class MasterCell: UICollectionViewCell,UITextFieldDelegate {

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
       
        if typess == "Ravi" {
            
            // Fixed size
               btnAddnewWidth.constant = 180
               btnAddnewHeight.constant = 50

               // Prevent stretching
               view_AddNew.translatesAutoresizingMaskIntoConstraints = false

               view_AddNew.setContentHuggingPriority(
                   .required,
                   for: .horizontal
               )

               view_AddNew.setContentCompressionResistancePriority(
                   .required,
                   for: .horizontal
               )

               btnAddNew.setBackgroundImage(
                   UIImage(named: "AddNEwAddOns"),
                   for: .normal
               )
          

           contentView.layoutIfNeeded()
           
            btnAddnewWidth.constant = 180
            btnAddnewHeight.constant = 50
            view_main.layer.borderWidth = 1.25
           // btnAddNew.setBackgroundImage(UIImage(named: "AddNEwAddOns"), for: .normal)
        }
        
       // view_main.layer.cornerRadius = view_main.layer.frame.height / 2
        view_main.layer.borderWidth = 1.5
        view_main.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
        self.lbl_title.font = UIFont(name: "Poppins-Regular", size: 16) ?? UIFont(name: "Poppins", size: 16) ?? UIFont.systemFont(ofSize: 16)
        self.lbl_title.adjustsFontSizeToFitWidth = true
        self.lbl_title.minimumScaleFactor = 0.5
        self.lbl_title.lineBreakMode = .byTruncatingTail
        self.lbl_title.numberOfLines = 1
        
        self.btnCross.setBackgroundImage(nil, for: .normal)
        self.btnCross.setImage(UIImage(named: "Crosslighticon"), for: .normal)
        self.btnCross.imageView?.contentMode = .scaleAspectFit
        
        self.txt_Workname.font = UIFont(name: "Poppins-Regular", size: 16) ?? UIFont(name: "Poppins", size: 16) ?? UIFont.systemFont(ofSize: 16)
        // view_Type.layer.cornerRadius = view_Type.layer.frame.height / 2
        view_Type.layer.borderWidth = 1.5
        view_Type.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        btnCross.removeTarget(nil, action: nil, for: .allEvents)
        btnAddNew.removeTarget(nil, action: nil, for: .allEvents)
        btnAddWork.removeTarget(nil, action: nil, for: .allEvents)
        txt_Workname.removeTarget(nil, action: nil, for: .allEvents)
        txt_Workname.text = ""
        lbl_title.text = ""
        view_main.isHidden = true
        view_AddNew.isHidden = true
        view_Type.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        view_main.layer.cornerRadius = view_main.bounds.height / 2
        view_Type.layer.cornerRadius = view_Type.bounds.height / 2
    }
    
    
  
   
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//
//            var view = self.superview
//
//            while view != nil {
//
//                if let collectionView = view as? UICollectionView {
//
//                    let rect = self.convert(textField.frame, to: collectionView)
//
//                    collectionView.scrollRectToVisible(
//                        CGRect(
//                            x: rect.origin.x,
//                            y: rect.origin.y - 100,
//                            width: rect.width,
//                            height: rect.height + 250
//                        ),
//                        animated: true
//                    )
//
//                    break
//                }
//
//                view = view?.superview
//            }
//        }
//    }
    
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
