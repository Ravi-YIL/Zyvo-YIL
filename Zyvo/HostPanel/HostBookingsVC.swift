//
//  HostBookingsVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import DropDown
import Combine

class HostBookingsVC: UIViewController {

    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var secrchTF: UITextField!
    
    var arrTitle = ["Katelyn Francy","Mike Jm.","Mia Williams","Emily James","Michael Kenny"]
    let filterDropdown = DropDown()
    var filtersArr = ["All Bookings","Finished","Booking Requests","Confirmed","Awaiting payment","Cancelled"]
    private var viewModel = BookingListViewModel()
    var bookingsDataArr = [BookingListDataModel]()
    var S_bookingsDataArr = [BookingListDataModel]()
    var F_bookingsDataArr = [BookingListDataModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        
        viewSearch.applyRoundedStyle()
        tblV.register(UINib(nibName: "HostBookingCell", bundle: nil), forCellReuseIdentifier: "HostBookingCell")
        tblV.delegate = self
        tblV.dataSource = self
        secrchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.apiforGetBookingsList()
    }

    
    @IBAction func btnfilter_Tap(_ sender: UIButton) {
    
        // Set up the dropdown
        filterDropdown.anchorView = sender // Anchor dropdown to the button
        filterDropdown.dataSource = filtersArr
        filterDropdown.direction = .bottom
        
        filterDropdown.backgroundColor = UIColor.white
        filterDropdown.cornerRadius = 10
        filterDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        filterDropdown.layer.shadowColor = UIColor.gray.cgColor
        filterDropdown.layer.shadowOpacity = 0.2
        filterDropdown.layer.shadowRadius = 10
        filterDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = filterDropdown.anchorView?.plainView.bounds.height {
            filterDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        filterDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
//        self.F_bookingsDataArr = self.bookingsDataArr // Save original list once
        self.F_bookingsDataArr = self.S_bookingsDataArr
        filterDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected Option: \(item)")
            print("Selected index: \(index)")
            self.secrchTF.text = ""
            self.secrchTF.resignFirstResponder()
            switch index {
            case 0:
                self.bookingsDataArr = self.F_bookingsDataArr
            case 1:
                self.bookingsDataArr = self.F_bookingsDataArr.filter { $0.bookingStatus == "finished" }
            case 2:
                self.bookingsDataArr = self.F_bookingsDataArr.filter { $0.bookingStatus == "Pending" }
            case 3:
                self.bookingsDataArr = self.F_bookingsDataArr.filter { $0.bookingStatus == "Confirmed" }
            case 4:
                self.bookingsDataArr = self.F_bookingsDataArr.filter { $0.bookingStatus == "Awaiting Payment" }
            case 5:
                self.bookingsDataArr = self.F_bookingsDataArr.filter { $0.bookingStatus == "Cancelled" }
           

            default:
                break
            }
            print(bookingsDataArr.count,"Searched Count")
            
            if self.bookingsDataArr.count == 0 {
                self.tblV.setEmptyView(message: "No Booking Found")
            }else {
                self.tblV.setEmptyView(message: "")
            }
                tblV.reloadData()
            // Perform any further actions as needed
        }
        // Show dropdown
        filterDropdown.show()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.secrchTF.text?.isEmpty ?? true {
            self.bookingsDataArr = self.S_bookingsDataArr
        } else {
            self.bookingsDataArr = self.S_bookingsDataArr.filter {
                $0.guestName?.lowercased().contains(self.secrchTF.text?.lowercased() ?? "") ?? false
            }
        }
        self.tblV.reloadData() // Reload table view to reflect changes
    }
}

