//
//  HostPaymentVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import Fastis
import Combine

class HostPaymentVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Variables

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private var currentValue: FastisValue? {
        didSet {
            if let rangeValue = self.currentValue as? FastisRange {
               // self.currentDateLabel.text = self.dateFormatter.string(from: rangeValue.fromDate) + " - " + self.dateFormatter
                    //.string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
               // self.currentDateLabel.text = self.dateFormatter.string(from: date)
            } else {
               // self.currentDateLabel.text = "Choose a date"
            }
        }
    }
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var stackV_Payment: UIStackView!
    @IBOutlet weak var viewHoldData: UIView!
    @IBOutlet weak var btnWidthdrawal: UIButton!
    @IBOutlet weak var lblRange: UILabel!
    @IBOutlet weak var collecV_Card: UICollectionView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var nextPaymentPriceLbl: UILabel!
    @IBOutlet weak var nextPaymentDateLbl: UILabel!
    
    let menuDropdown = DropDown()
    var filterStatus = ""
    var filtersArr = ["Set as primary","Delete"]
    var startDate = ""
    var endDate = ""
    private var viewModel = PaymentHistoryViewModel()
    var paymentHistoryData = [PaymentHistoryDataModel]()
    var addedBankDetailsData = [H_BankAccount]()
    var addedCardDetailsData = [H_Card]()
    var PayoutMethodDetailData = [H_PayoutMethodDetail]()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextPaymentPriceLbl.font = UIFont(name: "Poppins-Bold", size: 16)
        bindVC_PayoutBalence()
        bindVC()
        bindVC_GetPayoutMethods()
        bindVC_SetPrimary()
        bindVC_DeleteMethode()
        
        viewHoldData.layer.cornerRadius = 15
        viewHoldData.layer.borderWidth = 1.5
        viewHoldData.layer.borderColor = UIColor.init(red: 226/255, green: 226/255, blue: 226/255, alpha: 1).cgColor
        btnWidthdrawal.layer.cornerRadius = btnWidthdrawal.layer.frame.height / 2
        
        btnWidthdrawal.layer.borderWidth = 1
        btnWidthdrawal.layer.borderColor = UIColor.black.cgColor
        
        // Register the custom cell using the nib
        let nib = UINib(nibName: "HostCardCell", bundle: nil)
        collecV_Card.register(nib, forCellWithReuseIdentifier: "HostCardCell")
        collecV_Card.delegate = self
        collecV_Card.dataSource = self
        
        view_Search.applyRoundedStyle()
        
        //Api For GetPayoutBalence
        viewModel.apiforGetPayoutBalence()
        
        //Api For GetPayoutHistory
        let weekRange = getCurrentWeekRange()
        print("Start Date: \(weekRange.startDate), End Date: \(weekRange.endDate)")
        startDate = weekRange.startDate
        endDate = weekRange.endDate
        print(startDate,"endDate")
        if let formattedRange = formatDateRange(start: "\(startDate)", end: "\(endDate)") {
            print(formattedRange) // Output: "May 25 - May 31 2025"
            self.lblRange.text = formattedRange
        }
        viewModel.apiforGetPaymentHistory(startDate: startDate, endDate: endDate, filterStatus: self.filterStatus)
        
        
        //Api For GetPayoutMethods
        viewModel.apiforGetPayoutMethods()
       
    }
    
    private func updateStackView() {
        stackV_Payment.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Load view_tilePayment and set static height
        if let view_tilePayment = Bundle.main.loadNibNamed("ViewTitlePayment", owner: nil)?.first as? UIView {
            view_tilePayment.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = view_tilePayment.heightAnchor.constraint(equalToConstant: 50)
            heightConstraint.isActive = true
            stackV_Payment.addArrangedSubview(view_tilePayment)
        }

        if paymentHistoryData.isEmpty {
            let emptyContainer = UIView()
            emptyContainer.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = emptyContainer.heightAnchor.constraint(equalToConstant: 140)
            heightConstraint.isActive = true
            
            let noDataLbl = UILabel()
            noDataLbl.text = "No Data Found"
            noDataLbl.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
            noDataLbl.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
            noDataLbl.textAlignment = .center
            noDataLbl.translatesAutoresizingMaskIntoConstraints = false
            
            emptyContainer.addSubview(noDataLbl)
            NSLayoutConstraint.activate([
                noDataLbl.centerXAnchor.constraint(equalTo: emptyContainer.centerXAnchor),
                noDataLbl.centerYAnchor.constraint(equalTo: emptyContainer.centerYAnchor),
                noDataLbl.leadingAnchor.constraint(greaterThanOrEqualTo: emptyContainer.leadingAnchor, constant: 20),
                noDataLbl.trailingAnchor.constraint(lessThanOrEqualTo: emptyContainer.trailingAnchor, constant: -20)
            ])
            
            stackV_Payment.addArrangedSubview(emptyContainer)
        } else {
            for i in 0..<paymentHistoryData.count {
                guard let viewPaymentData = Bundle.main.loadNibNamed("viewPaymentData", owner: nil)?.first as? viewPaymentData else { continue }

                viewPaymentData.lbl_price.text = "$\(paymentHistoryData[i].bookingAmount ?? "")"
                viewPaymentData.lbl_Personname.text = paymentHistoryData[i].guestName
                viewPaymentData.lbl_date.text = paymentHistoryData[i].bookingDate

                let imgURL = AppURL.imageURL + (paymentHistoryData[i].guestProfileImage ?? "")
                viewPaymentData.img.loadImage(from: imgURL, placeholder: UIImage(named: "NoIMg"))
                viewPaymentData.img.layer.cornerRadius = viewPaymentData.img.frame.height / 2
                let status = paymentHistoryData[i].status
                switch status {
                case "pending":
                    viewPaymentData.btnpaymentStatus.setTitle("Pending", for: .normal)
                    viewPaymentData.configure(btnpaymentStatus: viewPaymentData.btnpaymentStatus)
                    viewPaymentData.btnpaymentStatus.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
                case "completed":
                    viewPaymentData.btnpaymentStatus.setTitle("Completed", for: .normal)
                    viewPaymentData.btnpaymentStatus.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1)
                case "cancelled":
                    viewPaymentData.btnpaymentStatus.setTitle("Canceled", for: .normal)
                    viewPaymentData.btnpaymentStatus.backgroundColor = .clear
                    viewPaymentData.btnpaymentStatus.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.35)
                default:
                    break
                }

                stackV_Payment.addArrangedSubview(viewPaymentData)
            }
        }

        // Trigger layout updates
        stackV_Payment.setNeedsLayout()
        stackV_Payment.layoutIfNeeded()
    }

    
    @IBAction func btnSelectDateRange_Tap(_ sender: Any) {
        
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
//        fastisController.minimumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek]

        fastisController.doneHandler = { resultRange in
            print(resultRange ?? "No range selected", "resultRange")
            if let range = resultRange {
                 let FromData = resultRange?.fromDate
                let toData = resultRange?.toDate
                let formattedRange = self.formatFastisRange(fromDate: FromData ?? Date(), toDate: toData ?? Date())
                self.lblRange.text = formattedRange
                
                let dateForApi = self.parseDateRange(dateString: formattedRange)
                self.startDate = dateForApi.StartDate ?? ""
                self.endDate = dateForApi.EndDate ?? ""
                self.viewModel.apiforGetPaymentHistory(startDate: self.startDate, endDate: self.endDate, filterStatus: self.filterStatus)
                
            } else {
                // Handle nil case if needed, e.g., pass a default range or show a message
            }
        }
        fastisController.present(above: self)

    }
    
    @IBAction func btnFitler_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostFilterVC") as! HostFilterVC
        vc.filterType = self.filterStatus
        vc.backAction = { str in
                print(str,"STR RECIEVED")
                self.filterStatus = str
                self.viewModel.apiforGetPaymentHistory(startDate: self.startDate, endDate: self.endDate, filterStatus: self.filterStatus)
            
        }
        self.present(vc, animated: true)
    }
    @IBAction func btnAddPayment_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "AddCards", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWidthrawal_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WidthrawalEarningPopUpVC") as! WidthrawalEarningPopUpVC
        self.present(vc, animated: true)
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnInfoPayment_Tap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "For 'Standard' - 'Your Withdrawal has been initiated successfully and will be deposited into your account in 3-5 business days.' For 'Instant' - 'Your Withdrawal has been initiated successfully and will be deposited into your account in 30 minutes.'"
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .any // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 270, height: 120)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
}

