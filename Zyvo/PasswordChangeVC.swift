//
//  PasswordChangeVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit

class PasswordChangeVC: UIViewController {
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    var comesFrom = ""
    var backCome : () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLbl.font = UIFont(name: "Poppins", size: 15)!
        
        detailLbl.setLineSpacing(10)
        print(comesFrom,"comesFrom VALUE")
        if comesFrom == "LoginEmailForgetPassword"{
            
            detailLbl.text = "Your password has been changed successfully."
            
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "Book"{
            self.detailLbl.text = "We will review your report and take appropriate action if necessary."
            self.btn.setTitle("Okay", for: .normal)
        }else if comesFrom == "Email"{
            
            self.detailLbl.text = "Your phone/email has been successfully changed."
            
            self.btn.setTitle("Okay", for: .normal)
        } else if comesFrom == "VerifyEmail"{
            self.detailLbl.text = "Your phone/email has been successfully verified."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "Phone"{
            self.detailLbl.text = "Your phone/email has been successfully changed."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "PhoneVerified"{
            self.detailLbl.text = "Your phone/email has been successfully verified."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "EmailVerified"{
            self.detailLbl.text = "Your phone/email has been successfully verified."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "UpdatePhone"{
            self.detailLbl.text = "Your phone/email has been changed successfully."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "Emailupdate"{
            self.detailLbl.text = "Your phone/email has been changed successfully."
            self.btn.setTitle("Okay", for: .normal)
        }
        else if comesFrom == "ReportSubmitted"{
            self.detailLbl.text = "We will review your report and take appropriate action if necessary."
            self.btn.setTitle("Okay", for: .normal)
        }
        
    }
    
    @IBAction func btnClose_Tap(_ sender: UIButton) {
        if comesFrom == "Book"{
            self.dismiss(animated: true)
            self.backCome()
        }else if comesFrom == "Email" || comesFrom == "Phone" || comesFrom == "PassChange" || comesFrom == "EmailVerified"  || comesFrom == "PhoneVerified" || comesFrom == "UpdatePhone" || comesFrom == "Emailupdate" || comesFrom == "ReportSubmitted" {
            
            self.dismiss(animated: true)
            self.backCome()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnNotificationVC") as! TurnOnNotificationVC
            self.navigationController?.pushViewController(vc, animated:     false)
        }
    }
    
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        if comesFrom == "LoginEmailForgetPassword" {
            self.navigationController?.popToViewController(ofClass: EmailLoginVC.self)
        }else if comesFrom == "LoginPhone"{
            self.navigationController?.popToViewController(ofClass: LoginVC.self)
        }else if comesFrom == "Book"{
            self.dismiss(animated: true)
            self.backCome()
        }else if comesFrom == "Email" || comesFrom == "VerifyEmail" || comesFrom == "Phone" || comesFrom == "PassChange" || comesFrom == "EmailVerified"  || comesFrom == "PhoneVerified" || comesFrom == "UpdatePhone" || comesFrom == "Emailupdate" || comesFrom == "ReportSubmitted" {
            self.dismiss(animated: true)
            self.backCome()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnNotificationVC") as! TurnOnNotificationVC
            self.navigationController?.pushViewController(vc, animated:false)
        }
    }
}


extension UILabel {
    func setLineSpacing(_ spacing: CGFloat, alignment: NSTextAlignment = .center) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment

        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        self.numberOfLines = 0
        self.attributedText = attributedString
    }
}
