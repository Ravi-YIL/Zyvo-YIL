//
//  ListingDetailsVC.swift
//  Zyvo
//
//  Created by ravi on 25/11/24.
//

import UIKit
import DropDown
import Combine

class ListingDetailsVC: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    @IBOutlet weak var lbl_sortType: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var btnShowMoreReview: UIButton!
    @IBOutlet weak var tblV_Review: UITableView!
    
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var tblVReviewH_Const: NSLayoutConstraint!
    @IBOutlet weak var collecVListingH_Const: NSLayoutConstraint!
    @IBOutlet weak var CollecV_Listing: UICollectionView!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var viewPhoto_Frame: UIView!
    
    @IBOutlet weak var btnReadMore: UIButton!
    // var isReadMore = "no"
    var isRewReadMore = "yes"
    var count = 5
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    let items = [" Lawyer ",  "English & Hindi","New York, US"]
    var imgArr = ["myworkicon","languageicon","location line"]
    let timeDropdown = DropDown()
    
    var getHostDetailsArr : ListingDetailsModel?
    
    var propertyArr = [Property]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel = ListingDetailsViewModel()
    
    var hostid : String = ""
    
    var page = 1
    
    var totalPage : Int? = 0
    
    var reviewType = "highest_review"
    
    var isReadMore: Bool = false // Tracks whether the text is fully expanded
    var fullDescription: String = "" // Holds the full description
    var shortDescription: String = "" // Holds the trimmed version of the description
    
    var  reviewsSubArr: [FilterModel]?
    var  reviewsArr: [FilterModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bindVC()
        
        var lat = UserDetail.shared.getAppLatitude()
        var lng = UserDetail.shared.getAppLongitude()
        
        viewModel.latitude = lat
        viewModel.longitude = lng
        viewModel.apiForGetHostDetails(hostID: hostid)
        viewModel.apiForFilterData(hostID: hostid, filter: self.reviewType, page: self.page)
        
        collecV.delegate = self
        collecV.dataSource = self
        let nib2 = UINib(nibName: "BankingDetailsCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "BankingDetailsCell")
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        CollecV_Listing?.register(nib, forCellWithReuseIdentifier: "HomeCell")
        CollecV_Listing.delegate = self
        CollecV_Listing.dataSource = self
        CollecV_Listing.layer.cornerRadius = 10
        
        
        tblV_Review.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV_Review.delegate = self
        tblV_Review.dataSource = self
        
        self.tblV_Review.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        //        aboutHostH_Const.constant = 350
        
        imgProfile.layer.cornerRadius = imgProfile.layer.frame.height / 2
        
        viewPhoto_Frame.layer.cornerRadius = 20
        viewPhoto_Frame.layer.borderWidth = 1.0
        viewPhoto_Frame.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        btnShowMoreReview.layer.cornerRadius = btnShowMoreReview.layer.frame.height / 2
        btnShowMoreReview.layer.borderWidth = 1.0
        btnShowMoreReview.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        view_Search.layer.borderWidth = 1
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 4
        view_Photo.layer.borderColor = UIColor.init(red: 234/255, green: 239/255, blue: 244/255, alpha: 0.9).cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV_Review.layer.removeAllAnimations()
        tblVReviewH_Const.constant = tblV_Review.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    private func updateCollectionViewHeight() {
        // Calculate the number of rows needed
        let numberOfItems = collectionView(CollecV_Listing, numberOfItemsInSection: 0)
        let itemsPerRow: CGFloat = 1
        let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        
        // Set the item height and spacing
        let itemHeight: CGFloat = 390
        let padding: CGFloat = 10
        let totalPadding = (rows - 1) * padding
        let totalHeight = rows * itemHeight + totalPadding
        
        // Update the collection view height constraint
        collecVListingH_Const.constant = totalHeight
    }
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        
        // Toggle between read more and read less states
        isReadMore.toggle()
        
        // Set the label text based on the current state
        lblDes.text = isReadMore ? fullDescription : shortDescription
        
        // Update button image based on the state
        let imageName = isReadMore ? "Read Less" : "Read more"
        btnReadMore.setImage(UIImage(named: imageName), for: .normal)
        
        
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnViewMore_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingVC") as! ListingVC
        vc.propertyArr = self.propertyArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortReviewBtn(_ sender: UIButton){
        // Set up the dropdown
        
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            // "Highest Review","Lowest Review","Recent Reviews"]
            var str = ""
            if "\(item)" ==   "Highest Review"{
                str = "highest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Highest Review"
                
            } else if "\(item)" ==   "Lowest Review" {
                str = "lowest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Lowest Review"
            } else if "\(item)" ==   "Recent Reviews" {
                str = "recent_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Recent Reviews"
            }
            self?.isRewReadMore = "no"
            self?.page = 1
            self?.viewModel.apiForFilterData(hostID: self?.hostid ?? "", filter: self?.reviewType ?? "", page: self?.page)
            
        }
        timeDropdown.show()
        
    }
    
    @IBAction func btnMoreReview_Tap(_ sender: UIButton) {
        
        self.page = page + 1
        
        if self.isRewReadMore == "no" {
            self.isRewReadMore = "yes"
        }
        self.viewModel.apiForFilterData(hostID: self.hostid , filter: self.reviewType, page: self.page )
        
    }
    
}

