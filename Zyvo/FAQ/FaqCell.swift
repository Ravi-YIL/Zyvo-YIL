//
//  FaqCell.swift
//  Zyvo
//
//  Created by ravi on 06/05/2025.
//

import UIKit

class FaqCell: UITableViewCell {

    @IBOutlet weak var view_Question: UIView!
    @IBOutlet weak var view_Answer: UIView!
    @IBOutlet weak var stackV: UIStackView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var lbl_Question: UILabel!
    
    var buttonAction: (() -> Void)?

    var toggleAction: (() -> Void)?

       override func awakeFromNib() {
           super.awakeFromNib()
           
           stackV.layer.cornerRadius = 10
           stackV.layer.borderWidth = 0.5
           stackV.layer.borderColor = UIColor.lightGray.cgColor
           btnPlus.setImage(UIImage(named: "PlusSigns"), for: .normal)
           btnPlus.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
       }

       @objc func buttonTapped() {
           toggleAction?()
       }

       func configure(with item: FAQModel) {
           print(item)
           print(item.isExpanded ?? false,"Is expand")
           lbl_Question.text = item.question ?? ""
           lbl_Answer.text = item.answer ?? ""
           
           view_Answer.isHidden = !(item.isExpanded ?? false)
           
           // Set image based on state
           let imageName = item.isExpanded ?? false ? "MinusSign" : "PlusSigns"
           btnPlus.setImage(UIImage(named: imageName), for: .normal)
          
           let rawText = (item.answer ?? "").decodedHTML

           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
           paragraphStyle.alignment = .justified  // Or use .left, .center, etc.

           let attributedString = NSAttributedString(
               string: rawText,
               attributes: [
                   .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
                   .paragraphStyle: paragraphStyle,
                   .foregroundColor: UIColor.label // Optional: customize color
               ]
           )

               lbl_Answer.attributedText = attributedString
       }
   }
