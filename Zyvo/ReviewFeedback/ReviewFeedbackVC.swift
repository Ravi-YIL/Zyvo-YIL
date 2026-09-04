//
//  ReviewFeedbackVC.swift
//  Zyvo
//
//  Created by ravi on 20/11/24.
//

import UIKit
import Cosmos
import Combine


class ReviewFeedbackVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txt_MSG: UITextView!
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var view_msg: UIView!
    @IBOutlet weak var view_onTime: CosmosView!
    @IBOutlet weak var view_Communication: CosmosView!
    @IBOutlet weak var view_Response: CosmosView!
    
    private var viewModel = ReviewFeedbackViewModel()
    private var cancellables = Set<AnyCancellable>()
    var bookingID = ""
    var propertyID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        btnPublish.layer.cornerRadius =  btnPublish.layer.frame.height / 2
        
        view_msg.layer.borderWidth = 1
        view_msg.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_msg.layer.cornerRadius =  20
        setupTextView()
    }
    
    func setupTextView() {
            txt_MSG.delegate = self
            txt_MSG.text = "Message"  // Placeholder text
            txt_MSG.textColor = UIColor.lightGray  // Placeholder color
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "Message" {
                textView.text = ""
                textView.textColor = UIColor.black  // Normal text color
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = "Message"
                textView.textColor = UIColor.lightGray  // Placeholder color
            }
        }

    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnReviewPublish_Tap(_ sender: UIButton) {
        
        if view_Response.rating == 0 {
            showAlert(message: "Please provide a rating for Response.")
        } else if view_Communication.rating == 0 {
            showAlert(message: "Please provide a rating for Communication.")
        } else if view_onTime.rating == 0 {
            showAlert(message: "Please provide a rating for On Time.")
        } else if txt_MSG.text == "Message" {
            showAlert(message: "Please enter message")
        } else {
            viewModel.responseRate = Int(view_Response.rating)
            viewModel.onTime = Int(view_onTime.rating)
            viewModel.Communication = Int(view_Communication.rating)
            viewModel.reviewMSG = self.txt_MSG.text
            
            viewModel.apiForReviewHost(bookingid: self.bookingID, propertyid: self.propertyID)
        }
    }
    
    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension ReviewFeedbackVC{
    
    func bindVC(){
        viewModel.$reviewHostResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dismiss(animated: true)
                    }
                })
            }.store(in: &cancellables)
       }
}

