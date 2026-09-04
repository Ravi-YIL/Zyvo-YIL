//
//  HostApproveRequestVC.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit
import Combine

class HostApproveRequestVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var view_message: UIView!
    @IBOutlet weak var msgTxtV: UITextView!
    
    private var cancellables = Set<AnyCancellable>()
    private var ViewModel = BookingApproveDeclineViewModel()
    
    var msgTxt = ""
    var bookingId = ""
    var extId : Int?
    var backAction : () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC_ForApproveBooking()
        view_message.applyRoundedStyle(cornerRadius: 10)
        
        self.msgTxtV.text = "Share a message..."
        self.msgTxtV.textColor = .lightGray
        
        msgTxtV.delegate = self
        
    }
    

    @IBAction func btnApprove_Tap(_ sender: UIButton) {
        ViewModel.approveDeclineBooking(bookingID: bookingId,extId: self.extId ?? 0, status: "approve", hostMessage: self.msgTxt, declinedReason: "")
    }
   
    @IBAction func dismissBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
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

extension HostApproveRequestVC{
    func bindVC_ForApproveBooking() {
        ViewModel.$getApproveDeclineResult
               .receive(on: DispatchQueue.main)
               .sink { [weak self] result in
                   guard let self = self else{return}
                   result?.handle(success: { response in
                       
                       if response.success == true{
                           self.backAction()
                           self.dismiss(animated: true)
                       }else{
                           self.AlertControllerOnr(title: "Alert!", message: response.message)
                       }
                       
                   })
               }.store(in: &cancellables)
       }
}