extension ListingDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV {
            return items.count }
        else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankingDetailsCell", for: indexPath) as! BankingDetailsCell
            if indexPath.item == 0 {
                cell.lbl_title.text = self.getHostDetailsArr?.aboutHost?.hostProfession?.first ?? ""            } else if indexPath.item == 1 {
                    let language = self.getHostDetailsArr?.aboutHost?.language ?? []
                    cell.lbl_title.text = (language.first ?? "") + " & " + (language.last ?? "")
                } else if indexPath.item == 2 {
                    cell.lbl_title.text = self.getHostDetailsArr?.aboutHost?.location ?? ""
                }
            
            cell.img.image = UIImage(named: imgArr[indexPath.item])
            return cell
        }else {
            let cell = CollecV_Listing.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            let data = propertyArr.first
            cell.viewMain_hostedBy.isHidden = true
            cell.view_Instant.isHidden = true
            cell.btnCross.isHidden = true
            cell.btnHeart.isHidden = true
            cell.imgBookMark.isHidden = true
            
            cell.view_Instant.isHidden = true
            cell.btnCross.isHidden = true
            if indexPath.row == 0 {
                cell.view_Instant.isHidden = false
            }
            if indexPath.row == 3 {
                cell.view_Instant.isHidden = false
            }
          
            cell.lbl_name.text = data?.title ?? ""
            let rating = data?.reviewsTotalRating ?? ""
            if rating != "" {
                cell.lbl_Rating.text = rating
            } else {
                cell.lbl_Rating.text = "0.0"
            }
            let hour = data?.hourlyRate ?? ""
            let price = hour.formattedPriceString()
            if price != "" {
                cell.lbl_Time.text = "$\(price)/h"
            } else {
                cell.lbl_Time.text = ""
            }
            cell.imgArr = data?.propertyImages ?? []
            let imagesCount = data?.propertyImages?.count ?? 0
            if imagesCount == 1{
                cell.pageV.isHidden = true
            }else{
                cell.pageV.isHidden = false
                cell.pageV.currentPage = 0
                cell.pageV.numberOfPages = data?.propertyImages?.count ?? 0
            }
//            cell.pageV.currentPage = 0
//            cell.pageV.numberOfPages = data?.propertyImages?.count ?? 0
            cell.CollecV.reloadData()
           // let reviewCount = "\(data?.reviewsTotalCount?.value ?? "0")"
           // cell.lbl_NumberOfUser.text = reviewCount > "0" ? "(\(reviewCount))" : "(0)"
            
            let reviewCount = data?.reviewsTotalCount?.value ?? "(0)"
            cell.lbl_NumberOfUser.text = reviewCount > "(0)" ? "(\(reviewCount))" : "(0)"
            
            var distanceInMiles = data?.distanceMiles ?? "0"
            cell.lbl_Distance.text = "\(distanceInMiles) miles away"
            cell.view_Instant.isHidden = true
            cell.btnHeart.isHidden = true
            
            // Handle selection from inner collection view
            cell.didSelectItem = { [weak self] innerIndexPath in
                guard let self = self else { return }
                print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
                // Example: Navigate to a new view controller
                
                if let mainTabVC = self.tabBarController as? MainTabVC {
                    mainTabVC.progressBar?.isHidden = true
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                    vc.propertyDistanceInMiles = data?.distanceMiles ?? ""
                    vc.backAction = { str in
                        if str == "Ravi" {
                            mainTabVC.progressBar?.isHidden = false
                        }
                    }
                    vc.propertyID = "\(data?.propertyID ?? 0)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollecV_Listing {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePopUpVC") as! ImagePopUpVC
//            self.navigationController?.pushViewController(vc, animated: true)
            print("Heloo")
            let data = propertyArr.first
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            vc.propertyID = "\(data?.propertyID ?? 0)"
            vc.propertyDistanceInMiles = data?.distanceMiles ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CollecV_Listing {
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 1
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (CollecV_Listing.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 390 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        } else{
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 2
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (collecV.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 70 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

extension ListingDetailsVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = reviewsArr?[indexPath.row]
        let cell = tblV_Review.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        let rating = data?.reviewRating ?? "0"
        cell.viewRating.rating = Double(rating) ?? 0
        cell.lbl_name.text = data?.reviewerName ?? ""
        cell.lbl_date.text = data?.reviewDate ?? ""
        cell.lbl_desc.text = data?.reviewMessage ?? ""
        let image = data?.profileImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
        DispatchQueue.main.async {
            self.tblVReviewH_Const.constant = self.tblV_Review.contentSize.height
            self.tblV_Review.layoutIfNeeded()
        }
        
        return cell
    }
    
}
extension ListingDetailsVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$hostDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.getHostDetailsArr = response.data
                    print(self.getHostDetailsArr ?? [],"self.getHostDetailsArr")
                    
                    self.propertyArr = self.getHostDetailsArr?.properties ?? []
                    
                    self.CollecV_Listing.reloadData()
                    self.collecV.reloadData()
                    
                    self.fullDescription = self.getHostDetailsArr?.aboutHost?.description ?? ""
                    
                    // Set the shortened version, for example first 100 characters
                    let limit = 100 // Adjust the limit as needed
                    self.shortDescription = self.fullDescription.count > limit ? String(self.fullDescription.prefix(limit)) + "..." : self.fullDescription
                    
                    // Initially set the label to show the short description
                    self.lblDes.text = self.shortDescription
                    self.btnReadMore.setImage(UIImage(named: "Read more"), for: .normal)
                    self.isReadMore = false
                    
                    let host  = self.getHostDetailsArr?.host
                    
                    if (host?.name ?? "") != "" {
                        self.lbl_title.text = "\(host?.name ?? "")'s Listings" } else {
                            self.lbl_title.text = ""
                        }
                    
                    self.lbl_name.text = host?.name ?? ""
                    
                    var img = AppURL.imageURL + (host?.profilePicture ?? "")
                    
                    self.imgProfile.loadImage(from:img,placeholder: UIImage(named: "user"))
                    
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getFilterDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.reviewsSubArr?.removeAll()
                    self.reviewsSubArr = response.data
                    
                    if self.isRewReadMore == "yes" {
                        self.reviewsArr = (self.reviewsArr ?? []) + (self.reviewsSubArr ?? [])
                    } else {
                        self.reviewsArr = self.reviewsSubArr ?? []
                    }
                    let pagination = response.pagination
                    self.totalPage = pagination?.totalPages ?? 0
                    print(pagination ?? 0,"pagination")
                    print(self.totalPage ?? 0,"self.totalPage")
                    
                    if self.page == self.totalPage {
                        self.btnShowMoreReview.isHidden = true
                    } else {
                        self.btnShowMoreReview.isHidden = false
                    }
                    if self.reviewsArr?.count == 0 {
                        self.btnShowMoreReview.isHidden = true
                        self.lbl_numberOfReview.text = "Review (\(self.reviewsArr?.count ?? 0))"
                        self.tblV_Review.setEmptyView(message: "No Data Found")
                        
                    } else {
                       
                        self.tblV_Review.setEmptyView(message: "")
                        self.lbl_numberOfReview.text = "Review (\(self.reviewsArr?.count ?? 0))"
                        
                    }
                    
                    print(self.reviewsArr?.count ?? 0,"reviewsArr.count")
                    print(self.reviewsArr ?? [],"reviewsArr")
                    self.tblV_Review.reloadData()
                    
                })
            }.store(in: &cancellables)
    }
}