extension HostPaymentVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PayoutMethodDetailData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collecV_Card.dequeueReusableCell(withReuseIdentifier: "HostCardCell", for: indexPath) as! HostCardCell
        
        if PayoutMethodDetailData[indexPath.item].methodType == "Bank"{
            cell.numberLbl.text = "**** **** \(PayoutMethodDetailData[indexPath.item].last4Digitnumber ?? "")"
        }else{
            cell.numberLbl.text = "**** **** **** \(PayoutMethodDetailData[indexPath.item].last4Digitnumber ?? "")"
        }
        cell.bank_CardNameLbl.text = PayoutMethodDetailData[indexPath.item].bankName
        cell.nameLbl.text = PayoutMethodDetailData[indexPath.row].holderName
        if PayoutMethodDetailData[indexPath.item].isPrimary == true{
            cell.btnPrimary.isHidden = false
        }else{
            cell.btnPrimary.isHidden = true
        }
        cell.btnMenu.tag = indexPath.item
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped1(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func buttonTapped1(_ sender: UIButton) {
        print(sender.tag)
        
        
        // Set up the dropdown
        menuDropdown.anchorView = sender // Anchor dropdown to the button
        menuDropdown.dataSource = filtersArr
        menuDropdown.direction = .bottom
        
        menuDropdown.backgroundColor = UIColor.white
        menuDropdown.cornerRadius = 10
        menuDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        menuDropdown.layer.shadowColor = UIColor.gray.cgColor
        menuDropdown.layer.shadowOpacity = 0.2
        menuDropdown.layer.shadowRadius = 10
        menuDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = menuDropdown.anchorView?.plainView.bounds.height {
            menuDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        menuDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        menuDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            if index == 0{
                viewModel.apiforSetPrimaryMethod(id: PayoutMethodDetailData[sender.tag].id)
            }else{
                viewModel.apiforDeletePayoutMethod(id: PayoutMethodDetailData[sender.tag].id)
            }
            
        }
        // Show dropdown
        menuDropdown.show()
        }
    
}

