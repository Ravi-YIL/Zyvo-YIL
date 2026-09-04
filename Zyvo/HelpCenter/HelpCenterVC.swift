//
//  HelpCenterVC.swift
//  Zyvo
//
//  Created by ravi on 7/11/24.
//

import UIKit
import Combine
class HelpCenterVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var guideLbl: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblVH_Constant: NSLayoutConstraint!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var btnHost: UIButton!
    @IBOutlet weak var btnGuest: UIButton!
    @IBOutlet weak var contactUsBtnO: UIButton!
    private var viewModel = HelpCenterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var guidesArr = [Guide]()
    var articlesArr = [Article]()
    
    var comingFrom = ""
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDetail.shared.getlogintType() == "Host"{
            self.guideLbl.text = "Guides for Hosts"
            viewModel.usertype = "host"
            self.contactUsBtnO.setTitleColor(UIColor.darkGray, for: .normal)
        }else{
            self.guideLbl.text = "Guides for Guests"
            self.contactUsBtnO.setTitleColor(UIColor.black, for: .normal)
            viewModel.usertype = "guest"
        }
        bindVC()
        viewModel.apiForGetHelpCenter()
        btnHost.isUserInteractionEnabled = false
        btnGuest.isUserInteractionEnabled = false
        tblV.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        tblV.delegate = self
        tblV.dataSource = self
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        if comingFrom == "" {
            btnHost.layer.cornerRadius = btnHost.layer.frame.height / 2
            btnHost.layer.borderWidth = 1
            btnHost.layer.borderColor = UIColor.lightGray.cgColor
            btnGuest.layer.cornerRadius = btnHost.layer.frame.height / 2
            btnGuest.layer.borderWidth = 1
            // btnGuest.layer.borderColor = UIColor.lightGray.cgColor
            btnGuest.layer.cornerRadius = btnGuest.layer.frame.height / 2
            btnGuest.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
            btnGuest.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        } else {
            btnGuest.layer.cornerRadius = btnGuest.layer.frame.height / 2
            btnGuest.layer.borderWidth = 1
            btnGuest.layer.borderColor = UIColor.lightGray.cgColor
            btnGuest.backgroundColor = UIColor.white
            btnGuest.setTitleColor(UIColor.black, for: .normal)
            
            btnHost.layer.cornerRadius = btnHost.layer.frame.height / 2
            btnHost.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
            btnHost.setTitleColor(UIColor.white, for: .normal)
            btnHost.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        }
        let nib2 = UINib(nibName: "GuestCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "GuestCell")
        collecV.delegate = self
        collecV.dataSource = self
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Constant.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        collecV.layoutIfNeeded()
        let contentHeight = collecV.contentSize.height
        // Update the height constraint
        collectionViewHeightConstraint.constant = contentHeight
        // Update the layout of the view
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnGuest_Tap(_ sender: UIButton) {
        
        btnHost.backgroundColor = UIColor.white
        btnHost.setTitleColor(UIColor.black, for: .normal)
        btnHost.layer.cornerRadius = btnHost.layer.frame.height / 2
        btnHost.layer.borderWidth = 1
        btnHost.layer.borderColor = UIColor.lightGray.cgColor
        
        btnGuest.layer.cornerRadius = btnGuest.layer.frame.height / 2
        btnGuest.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
        btnGuest.setTitleColor(UIColor.white, for: .normal)
        btnGuest.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
    }
    
    @IBAction func btnHost_Tap(_ sender: UIButton) {
        btnGuest.layer.cornerRadius = btnGuest.layer.frame.height / 2
        btnGuest.layer.borderWidth = 1
        btnGuest.layer.borderColor = UIColor.lightGray.cgColor
        btnGuest.backgroundColor = UIColor.white
        btnGuest.setTitleColor(UIColor.black, for: .normal)
        
        btnHost.layer.cornerRadius = btnHost.layer.frame.height / 2
        btnHost.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
        btnHost.setTitleColor(UIColor.white, for: .normal)
        btnHost.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
    }
    
    @IBAction func btnBrowseAllGuides_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrowseAllGuidesVC") as! BrowseAllGuidesVC
        vc.comesFrom = comingFrom
        vc.userName = self.userName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBrowseAllArticle_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrowseAllArticleVC") as! BrowseAllArticleVC
        vc.comesfrom = comingFrom
        vc.userName = self.userName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUs_Tap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HelpCenterVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  guidesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = guidesArr[indexPath.row]
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "GuestCell", for: indexPath) as! GuestCell
        cell.lbl_name.text = data.title ?? ""
        cell.lbl_Detail.isHidden = true
        var image = data.coverImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "no_image (1)"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = guidesArr[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllGuidesOpenVC") as! AllGuidesOpenVC
        vc.guideid = "\(data.id ?? 0)"
        vc.comesFrom = "Guide"
        vc.typess = "Guide"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HelpCenterVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    // MARK: - UICollectionViewDelegateFlowLayout
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 10  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 2   //Display 2 cells per row
        // Return the size with fixed height of 110
        return CGSize(width: cellWidth, height: 225)
    }
}

extension HelpCenterVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = articlesArr[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        let rawText = (self.articlesArr[indexPath.row].description ?? "").decodedHTML

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
        paragraphStyle.alignment = .justified  // Or use .left, .center, etc.

        let attributedString = NSAttributedString(
            string: rawText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label // Optional: customize color
            ]
        )

        cell.lbl_title.text = data.title ?? ""
        let a = data.description ?? ""
        cell.lbl_Desc.attributedText = attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = articlesArr[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllGuidesOpenVC") as! AllGuidesOpenVC
        vc.articleID = "\(data.id ?? 0)"
        vc.comesFrom = "Article"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HelpCenterVC {
    
    func bindVC(){
        viewModel.$getHelpCenterResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    let fname = response.data?.userFname ?? ""
                    let lname = response.data?.userLname ?? ""
                    
                    self.nameLbl.text = "Hi \(fname) \(lname), how can we help?"
                    self.userName = "\(fname) \(lname)"
                    
                    self.guidesArr = response.data?.guides ?? []
                    self.articlesArr = response.data?.articles ?? []
                    print( self.guidesArr.count," self.guidesArr")
                    print( self.articlesArr.count," self.articlesArr")
                    DispatchQueue.main.asyncAfter(deadline: .now()  ) {
                        self.collecV.reloadData()
                        self.tblV.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() ) {
                            self.updateCollectionViewHeight() }
                    }
                })
            }.store(in: &cancellables)
    }
}

