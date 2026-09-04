//
//  WidthrawalEarningPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import Combine

class WidthrawalEarningPopUpVC: UIViewController {
    let dropDown = DropDown()
    
    let items = ["Standard ( 3 to 5 business days )","Instant (Fee 2%)"]
    @IBOutlet weak var txt_Reason: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var btnSelectReason: UIButton!
    @IBOutlet weak var viewSelectReason: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var btnRequestWidthrawal: UIButton!
    @IBOutlet weak var avlBlnc: UILabel!
    @IBOutlet weak var instantAvlBlnc: UILabel!
    
    var withdrawType : String?
    
    var bookingDetailViewModel = WithdrawFundVIewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRequestWidthrawal.layer.cornerRadius = btnRequestWidthrawal.layer.frame.height / 2
        btnRequestWidthrawal.layer.borderWidth = 1
        btnRequestWidthrawal.layer.borderColor = UIColor(red: 37/255, green: 40/255, blue: 73/255, alpha: 1).cgColor
        
        viewSelectReason.applyRoundedStyle()
        viewAmount.applyRoundedStyle()
        
        bindVC()
        bookingDetailViewModel.getWithdrawAmount()
        withdrawFund()
    }
    
    @IBAction func btnSelectReason_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
    dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dropDown.dataSource = items
        dropDown.direction = .bottom
       
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
            self?.txt_Reason.text =  "\(item)"
            if index == 0{
                self?.withdrawType = "standard"
            }else{
                self?.withdrawType = "instant"
            }
               }
        dropDown.show()
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnRequestWithdrawal_Tap(_ sender: UIButton) {
        guard validation() else{
            return
        }
        bookingDetailViewModel.requestWithdrawFund(Amount: self.amountTF.text ?? "", withdrawType: self.withdrawType ?? "")
//        self.dismiss(animated: true)
    }
    
    func validation() -> Bool{
        if amountTF.text == ""{
            self.AlertControllerOnr(title: "Alert!", message: "Please enter amount.", BtnTitle: "OK")
            return false
        }
        if txt_Reason.text == ""{
            self.AlertControllerOnr(title: "Alert!", message: "Please select withdrawal type.", BtnTitle: "OK")
            return false
        }
        return true
    }
}

extension WidthrawalEarningPopUpVC {
    func bindVC() {
        bookingDetailViewModel.$GetWitdrawAmountResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    if response.success == true{
                        let data = response.data
                        self.avlBlnc.text = "Available Balance : $\(data?.availableBalance ?? "")"
                        self.instantAvlBlnc.text = "Instant Available Balance : $\(data?.instantAvailableBalance ?? "")"
                    }
                })
            }.store(in: &cancellables)
    }
    
    func withdrawFund() {
        bookingDetailViewModel.$RequestWitdrawFundResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    if response.success == true{
                        let data = response.data
                        self.dismiss(animated: true)
                    }
                })
            }.store(in: &cancellables)
    }
    
}
