////
////  HostReportViolationPopUpVc.swift
////  Zyvo
////
////  Created by ravi on 2/01/25.
////
///
/////
//  HostReportViolationPopUpVc.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import Combine

class HostReportViolationPopUpVc: UIViewController,UITextViewDelegate {
    var backAction:(_ str : String ) -> () = { str in}

    @IBOutlet weak var txt_Reason: UITextField!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var stackV_Below: UIStackView!
    @IBOutlet weak var view_additionalNotes: UIView!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var additionDetailTxtV: UITextView!
    
    let dropDown = DropDown()
    var reasonArr = [ReportReasonDataModel]()
    var getResonsViewModel = getReportReasonViewModel()
    var reportViewModel = ReportViewModel()
    var groupChannel : String?
    private var viewModel = VilolationReasonViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var items = [String]()
    var bookingId : Int?
    var propertyId : Int?
    var reportReasonID : Int?
    var additionMsg = ""
    var ComingFrom = ""
    var reporter_id = ""
    var reported_user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC_Reportchat()
        bindVC_getReason()
        bindVC_ReportGuest()
        getResonsViewModel.getReviewRasons()
        
        additionDetailTxtV.delegate = self
        view_main.layer.cornerRadius = 10
        
        btnsubmit.layer.cornerRadius = btnsubmit.layer.frame.height / 2
       
        view_name.layer.cornerRadius = view_name.layer.frame.height / 2
        view_name.layer.borderWidth = 1.50
        view_name.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        stackV_Below.layer.cornerRadius = 10
        stackV_Below.layer.borderWidth = 1.50
        stackV_Below.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        view_additionalNotes.layer.cornerRadius = 10
        view_additionalNotes.layer.borderWidth = 1.50
        view_additionalNotes.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        additionDetailTxtV.font = UIFont(name: "Poppins-Regular", size: 16)
        additionDetailTxtV.text = "You can also add additional details to help us investigate further."
        additionDetailTxtV.textColor = .lightGray
       
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmitReport_Tap(_ sender: UIButton) {

        
        if txt_Reason.text == "" {
            self.showToast("Please select reason")
        } else if additionDetailTxtV.text == "You can also add additional details to help us investigate further." || self.additionDetailTxtV.text == "" {
            self.showToast("Please enter additional detail")
        } else if ComingFrom == "HostChat" {
            viewModel.apiForSubmitChatReport(reporter_id: self.reporter_id, reported_user_id: self.reported_user_id, reason: self.txt_Reason.text ?? "", message: self.additionDetailTxtV.text ?? "", reportReasonID: self.reportReasonID ?? 0, group_channel: self.groupChannel ?? "")
        }  else {
            reportViewModel.reviewGuest(booking_id: self.bookingId ?? 0, property_id: self.propertyId ?? 0, reportReasonsId: self.reportReasonID ?? 0, additionalDetails: self.additionMsg)
            
        }
         
    }
    
    @IBAction func btnSelectReason_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
    dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        let reasonList = reasonArr.compactMap { $0.reason }
        dropDown.dataSource = reasonList
        dropDown.direction = .bottom
       
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_Reason.text =  "\(item)"
            if let selectedReason = self?.reasonArr.first(where: { $0.reason == item }) {
                self?.reportReasonID = selectedReason.id
                print("Selected Reason ID: \(selectedReason.id ?? 0)")
            }
        }
        dropDown.show()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if additionDetailTxtV.text == "You can also add additional details to help us investigate further."{
            additionDetailTxtV.text = ""
            additionDetailTxtV.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.additionMsg = self.additionDetailTxtV.text
        if additionDetailTxtV.text == ""{
            additionDetailTxtV.text = "You can also add additional details to help us investigate further."
            additionDetailTxtV.textColor = .lightGray
        }
    }

}
extension HostReportViolationPopUpVc{
    func bindVC_getReason(){
        getResonsViewModel.$ReportReasonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.reasonArr = response.data ?? []
                    
                    for i in 0..<self.reasonArr.count{
                        self.items.append(self.reasonArr[i].reason ?? "")
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_ReportGuest(){
        reportViewModel.$ReportResult.receive(on: DispatchQueue.main).sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.dismiss(animated: false) {
                       self.backAction("Ravik")
                    }
            })
        }.store(in: &cancellables)
    }
    func bindVC_Reportchat() {
        // Submit Chat Report Result
        viewModel.$getSubmitChatReportResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.btnsubmit.setTitle("Submitted", for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true) {
                            self.backAction("ReportSubmitted")
                        }
                    }
                })
            }
            .store(in: &cancellables)
    }
}