extension HostPaymentVC{
    func formatFastisRange(fromDate: Date, toDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Format for the month and day
        dateFormatter.dateFormat = "MMM dd"
        let fromDateString = dateFormatter.string(from: fromDate)
        
        // Format for the day (for the end date)
        dateFormatter.dateFormat = "dd yyyy"
        let toDateString = dateFormatter.string(from: toDate)
        
        return "\(fromDateString) - \(toDateString)"
    }
    
    //Formating date to send into API
    func parseDateRange(dateString: String) -> (StartDate: String?, EndDate: String?) {
        let dateComponents = dateString.components(separatedBy: " - ")
        
        guard dateComponents.count == 2 else { return (nil, nil) }
        
        let firstPart = dateComponents[0].components(separatedBy: " ")
        let secondPart = dateComponents[1].components(separatedBy: " ")
        
        guard firstPart.count == 2, secondPart.count == 2 else { return (nil, nil) }
        
        let monthString = firstPart[0]  // "Feb"
        let startDay = firstPart[1]     // "26"
        let endDay = secondPart[0]      // "09"
        let year = secondPart[1]        // "2025"

        // Convert month abbreviation to month number
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        if let date = dateFormatter.date(from: monthString) {
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: date)
            
            // Get next month for the end date
            let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            let nextMonth = dateFormatter.string(from: nextMonthDate)
            
            // Format output
            let StartDate = "\(year)-\(month)-\(startDay)"
            let EndDate = "\(year)-\(nextMonth)-\(endDay)"
            
            return (StartDate, EndDate)
        }
        
