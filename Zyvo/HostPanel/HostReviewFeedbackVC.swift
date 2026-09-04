//
//  HostReviewFeedbackVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import Cosmos
import Combine

class HostReviewFeedbackVC: UIViewController, UITextViewDelegate {
    
    var backAction:(_ str : String ) -> () = { str in}
    
    var bookingDetailViewModel = GiveReviewModel()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var view_msg: UIView!
    @IBOutlet weak var view_onTime: CosmosView!
    @IBOutlet weak var view_Communication: CosmosView!
    @IBOutlet weak var view_Response: CosmosView!
    @IBOutlet weak var ratingMsg: UITextView!
    
    var msg = ""
    var bookingID: Int?
    var proprtyID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        
        ratingMsg.text = "Message"
        ratingMsg.textColor = .lightGray
        
        self.ratingMsg.delegate = self
        
        btnPublish.layer.cornerRadius =  btnPublish.layer.frame.height / 2
        
        view_msg.layer.borderWidth = 1
        view_msg.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_msg.layer.cornerRadius =  20
        
    }
    
    @IBAction func btnReviewPublish_Tap(_ sender: UIButton) {
        bookingDetailViewModel.reviewGuest(bookingId: self.bookingID ?? 0, propertyId: self.proprtyID ?? 0, communication: Int(view_Communication.rating), onTime: Int(view_onTime.rating), responseRate: Int(view_Response.rating), reviewMsgs: msg)
    }
    
    @IBAction func btnReviewDismissTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if ratingMsg.text == "Message"{
            ratingMsg.text = ""
            ratingMsg.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.msg = ratingMsg.text
        if ratingMsg.text == ""{
            ratingMsg.text = "Message"
            ratingMsg.textColor = .lightGray
        }
    }
}
extension HostReviewFeedbackVC{
    func bindVC() {
        bookingDetailViewModel.$ReviewResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    if response.success == true{
                        
                        self.msg = ""
                        self.ratingMsg.text = "Message"
                        
                        self.ratingMsg.textColor = .lightGray
                        self.view_Response.rating = 0.0
                        self.view_onTime.rating = 0.0
                        self.view_Communication.rating = 0.0
                        
                        self.dismiss(animated: false) {
                            self.backAction("Ravi")
                        }
                    }else{
                        self.AlertControllerOnr(title: "Alert!", message: response.message)
                    }
                    
                })
            }.store(in: &cancellables)
    }
}
