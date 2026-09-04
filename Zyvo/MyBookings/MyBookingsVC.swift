//
//  MyBookingsVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import DropDown

import UIKit
import DropDown
import Combine

class MyBookingsVC: UIViewController {
    
    @IBOutlet weak var tblV: UITableView!
    
    private var viewModel = MybookingViewModel()
    private var cancellables = Set<AnyCancellable>()
    var myBookingArr = [MyBookingModel]()
    var indexneedTODelete : Int? = 0
    let monthDropdown = DropDown()
    let dropDown = DropDown()
    var arr = ["All Bookings","Confirmed","Pending","Finished","Cancelled"]
    let Arr = [
        "Delete"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "MybookingCell", bundle: nil), forCellReuseIdentifier: "MybookingCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.apiForGetMyBookings(bookingstatus: "")
    }
    
    @IBAction func filterBtn(_ sender: UIButton){
        // Set up the dropdown
        
        dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dropDown.dataSource = arr
        dropDown.direction = .bottom
        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected item: \(item)")
            var selectedItem = "\(item)"
            if selectedItem == "All Bookings" {
                self?.viewModel.apiForGetMyBookings(bookingstatus: "all")
            } else if  selectedItem == "Finished" {
                self?.viewModel.apiForGetMyBookings(bookingstatus: "finished")
            } else if  selectedItem == "Confirmed" {
                self?.viewModel.apiForGetMyBookings(bookingstatus: "confirmed")
            } else if  selectedItem == "Cancelled" {
                self?.viewModel.apiForGetMyBookings(bookingstatus: "cancelled")
            } else if  selectedItem == "Pending" {
                self?.viewModel.apiForGetMyBookings(bookingstatus: "pending")
            }
        }
        dropDown.show()
    }
}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBookingArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "MybookingCell", for: indexPath) as! MybookingCell
        let data = myBookingArr[indexPath.row]
        // Configure the button based on row
            switch data.bookingStatus {
            case "Finished":
                cell.btn_title.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1)
                cell.btn_title.setTitle("Finished", for: .normal)
                cell.btnWidthConst.constant = 75
            case "Confirmed":
                cell.btn_title.backgroundColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1)
                cell.btn_title.setTitle("Confirmed", for: .normal)
                cell.btnWidthConst.constant = 90
            case "waiting_payment":
                cell.btn_title.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
                cell.btn_title.setTitle("Waiting payment", for: .normal)
                cell.btnWidthConst.constant = 130
            case "Cancelled":
                cell.btn_title.backgroundColor = UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.10)
                cell.btn_title.setTitle("Cancelled", for: .normal)
                cell.btnWidthConst.constant = 80
            case "Pending":
                cell.btn_title.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
                cell.btn_title.setTitle("Pending", for: .normal)
                cell.btnWidthConst.constant = 100
            default:
                cell.btn_title.setTitle("Pending", for: .normal)
                cell.btn_title.backgroundColor = .lightGray
                cell.btnWidthConst.constant = 80
                break
            }
        cell.lbl_title.text = data.propertyName
        let image = data.propertyImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "no_image (1)"))
        cell.lbl_date.text = data.bookingDate ?? ""
        
        // Add target with sender
        cell.btn_title.tag = indexPath.row
        cell.btn_title.removeTarget(nil, action: nil, for: .allEvents) // Clear previous targets
        cell.btnDrop.tag = indexPath.row
        cell.btnDrop.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = myBookingArr[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        vc.bookingID = "\(data.bookingID ?? 0)"
        vc.propertyID = "\(data.propertyID ?? 0)"
        vc.BookingStatus = "\(data.bookingStatus ?? "")"
        //vc.heartStatus = "\(data.wishlist ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Set up the dropdown
        monthDropdown.anchorView = sender // Anchor dropdown to the button
        monthDropdown.dataSource = Arr
        monthDropdown.direction = .bottom
        if let anchorHeight = monthDropdown.anchorView?.plainView.bounds.height {
            monthDropdown.bottomOffset = CGPoint(x: -40, y: anchorHeight)
        }
        // Handle selection
        monthDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            let bookingID =  self.myBookingArr[index].bookingID ?? 0
            indexneedTODelete = index
            viewModel.apiForCancelBooking(booking_id: bookingID)
            // Perform any further actions as needed
        }
        // Show dropdown
        monthDropdown.show()
    }
}

extension MyBookingsVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$getBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.myBookingArr = response.data ?? []
                    if self.myBookingArr.count == 0 {
                        self.tblV.setEmptyView(message: "No Booking Found")
                        
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        
        viewModel.$deletebookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.myBookingArr.remove(at: self.indexneedTODelete ?? 0)
                    if self.myBookingArr.count == 0 {
                        self.tblV.setEmptyView(message: "No Booking Found")
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
    }
}
