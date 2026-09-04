//
//  NotificationVC.swift
//  Zyvo
//
//  Created by ravi on 6/11/24.
//

import UIKit
import Combine

class NotificationVC: UIViewController {
    
    private var viewModel = NotificationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getNotiDataArr : [NotificationModel]?
    
    var comgingFrom = ""
    
    var indx : Int? = 0
    
    @IBOutlet weak var tblV: UITableView!
    
    var dataArr = ["","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comgingFrom == "guest"{
            viewModel.apiforGetNotification()
        } else {
            viewModel.apiforGetNotificationHost()
        }
        
        
        bindVC()
        
        self.tblV.delegate = self
        self.tblV.dataSource = self
        tblV.register(UINib(nibName: "NotiCell", bundle: nil), forCellReuseIdentifier: "NotiCell")
        
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
  }

extension NotificationVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNotiDataArr?.count ?? 0//dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotiCell
        let data = getNotiDataArr?[indexPath.row]
        let notitype = data?.type ?? ""
        if notitype == "booking" {
            cell.imgIcon.image = UIImage(named: "booking 2")
        } else if notitype == "booking_auto_cancelled" {
            cell.imgIcon.image = UIImage(named: "Caminho 15897")
        } else if notitype == "payout" {
            cell.imgIcon.image = UIImage(named: "handIcon 1")
        } else {
            cell.imgIcon.image = UIImage(named: "Caminho 15897")
        }
        cell.lbl_title.text = data?.title ?? ""
        cell.lbl_Desc.text = data?.message ?? ""
        cell.cancelBtn.addTarget(self, action: #selector(deleteBtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteBtn(_ sender: UIButton){
        
        self.indx = sender.tag
        viewModel.apiforReadNotification(notiID: "\(getNotiDataArr?[sender.tag].notificationID ?? 0)")
    }
 }

extension NotificationVC {
    func bindVC(){
        viewModel.$NotiResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.success ?? false,"NotiResult")
                    if (response.success ?? false) == true {
                        
                        self.getNotiDataArr = response.data
                        
                        if self.getNotiDataArr?.count == 0 {
                            self.tblV.setEmptyView(message: "No Notifications Yet")
                        } else {
                            self.tblV.setEmptyView(message: "")
                        }
                        self.tblV.reloadData()
                        
                    }
                })
            }.store(in: &cancellables)
        
        // Read Noti
        viewModel.$readNotiResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.success ?? false,"Read Noti Result")
                    if (response.success ?? false) == true {
                        
                        self.getNotiDataArr?.remove(at: self.indx ?? 0)
                        
                        if self.getNotiDataArr?.count == 0 {
                            self.tblV.setEmptyView(message: "No Notifications Yet.")
                        } else {
                            self.tblV.setEmptyView(message: "")
                        }
                        
                        self.tblV.reloadData()
                        
                    }
                })
            }.store(in: &cancellables)
        
        
    }
}
