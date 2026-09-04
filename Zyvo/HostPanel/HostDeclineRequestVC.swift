//
//  HostDeclineRequestVC.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit
import Combine

class HostDeclineRequestVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var viewMSGReason: UIView!
    @IBOutlet weak var viewShareMSG: UIView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_maintenance: UIView!
    @IBOutlet weak var view_overlooked: UIView!
  
    @IBOutlet weak var msgTxtV: UITextView!
    
    private var cancellables = Set<AnyCancellable>()
    private var ViewModel = BookingApproveDeclineViewModel()
    var reason = ""
    var msgTxt = ""
    var bookingId = ""
    var extId: Int?
    var backAction : () -> () = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMSGReason.isHidden = true
        self.msgTxtV.text = "Share a message..."
        self.msgTxtV.textColor = .lightGray
        bindVC_ForDeclineBooking()
        
        viewShareMSG.applyRoundedStyle(cornerRadius: 10)
        view_otherReason.applyRoundedStyle(cornerRadius: 10)
        view_maintenance.applyRoundedStyle(cornerRadius: 10)
        view_overlooked.applyRoundedStyle(cornerRadius: 10)
        
        self.reason = "I'm overbooked"
        print(self.reason ,"<<< Reason")
        view_overlooked.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        view_maintenance.backgroundColor = UIColor.clear
        
        msgTxtV.delegate = self
       // otherReasonTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }

    @IBAction func btnSelectOverLooked_Tap(_ sender: UIButton) {
        self.reason = "I'm overbooked"
        print(self.reason ,"<<< Reason")
        self.msgTxt = ""
        view_overlooked.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        view_maintenance.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnMaintenance_Tap(_ sender: UIButton) {
        self.reason = "Maintenance day"
        print(self.reason ,"<<< Reason")
        self.msgTxt = ""
        view_overlooked.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.clear
        view_maintenance.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.25)
    }
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        self.reason =  "Other Reason"
        print(self.reason ,"<<< Reason")
        self.viewMSGReason.isHidden = false
        view_overlooked.backgroundColor = UIColor.clear
        view_maintenance.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.25)
    }
    
    @IBAction func btnDecline_Tap(_ sender: UIButton) {
        
        ViewModel.approveDeclineBooking(bookingID: bookingId, extId: self.extId ?? 0, status: "decline", hostMessage: self.msgTxt, declinedReason: self.reason)
//        self.dismiss(animated: true)
    }
    
    @IBAction func dismissBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        self.reason = otherReasonTF.text ?? ""
//        print(self.reason ,"<<< Reason")
//        view_overlooked.backgroundColor = UIColor.clear
//        view_maintenance.backgroundColor = UIColor.clear
//     }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.msgTxtV.text == "Share a message..."{
            self.msgTxtV.text = ""
            self.msgTxtV.textColor = .black
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.msgTxtV.text == ""{
            self.msgTxtV.text = "Share a message..."
            self.msgTxtV.textColor = .lightGray
        }
        self.msgTxt = self.msgTxtV.text
        print(self.msgTxt)
        
    }
    
}
extension HostDeclineRequestVC{
    func bindVC_ForDeclineBooking() {
        ViewModel.$getApproveDeclineResult
               .receive(on: DispatchQueue.main)
               .sink { [weak self] result in
                   guard let self = self else{return}
                   result?.handle(success: { response in
                       if response.success == true{
                           self.dismiss(animated: true) {
                               self.backAction()
                           }
                       }else{
                           self.AlertControllerOnr(title: "Alert!", message: response.message)
                       }
                   })
               }.store(in: &cancellables)
       }
}