extension HostBookingsVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingsDataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "HostBookingCell", for: indexPath) as! HostBookingCell
        let imgURL = AppURL.imageURL + (bookingsDataArr[indexPath.row].guestAvatar ?? "")
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
        
        cell.lbl_name.text = bookingsDataArr[indexPath.row].guestName
        cell.lbl_Date.text = bookingsDataArr[indexPath.row].bookingDate
        cell.btn2.isHidden = true
        cell.lbl_Date.isHidden = false
        cell.bteView.layer.cornerRadius = cell.bteView.frame.height/2
        if bookingsDataArr[indexPath.row].type == "extension"{
            cell.bteView.isHidden = false
        }else{
            cell.bteView.isHidden = true
        }
        
        if bookingsDataArr[indexPath.row].bookingStatus == "Pending"{
            cell.btn2.setTitleColor(UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1), for: .normal)
            cell.btn1.setTitle("Approve", for: .normal)
            cell.btn1.backgroundColor = UIColor.clear
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = true
            cell.btn2.isHidden = false
            cell.btn2.setTitle("Decline", for: .normal)
            cell.btn2.titleLabel?.font = UIFont(name: "Poppins", size: 14)!
            cell.btn2.backgroundColor = UIColor.clear
            cell.btn2.layer.borderWidth = 1
            cell.btn2.layer.borderColor = UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1).cgColor
            cell.btn2.setTitleColor(UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1), for: .normal)
            cell.lbl_Date.isHidden = true
        }else if bookingsDataArr[indexPath.row].bookingStatus == "Cancelled"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Cancelled", for: .normal)
            cell.btn1.backgroundColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10)
            cell.btn1.layer.borderWidth = 1
            cell.btn1Width.constant = 100
           
            cell.btn1.layer.borderColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10).cgColor
            cell.lbl_Date.isHidden = false
        }else if bookingsDataArr[indexPath.row].bookingStatus == "Confirmed"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Confirmed", for: .normal)
            cell.btn1.backgroundColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1)
            cell.btn1Width.constant = 105
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = false
        }else if bookingsDataArr[indexPath.row].bookingStatus == "Awaiting Payment"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Awaiting payment", for: .normal)
            cell.btn1.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
            cell.btn1Width.constant = 160
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = false
        }else if bookingsDataArr[indexPath.row].bookingStatus == "Finished"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Finished", for: .normal)
            cell.btn1.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1)
            cell.btn1Width.constant = 105
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = false
        }else{
           // cell.lbl_Date.isHidden = false
            cell.btn2.isHidden = true
//                cell.btn1.setTitle("", for: .normal)
//                cell.btn1.backgroundColor = .clear
//                cell.btn1Width.constant = 100
//                cell.btn1.layer.borderWidth = 0
//                cell.btn1.layer.borderColor = UIColor.clear.cgColor
//                cell.lbl_Date.isHidden = false
        }

        cell.btn1.tag = indexPath.row
        cell.btn2.tag = indexPath.row
        cell.btn1.addTarget(self, action: #selector(buttonTapped1(_:)), for: .touchUpInside)
        cell.btn2.addTarget(self, action: #selector(buttonTapped2(_:)), for: .touchUpInside)
        //cell.lbl_title.text = arrTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostBookingAVC") as! HostBookingAVC
        vc.bookingStatus = bookingsDataArr[indexPath.row].bookingStatus ?? ""
        vc.bookingId = bookingsDataArr[indexPath.row].bookingID ?? 0
//        if bookingsDataArr[indexPath.row].extensionId != nil {
            vc.extId = bookingsDataArr[indexPath.row].extensionId ?? 0
//        }else{
//            vc.extId = ""
//        }
//        vc.extId = String(describing: bookingsDataArr[indexPath.row].extensionId)
        
          self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped1(_ sender: UIButton) {
      
        print(sender.tag)
        
        // Retrieve the button title
            if let buttonTitle = sender.title(for: .normal) {
                if buttonTitle == "Finished" {
                    print("Button title is Finished")
                } else if  buttonTitle == "Approve" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostApproveRequestVC") as! HostApproveRequestVC
                    vc.bookingId = "\(bookingsDataArr[sender.tag].bookingID ?? 0)"
                    vc.extId = bookingsDataArr[sender.tag].extensionId
                    vc.backAction = {
                        self.viewModel.apiforGetBookingsList()
                    }
                    self.present(vc, animated: true)
                    print("Button title is Approve")
                } else if  buttonTitle == "Confirmed" {
                    print("Button title is Confirmed")
                }  else if  buttonTitle == "Awaiting payment" {
                    print("Button title is Awaiting payment")
                } else if buttonTitle == "Cancelled" {
                    print("Button title is Cancelled")
                }
            } else {
                print("Button has no title")
            }
      
    }
    
    @objc func buttonTapped2(_ sender: UIButton) {
        print(sender.tag)
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Decline" {
                print("Button title is Decline")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostDeclineRequestVC") as! HostDeclineRequestVC
                vc.bookingId = "\(bookingsDataArr[sender.tag].bookingID ?? 0)"
                vc.extId = bookingsDataArr[sender.tag].extensionId ?? 0
                vc.backAction = {
                    self.viewModel.apiforGetBookingsList()
                }
                self.present(vc, animated: true)
            }
        }
    }
}
extension HostBookingsVC {
    func bindVC() {
        viewModel.$getBookingsListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.bookingsDataArr.removeAll()
                    self.S_bookingsDataArr.removeAll()
                    self.F_bookingsDataArr.removeAll()
                    self.bookingsDataArr = response.data ?? []
                    self.S_bookingsDataArr = response.data ?? []
                    self.F_bookingsDataArr = response.data ?? []
                    print(self.bookingsDataArr,"Booking DATA ")
                    self.viewModel.apiforReadBooking()
                    if self.bookingsDataArr.count == 0 {
                        self.tblV.setEmptyView(message: "No Booking Found.")
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        viewModel.$getReadBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in

                    NotificationCenter.default.post(name: NSNotification.Name("UpdateBookingBadge"), object: nil, userInfo: ["unread_booking_count": 0])
                    
                })
            }.store(in: &cancellables)
    }
}
