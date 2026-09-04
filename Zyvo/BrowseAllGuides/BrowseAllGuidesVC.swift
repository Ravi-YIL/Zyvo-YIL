//
//  BrowseAllGuidesVC.swift
//  Zyvo
//
//  Created by ravi on 8/11/24.
//

import UIKit
import Combine

class BrowseAllGuidesVC: UIViewController {
    
    @IBOutlet weak var view_Host: UIView!
    @IBOutlet weak var view_Guest: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tblV_H: NSLayoutConstraint!
    
    @IBOutlet weak var lblH_Constant: NSLayoutConstraint!
    @IBOutlet weak var lbl_Types: UILabel!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var NeedTxtView: UIView!
    @IBOutlet weak var contactUsBtnO: UIButton!
    @IBOutlet weak var btnHost: UIButton!
    @IBOutlet weak var btnGuest: UIButton!
    
    
    @IBOutlet weak var secrchTF: UITextField!
    private var viewModel = AllGuidesViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var allGuidesArr = [AllGuidesModel]()
    var S_allGuidesArr = [AllGuidesModel]()
    var comesFrom = ""
    var userName = ""
    var comingFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLbl.text = "Hi \(userName), how can we help?"
        bindVC()
        NeedTxtView.isHidden = true
        view_Host.isHidden = true
        view_Guest.isHidden = true
        
        if self.comesFrom == "" {
            self.viewModel.usertype = "guest"
            self.contactUsBtnO.isHidden = false
            self.NeedTxtView.isHidden = true
            self.view_Host.isHidden = true
            self.view_Guest.isHidden = false
            self.btnHost.layer.cornerRadius = self.btnHost.layer.frame.height / 2
            self.btnHost.layer.borderWidth = 1
            self.btnHost.layer.borderColor = UIColor.lightGray.cgColor
            self.btnGuest.layer.cornerRadius = self.btnHost.layer.frame.height / 2
            self.btnGuest.layer.borderWidth = 1
            // btnGuest.layer.borderColor = UIColor.lightGray.cgColor
            self.btnGuest.layer.cornerRadius = self.btnGuest.layer.frame.height / 2
            self.btnGuest.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
            self.btnGuest.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        } else {
            
            self.NeedTxtView.isHidden = false
            self.contactUsBtnO.isHidden = true
            self.viewModel.usertype = "host"
            
            self.view_Host.isHidden = false
            self.view_Guest.isHidden = true
            self.btnGuest.layer.cornerRadius = self.btnGuest.layer.frame.height / 2
            self.btnGuest.layer.borderWidth = 1
            self.btnGuest.layer.borderColor = UIColor.lightGray.cgColor
            self.btnGuest.backgroundColor = UIColor.white
            self.btnGuest.setTitleColor(UIColor.black, for: .normal)
            
            self.btnHost.layer.cornerRadius = self.btnHost.layer.frame.height / 2
            self.btnHost.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
            self.btnHost.setTitleColor(UIColor.white, for: .normal)
            self.btnHost.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        }
       
        searchV.layer.cornerRadius = searchV.layer.frame.height / 2
        searchV.layer.borderWidth = 1
        searchV.layer.borderColor = UIColor.lightGray.cgColor
        tblV.register(UINib(nibName: "BrowseAllArticleCell", bundle: nil), forCellReuseIdentifier: "BrowseAllArticleCell")
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tblV.delegate = self
        tblV.dataSource = self
        
        viewModel.apiForGetAllBrowseGuides()
        secrchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblV_H.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUsBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.secrchTF.text?.isEmpty ?? true {
            self.allGuidesArr = self.S_allGuidesArr
        } else {
            self.allGuidesArr = self.S_allGuidesArr.filter {
                $0.title?.lowercased().contains(self.secrchTF.text?.lowercased() ?? "") ?? false
            }
        }
        self.tblV.reloadData() // Reload table view to reflect changes
    }
    
}

extension BrowseAllGuidesVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGuidesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = allGuidesArr[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "BrowseAllArticleCell", for: indexPath) as! BrowseAllArticleCell
        cell.lbl_title.text = data.title ?? ""//arrName[indexPath.item]
       // cell.lbl_Desc.isHidden = true
        
        var image = data.coverImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "no_image (1)"))
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let data = allGuidesArr[indexPath.row]
        
        let vc = sb.instantiateViewController(withIdentifier: "AllGuidesOpenVC") as! AllGuidesOpenVC
        vc.typess = "Guide"
        vc.comesFrom = "Guide"
        vc.guideid = "\(data.id ?? 0)"
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BrowseAllGuidesVC {
    
    func bindVC(){
        viewModel.$getAllBrowseGuidesResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.allGuidesArr = response.data ?? []
                    self.S_allGuidesArr = response.data ?? []
                    print( self.allGuidesArr.count," self.allArticleArr")
                    DispatchQueue.main.asyncAfter(deadline: .now()  ) {
                        
                        self.tblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
}