//
//import UIKit
//import DropDown
//import Combine
//
//class HostReportViolationPopUpVc: UIViewController,UITextViewDelegate {
//    var backAction:(_ str : String ) -> () = { str in}
//
//    @IBOutlet weak var txt_Reason: UITextField!
//    @IBOutlet weak var btnsubmit: UIButton!
//    @IBOutlet weak var view_name: UIView!
//    @IBOutlet weak var stackV_Below: UIStackView!
//    @IBOutlet weak var view_additionalNotes: UIView!
//    @IBOutlet weak var view_main: UIView!
//    @IBOutlet weak var additionDetailTxtV: UITextView!
//    
//    let dropDown = DropDown()
//    var reasonArr = [ReportReasonDataModel]()
//    var getResonsViewModel = getReportReasonViewModel()
//    var reportViewModel = ReportViewModel()
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    var items = [String]()
//    var bookingId : Int?
//    var propertyId : Int?
//    var reportReasonID : Int?
//    var additionMsg = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        bindVC_getReason()
//        bindVC_ReportGuest()
//        getResonsViewModel.getReviewRasons()
//        
//        additionDetailTxtV.delegate = self
//        view_main.layer.cornerRadius = 10
//        
//        btnsubmit.layer.cornerRadius = btnsubmit.layer.frame.height / 2
//       
//        view_name.layer.cornerRadius = view_name.layer.frame.height / 2
//        view_name.layer.borderWidth = 1
//        view_name.layer.borderColor = UIColor.lightGray.cgColor
//        
//        stackV_Below.layer.cornerRadius = 10
//        stackV_Below.layer.borderWidth = 1
//        stackV_Below.layer.borderColor = UIColor.lightGray.cgColor
//        
//        view_additionalNotes.layer.cornerRadius = 10
//        view_additionalNotes.layer.borderWidth = 1
//        view_additionalNotes.layer.borderColor = UIColor.lightGray.cgColor
//        
//        additionDetailTxtV.text = "You can also add additional details to help us investigate further."
//        additionDetailTxtV.textColor = .lightGray
//       
//    }
//    
//    @IBAction func btnCross_Tap(_ sender: UIButton) {
//        self.dismiss(animated: true)
//    }
//    
//    @IBAction func btnSubmitReport_Tap(_ sender: UIButton) {
//        reportViewModel.reviewGuest(booking_id: self.bookingId ?? 0, property_id: self.propertyId ?? 0, reportReasonsId: self.reportReasonID ?? 0, additionalDetails: self.additionMsg)
//    }
//    
//    @IBAction func btnSelectReason_Tap(_ sender: UIButton) {
//        // Set up the dropdown
//       
//    dropDown.anchorView = sender // You can set it to a UIButton or any UIView
//        let reasonList = reasonArr.compactMap { $0.reason }
//        dropDown.dataSource = reasonList
//        dropDown.direction = .bottom
//       
//        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
//        
//        // Handle selection
//        dropDown.selectionAction = { [weak self] (index, item) in
//            // Do something with the selected month
//            print("Selected month: \(item)")
//            self?.txt_Reason.text =  "\(item)"
//            if let selectedReason = self?.reasonArr.first(where: { $0.reason == item }) {
//                self?.reportReasonID = selectedReason.id
//                print("Selected Reason ID: \(selectedReason.id ?? 0)")
//            }
//        }
//        dropDown.show()
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if additionDetailTxtV.text == "You can also add additional details to help us investigate further."{
//            additionDetailTxtV.text = ""
//            additionDetailTxtV.textColor = .black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.additionMsg = self.additionDetailTxtV.text
//        if additionDetailTxtV.text == ""{
//            additionDetailTxtV.text = "You can also add additional details to help us investigate further."
//            additionDetailTxtV.textColor = .lightGray
//        }
//    }
//
//}
//extension HostReportViolationPopUpVc{
//    func bindVC_getReason(){
//        getResonsViewModel.$ReportReasonResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                    self.reasonArr = response.data ?? []
//                    
//                    for i in 0..<self.reasonArr.count{
//                        self.items.append(self.reasonArr[i].reason ?? "")
//                    }
//                })
//            }.store(in: &cancellables)
//    }
//    
//    func bindVC_ReportGuest(){
//        reportViewModel.$ReportResult.receive(on: DispatchQueue.main).sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                    self.dismiss(animated: false) {
//                       self.backAction("Ravik")
//                    }
//            })
//        }.store(in: &cancellables)
//    }
//}
