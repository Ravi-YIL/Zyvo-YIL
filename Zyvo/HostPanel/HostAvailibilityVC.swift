//
//  HostAvailibilityVC.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit
import DropDown

class HostAvailibilityVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var buttons: [UIButton]!
//    @IBOutlet weak var view_Addons1: UIView!
//    @IBOutlet weak var view_Addons2: UIView!
    @IBOutlet weak var addsOnTF: UITextField!
    @IBOutlet weak var addCleaningPriceTf: UITextField!
    @IBOutlet weak var view_AvailibilityFrom: UIView!
    
    @IBOutlet weak var btnWeekends: UIButton!
    @IBOutlet weak var btnWorkingDays: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var view_AvailibilityTo: UIView!
    @IBOutlet weak var view_SelectMinimumPrices: UIView!
    @IBOutlet weak var view_SelectMinimumHours: UIView!
    
    @IBOutlet weak var miniHrs_HrsTf: UITextField!
    @IBOutlet weak var miniHrs_PriceTf: UITextField!
    
    @IBOutlet weak var bulkDiscount_HrsTf: UITextField!
    @IBOutlet weak var bulkDiscount_DiscountTf: UITextField!
    
    @IBOutlet weak var view_SelectBulkMinimumPrices: UIView!
    @IBOutlet weak var view_SelectBulkHours: UIView!
    
    @IBOutlet weak var view_AddCleaningPrices: UIView!
    @IBOutlet weak var view_AddCleaningMinHours: UIView!
    
    @IBOutlet weak var miniHrs_HrsDropImg: UIImageView!
    @IBOutlet weak var miniHrs_PriceDropImg: UIImageView!
    @IBOutlet weak var bulkDis_HrsDropImg: UIImageView!
    @IBOutlet weak var bulkDis_PriceDropImg: UIImageView!
    @IBOutlet weak var addOnsCollectionV: UICollectionView!
    
    @IBOutlet weak var fromTimeTF: UITextField!
    @IBOutlet weak var toTimeTF: UITextField!
    
    @IBOutlet weak var lbl_month: UILabel!
    @IBOutlet weak var lbl_to: UILabel!
    @IBOutlet weak var lbl_From: UILabel!
    @IBOutlet weak var lbl_availHours: UILabel!
    @IBOutlet weak var lbl_days: UILabel!
    @IBOutlet weak var lbl_AvailDays: UILabel!
    @IBOutlet weak var lbl_addCleaning: UILabel!
    @IBOutlet weak var lbl_addOns: UILabel!
    @IBOutlet weak var lbl_bulkDiscount: UILabel!
    @IBOutlet weak var lbl_minHours: UILabel!
    
    let hrsDropdown = DropDown()
    let priceDropdown = DropDown()
    var hrsArr: [String] = ["2 hours minimum","3 hours minimum","4 hours minimum","5 hours minimum","6 hours minimum","7 hours minimum","8 hours minimum","9 hours minimum","10 hours minimum","11 hours minimum","12 hours minimum","13 hours minimum","14 hours minimum","15 hours minimum","16 hours minimum","17 hours minimum","18 hours minimum","19 hours minimum","20 hours minimum","21 hours minimum","22 hours minimum","23 hours minimum"]
    var priceArr: [String] = ["$10 per hour","$20 per hour","$30 per hour","$40 per hour","$50 per hour","$60 per hour","$70 per hour","$80 per hour","$90 per hour","$100 per hour","$120 per hour","$130 per hour"]
    var discountArr: [String] = ["0% Discount","5% Discount","10% Discount","15% Discount","20% Discount","25% Discount","30% Discount","35% Discount","40% Discount","45% Discount","50% Discount","75% Discount"]
    var addOnsArr = [addonsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
//        view_Addons1.isHidden = true
//        view_Addons2.isHidden = true
        
        let nib1 = UINib(nibName: "MasterCell", bundle: nil)
        addOnsCollectionV?.register(nib1, forCellWithReuseIdentifier: "MasterCell")
        addOnsCollectionV.delegate = self
        addOnsCollectionV.dataSource = self
        
        view_AvailibilityFrom.applyRoundedStyle()
        view_AvailibilityTo.applyRoundedStyle()
        view_SelectMinimumPrices.applyRoundedStyle()
        view_SelectMinimumHours.applyRoundedStyle()
        view_SelectBulkMinimumPrices.applyRoundedStyle()
        view_SelectBulkHours.applyRoundedStyle()
        view_AddCleaningPrices.applyRoundedStyle()
        view_AddCleaningMinHours.applyRoundedStyle()
        
//        addsOnTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addCleaningPriceTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.updatePropertyDetails()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField == addsOnTF{
//            SingltonClass.shared.title = addsOnTF.text ?? ""
//            print("Text field value updated: \(addsOnTF.text ?? "")")
//        }else if textField == addCleaningPriceTf{
            SingltonClass.shared.addCleaningFees = addCleaningPriceTf.text ?? ""
            print("Text field value updated: \(addCleaningPriceTf.text ?? "")")
//        }
     }
    
    private func setupButtons() {
        for button in buttons {
            let formattedIndex = String(format: "%02d", button.tag)
            if SingltonClass.shared.avilabilityMonth.contains(formattedIndex) {
                button.backgroundColor = .white
            } else {
                button.backgroundColor = .clear
            }
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        let formattedIndex = String(format: "%02d", index)
        
        if formattedIndex == "00" {
            if SingltonClass.shared.avilabilityMonth.contains("00") {
                SingltonClass.shared.avilabilityMonth.removeAll()
            } else {
                SingltonClass.shared.avilabilityMonth = ["00"]
            }
        } else {
            SingltonClass.shared.avilabilityMonth.removeAll { $0 == "00" }
            if SingltonClass.shared.avilabilityMonth.contains(formattedIndex) {
                SingltonClass.shared.avilabilityMonth.removeAll { $0 == formattedIndex }
            } else {
                SingltonClass.shared.avilabilityMonth.append(formattedIndex)
            }
        }
        
        for button in buttons {
            let buttonIndex = String(format: "%02d", button.tag)
            if SingltonClass.shared.avilabilityMonth.contains(buttonIndex) {
                button.backgroundColor = .white
            } else {
                button.backgroundColor = .clear
            }
        }
        print(SingltonClass.shared.avilabilityMonth)
    }
    
    @IBAction func miniHr_HrsDropBtn(_ sender: UIButton){
        // Set up the dropdown
        hrsDropdown.anchorView = sender // Anchor dropdown to the button
        hrsDropdown.dataSource = hrsArr
        hrsDropdown.direction = .bottom
        
        hrsDropdown.backgroundColor = UIColor.white
        hrsDropdown.cornerRadius = 10
        hrsDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        hrsDropdown.layer.shadowColor = UIColor.gray.cgColor
        hrsDropdown.layer.shadowOpacity = 0.2
        hrsDropdown.layer.shadowRadius = 10
        hrsDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = hrsDropdown.anchorView?.plainView.bounds.height {
            hrsDropdown.bottomOffset = CGPoint(x: 0, y: anchorHeight)
        }
        // Handle selection
        hrsDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            
            let selectedIndex = index
            if selectedIndex < hrsArr.count {
                if let extractedNumber = extractNumber(from: hrsArr[selectedIndex]) {
                    print(extractedNumber) // Output: 3
                    SingltonClass.shared.miniHrsPric_HrsMini = "\(extractedNumber)"
                } else {
                    print("No number found")
                }
            } else {
                print("Invalid index")
            }
            self.miniHrs_HrsTf.text = item
            miniHrs_HrsDropImg.image = UIImage(named: "dropdownicon")
            
//            self.lbl_cancelReason.text = "\(item)"

        }
        // Show dropdown
        hrsDropdown.cancelAction = {
            self.miniHrs_HrsDropImg.image = UIImage(named: "dropdownicon")
        }
        hrsDropdown.show()
        
    }
    
    @IBAction func miniHr_PriceDropBtn(_ sender: UIButton){
        // Set up the dropdown
        priceDropdown.anchorView = sender // Anchor dropdown to the button
        priceDropdown.dataSource = priceArr
        priceDropdown.direction = .bottom
        
        priceDropdown.backgroundColor = UIColor.white
        priceDropdown.cornerRadius = 10
        priceDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        priceDropdown.layer.shadowColor = UIColor.gray.cgColor
        priceDropdown.layer.shadowOpacity = 0.2
        priceDropdown.layer.shadowRadius = 10
        priceDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = priceDropdown.anchorView?.plainView.bounds.height {
            priceDropdown.bottomOffset = CGPoint(x: 0, y: anchorHeight)
        }
        // Handle selection
        priceDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            let selectedIndex = index
            if selectedIndex < priceArr.count {
                let priceString = priceArr[selectedIndex]
                let digits = priceString.filter { $0.isNumber } // Extracts only numbers
                if let price = Int(digits) {
                    print(price) // Output: 20 for index 1
                    SingltonClass.shared.miniHrsPric_perHrs = "\(price)"
                }
            }
            self.miniHrs_PriceTf.text = item
            miniHrs_PriceDropImg.image = UIImage(named: "dropdownicon")
//            self.lbl_cancelReason.text = "\(item)"

        }
        // Show dropdown
        priceDropdown.cancelAction = {
            self.miniHrs_PriceDropImg.image = UIImage(named: "dropdownicon")
        }
        priceDropdown.show()
        
    }
    
    @IBAction func bulkDis_HrsDropBtn(_ sender: UIButton){
        // Set up the dropdown
        priceDropdown.anchorView = sender // Anchor dropdown to the button
        priceDropdown.dataSource = hrsArr
        priceDropdown.direction = .bottom
        
        priceDropdown.backgroundColor = UIColor.white
        priceDropdown.cornerRadius = 10
        priceDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        priceDropdown.layer.shadowColor = UIColor.gray.cgColor
        priceDropdown.layer.shadowOpacity = 0.2
        priceDropdown.layer.shadowRadius = 10
        priceDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = priceDropdown.anchorView?.plainView.bounds.height {
            priceDropdown.bottomOffset = CGPoint(x: 0, y: anchorHeight)
        }
        // Handle selection
        priceDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            let selectedIndex = index
            if selectedIndex < hrsArr.count {
                if let extractedNumber = extractNumber(from: hrsArr[selectedIndex]) {
                    print(extractedNumber) // Output: 3
                    SingltonClass.shared.bulkDis_HrsMini = "\(extractedNumber)"
                    print(SingltonClass.shared.bulkDis_HrsMini, "<<<<<<BulkDis")
                } else {
                    print("No number found")
                }
            } else {
                print("Invalid index")
            }
            self.bulkDiscount_HrsTf.text = item
            bulkDis_HrsDropImg.image = UIImage(named: "dropdownicon")
//            self.lbl_cancelReason.text = "\(item)"
        }
        // Show dropdown
        priceDropdown.cancelAction = {
            self.bulkDis_HrsDropImg.image = UIImage(named: "dropdownicon")
        }
        priceDropdown.show()
        
    }
    
    @IBAction func bulkDis_PriceDropBtn(_ sender: UIButton){
        // Set up the dropdown
        priceDropdown.anchorView = sender // Anchor dropdown to the button
        priceDropdown.dataSource = discountArr
        priceDropdown.direction = .bottom
        
        priceDropdown.backgroundColor = UIColor.white
        priceDropdown.cornerRadius = 10
        priceDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        priceDropdown.layer.shadowColor = UIColor.gray.cgColor
        priceDropdown.layer.shadowOpacity = 0.2
        priceDropdown.layer.shadowRadius = 10
        priceDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = priceDropdown.anchorView?.plainView.bounds.height {
            priceDropdown.bottomOffset = CGPoint(x: 0, y: anchorHeight)
        }
        
        // Handle selection
        priceDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected discount: \(item)")
            let digits = item.filter { $0.isNumber }
            SingltonClass.shared.bulkDis_Discount = digits.isEmpty ? "0" : digits
            print("Singlton bulkDis_Discount updated dynamically to: \(SingltonClass.shared.bulkDis_Discount)")
            self.bulkDiscount_DiscountTf.text = item
            self.bulkDis_PriceDropImg.image = UIImage(named: "dropdownicon")
        }
        
        // Show dropdown
        priceDropdown.cancelAction = {
            self.bulkDis_PriceDropImg.image = UIImage(named: "dropdownicon")
        }
        priceDropdown.show()
    }
    
    @IBAction func btnAll_Taps(_ sender: Any) {
        SingltonClass.shared.avilabilityDays = "all"
        btnAll.layer.backgroundColor = UIColor.white.cgColor
        btnWorkingDays.layer.backgroundColor = UIColor.clear.cgColor
        btnWeekends.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @IBAction func btnWorking_Taps(_ sender: Any) {
        SingltonClass.shared.avilabilityDays = "working_days"
        btnAll.layer.backgroundColor = UIColor.clear.cgColor
        btnWorkingDays.layer.backgroundColor = UIColor.white.cgColor
        btnWeekends.layer.backgroundColor = UIColor.clear.cgColor
    }

    @IBAction func btnWeekends_Taps(_ sender: Any) {
        SingltonClass.shared.avilabilityDays = "weekends"
        btnAll.layer.backgroundColor = UIColor.clear.cgColor
        btnWorkingDays.layer.backgroundColor = UIColor.clear.cgColor
        btnWeekends.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @available(iOS 13.4, *)
    @IBAction func startTimeBtn(_ sender: UIButton){
        // Create the alert controller
              let alertController = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
              
              // Create the UIDatePicker
              let datePicker = UIDatePicker()
              datePicker.datePickerMode = .time
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = Locale(identifier: "en_US_POSIX")
              // Add the UIDatePicker to the alert controller
              alertController.view.addSubview(datePicker)
              
              // Add constraints to position the date picker
              NSLayoutConstraint.activate([
                  datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
                  datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
                  datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
                  datePicker.heightAnchor.constraint(equalToConstant: 150)
              ])
              
              // Add an OK action
              alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                  let selectedTime = datePicker.date
                  let formatter = DateFormatter()
                  formatter.timeStyle = .short
                  print("Selected Time: \(formatter.string(from: selectedTime))")
                  self.fromTimeTF.text = formatter.string(from: selectedTime)
                  let formattedTime = self.convertTo24HourFormat(date: selectedTime)
                  SingltonClass.shared.avilabilityHrsFrom = formattedTime
                  print(SingltonClass.shared.avilabilityHrsFrom ?? "")
              }))
              
              // Add a Cancel action
              alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              
              // Adjust the height of the alert to fit the date picker
              let height = NSLayoutConstraint(item: alertController.view!,attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1,
                                              constant: 300)
              alertController.view.addConstraint(height)
              
              // Present the alert controller
              self.present(alertController, animated: true, completion: nil)
    }
    
    @available(iOS 13.4, *)
    @IBAction func endTimeBtn(_ sender: UIButton){
        // Create the alert controller
              let alertController = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
              
              // Create the UIDatePicker
              let datePicker = UIDatePicker()
              datePicker.datePickerMode = .time
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = Locale(identifier: "en_US_POSIX")
              // Add the UIDatePicker to the alert controller
              alertController.view.addSubview(datePicker)
              
              // Add constraints to position the date picker
              NSLayoutConstraint.activate([
                  datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
                  datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
                  datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
                  datePicker.heightAnchor.constraint(equalToConstant: 150)
              ])
              
              // Add an OK action
              alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                  let selectedTime = datePicker.date
                  let formatter = DateFormatter()
                  formatter.timeStyle = .short
                  print("Selected Time: \(formatter.string(from: selectedTime))")
                  self.toTimeTF.text = formatter.string(from: selectedTime)
                  let formattedTime = self.convertTo24HourFormat(date: selectedTime)
                  SingltonClass.shared.avilabilityHrsTo = formattedTime
                  print(SingltonClass.shared.avilabilityHrsTo ?? "")
              }))
              
              // Add a Cancel action
              alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              
              // Adjust the height of the alert to fit the date picker
              let height = NSLayoutConstraint(item: alertController.view!,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 300)
              alertController.view.addConstraint(height)
              
              // Present the alert controller
              self.present(alertController, animated: true, completion: nil)
    }
    
    // Use to send time to API
    func convertTo24HourFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        return formatter.string(from: date)
    }
    
    // Use to convert time to show from API
    func convertTo12HourFormat(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Input format (24-hour)
        
        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "hh:mm a" // Output format (12-hour)
            return dateFormatter.string(from: date)
        } else {
            return "06:00 AM"
        }
    }
    func updatePropertyDetails(){
        self.miniHrs_HrsTf.text = "\(self.ConvertNumber(num: SingltonClass.shared.miniHrsPric_HrsMini)) hour minimum"
        if miniHrs_HrsTf.text == "1 hour minimum"{
            self.miniHrs_HrsTf.text = "2 hour minimum"
        }
        
        self.miniHrs_PriceTf.text = "$\(self.ConvertNumber(num: SingltonClass.shared.miniHrsPric_perHrs)) per hour"
        
        self.bulkDiscount_HrsTf.text = "\(SingltonClass.shared.bulkDis_HrsMini) hour minimum"
        if bulkDiscount_HrsTf.text == "1 hour minimum"{
            self.bulkDiscount_HrsTf.text = "2 hour minimum"
            print(SingltonClass.shared.bulkDis_HrsMini, "<<<<<<BulkDis")
        }
        self.bulkDiscount_DiscountTf.text = "\(self.ConvertNumber(num:SingltonClass.shared.bulkDis_Discount))% Discount"
        self.addOnsArr = SingltonClass.shared.addOns
        self.addOnsCollectionV.reloadData()
        self.addCleaningPriceTf.text = self.ConvertNumber(num:SingltonClass.shared.addCleaningFees ?? "")
//        if self.addCleaningPriceTf.text == "0"{
//            self.addsOnTF.text = ""
//        }
        if SingltonClass.shared.avilabilityDays == "all"{
            btnAll.layer.backgroundColor = UIColor.white.cgColor
            btnWorkingDays.layer.backgroundColor = UIColor.clear.cgColor
            btnWeekends.layer.backgroundColor = UIColor.clear.cgColor
        }else if SingltonClass.shared.avilabilityDays == "working_days"{
            btnAll.layer.backgroundColor = UIColor.clear.cgColor
            btnWorkingDays.layer.backgroundColor = UIColor.white.cgColor
            btnWeekends.layer.backgroundColor = UIColor.clear.cgColor
        }else{
            btnAll.layer.backgroundColor = UIColor.clear.cgColor
            btnWorkingDays.layer.backgroundColor = UIColor.clear.cgColor
            btnWeekends.layer.backgroundColor = UIColor.white.cgColor
        }
        
        let month = getMonthName(from: SingltonClass.shared.avilabilityMonth)
        
        for button in buttons {
            let formattedIndex = String(format: "%02d", button.tag)
            if SingltonClass.shared.avilabilityMonth.contains(formattedIndex) {
                button.backgroundColor = .white
            } else {
                button.backgroundColor = .clear
            }
        }
        
        let FromTime = convertTo12HourFormat(time: SingltonClass.shared.avilabilityHrsFrom ?? "")
        self.fromTimeTF.text = FromTime
        
        let toTime = convertTo12HourFormat(time: SingltonClass.shared.avilabilityHrsTo ?? "")
        self.toTimeTF.text = toTime
    }
    
    func getMonthName(from codes: [String]) -> String {
        let monthMap: [String: String] = [
            "00": "All",
            "01": "Jan", "02": "Feb", "03": "Mar", "04": "Apr",
            "05": "May", "06": "Jun", "07": "Jul", "08": "Aug",
            "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dec"
        ]
        
        return codes.compactMap { monthMap[$0] ?? $0 }.joined(separator: ", ")
    }
    
    func ConvertNumber(num: String) -> String{
        let stringNumber = num
        var result : String
        let doubleValue = Double(stringNumber) ?? 0.0
            let intValue = Int(doubleValue)
            result = String(intValue)
            print(result) // Output: "3"
            
        return result
    }
    
}
extension HostAvailibilityVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.addOnsArr.count == 0{
            return 1
        }else if self.addOnsArr.count >= 2{
            return self.addOnsArr.count
            
        }else{
            return self.addOnsArr.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
        cell.view_Type.isHidden = true
        if indexPath.item < self.addOnsArr.count {
            // Display language name for regular cells
            let language = self.addOnsArr[indexPath.item]
            cell.view_main.isHidden = false
            cell.view_AddNew.isHidden = true
            
            cell.btnCross.tag = indexPath.row
            cell.imgicon.image = UIImage(named: "hobbiesicon")
            //cell.imgAddicon.image = UIImage(named: "myworkicon")
            
            cell.btnCross.addTarget(self, action: #selector(self.DeleteHobbies(sender:)), for: .touchUpInside)
            
            var price = ""
            let priceString = addOnsArr[indexPath.row].price ?? ""

            if let priceDouble = Double(priceString) {
                let formattedPrice: String
                if priceDouble.truncatingRemainder(dividingBy: 1) == 0 {
                    // Whole number — show without decimals
                    formattedPrice = String(format: "%.0f", priceDouble)
                } else {
                    // Has decimal — keep two digits
                    formattedPrice = String(format: "%.2f", priceDouble)
                }
                print(formattedPrice)
                price = formattedPrice // e.g., "20" or "20.50"
            } else {
                print("Invalid price")
            }
            
            cell.lbl_title.text = "\(addOnsArr[indexPath.row].name ?? "") $\(price)"  // Assuming you have a label for displaying the language
            //cell.lbl_title.sizeToFit()
        } else {
            // Last index, show "Add New" button
            cell.view_main.isHidden = true
            cell.view_AddNew.isHidden = false
            cell.btnAddNew.tag = indexPath.row
//            types = "AddOns"
            cell.txt_Workname.delegate = self
            cell.btnAddNew.addTarget(self, action: #selector(self.addNewAddons(sender:)), for: .touchUpInside)
        }
        return cell
    }
    

    // MARK: - Add or Delete Hobbies
    @objc func addNewAddons (sender: UIButton) {
        print(sender.tag)
        guard let cell = addOnsCollectionV.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOnsPopUpVC") as! AddOnsPopUpVC
        vc.backAction = { str,price in
            cell.imgAddicon.image = UIImage(named: "hobbiesicon")
                self.addOnsArr.append(contentsOf: [addonsData(name: str,price: price)])
            SingltonClass.shared.addOns = self.addOnsArr
            print(SingltonClass.shared.addOns , "<<Singlton")
                cell.txt_Workname.text = "\(str) $\(price)"
                print(self.addOnsArr)
                self.addOnsCollectionV.reloadData()
        }
        self.present(vc, animated: true)
    }

    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        addOnsArr.remove(at: sender.tag)
        SingltonClass.shared.addOns.remove(at: sender.tag)
        print(SingltonClass.shared.addOns ,"<<Singlton")
        self.addOnsCollectionV.reloadData()
    }
    
    
    func extractNumber(from text: String) -> Int? {
        return Int(text.components(separatedBy: " ").first ?? "")
    }
    
}