        return (nil, nil)
    }
    
    //Get current week range
    func getCurrentWeekRange() -> (startDate: String, endDate: String) {
        let calendar = Calendar.current
        let today = Date()
        // Get start of the week (Monday)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        let startOfWeek = calendar.date(from: components)!
        // Get end of the week (Sunday)
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: startOfWeek)
        let endDate = formatter.string(from: endOfWeek)
        return (startDate, endDate)
    }
}
extension HostPaymentVC {
    func bindVC() {
        viewModel.$getPaymentHistoryResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        
                        self.paymentHistoryData = response.data ?? []
//                        if self.paymentHistoryData.isEmpty{
//                            self.stackV_Payment.isHidden = true
//                        }else{
//                            self.stackV_Payment.isHidden = false
//
//                        }
                        self.updateStackView()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_PayoutBalence() {
        viewModel.$getPayoutBalanceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        self.nextPaymentPriceLbl.text = "$\(response.data?.nextPayout ?? "")"
                        self.nextPaymentDateLbl.text = "On \(response.data?.nextPayoutDate ?? "")"
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_GetPayoutMethods() {
        viewModel.$getPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        self.PayoutMethodDetailData.removeAll()
                        self.addedBankDetailsData.removeAll()
                        self.addedCardDetailsData.removeAll()
                        
                        self.addedBankDetailsData = response.data?.bankAccounts ?? []
                        self.addedCardDetailsData = response.data?.cards ?? []
                        
                        for i in 0..<self.addedBankDetailsData.count{
                            let data = self.addedBankDetailsData[i]
                            self.PayoutMethodDetailData.append(H_PayoutMethodDetail(methodType: "Bank",id: data.id,last4Digitnumber: data.lastFourDigits,holderName: data.accountHolderName,expMonth: 0,expYear: 0,currency: data.currency,cardBrand: "",bankName: data.bankName,isPrimary: data.defaultForCurrency))
                        }
                        
                        for i in 0..<self.addedCardDetailsData.count{
                            let data = self.addedCardDetailsData[i]
                            self.PayoutMethodDetailData.append(H_PayoutMethodDetail(methodType: "Card",id: data.id,last4Digitnumber: data.lastFourDigits,holderName: data.brand ,expMonth: 0,expYear: 0,currency: data.currency,cardBrand: data.brand,bankName: "",isPrimary: data.defaultForCurrency))
                        }
                        
                        self.collecV_Card.updateCollecforNoData(count: self.PayoutMethodDetailData.count, msg: "No Data Found", dataLoded: true)
                        self.collecV_Card.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_SetPrimary() {
        viewModel.$SetPrimaryPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModel.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_DeleteMethode() {
        viewModel.$DeletePayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModel.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
}
extension HostPaymentVC {
    func formatDateRange(start: String, end: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end) else { return nil }
        
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: startDate)
        let endYear = calendar.component(.year, from: endDate)
        
        let displayFormatter = DateFormatter()
        
        if startYear == endYear {
            displayFormatter.dateFormat = "MMM dd"
            let startString = displayFormatter.string(from: startDate)
            let endString = displayFormatter.string(from: endDate)
            
            return "\(startString) - \(endString) \(endYear)"
        } else {
            displayFormatter.dateFormat = "MMM dd yyyy"
            let startString = displayFormatter.string(from: startDate)
            let endString = displayFormatter.string(from: endDate)
            
            return "\(startString) - \(endString)"
        }
    }
}
