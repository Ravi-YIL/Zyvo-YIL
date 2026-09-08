//
//  EditWishListVC.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit
import Combine

class EditWishListVC: UIViewController {
    @IBOutlet weak var collecV: UICollectionView!
    
    var data = ["","","","","","","","","","","",""]
    
    var crossStatus = "false"
  //  var indexNeedtoBeDeleted = 0
    
    private var viewModel = ItemsInWishlistViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getItemsArr : [ItemsInWishlistModel]?
    
    var  WishlistID = ""
    var  WishlistName = ""

    @IBOutlet weak var lbl_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(WishlistName)
        self.lbl_name.text = "\(self.WishlistName + " " + "Wishlist")"
        bindVC()
        viewModel.wishlistID = self.WishlistID
        
        DispatchQueue.main.async {
            self.viewModel.apiForGetItemsInWishList()
        }

        // Register the WishlistCell nib file
        // let nib = UINib(nibName: "WishlistCell", bundle: nil)
        // collecV.register(nib, forCellWithReuseIdentifier: "WishlistCell")
        
        let nib2 = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ((self.tabBarController?.tabBar.isHidden) != nil) {
            var frame = view.frame
            frame.size.height = UIScreen.main.bounds.height
            view.frame = frame
        }
    }
    
    @IBAction func btnEdit_Tap(_ sender: UIButton) {
//        crossStatus = "true"
//        self.collecV.reloadData()
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension EditWishListVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItemsArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = getItemsArr?[indexPath.item]
        cell.view_Instant.isHidden = true
        cell.btnCross.isHidden = true
        cell.imgBookMark.isHidden = true
        cell.viewMain_hostedBy.isHidden = false
       // cell.btnImgDistance.isHidden = true
       
        cell.lbl_name.text = data?.title //"\(WishlistName + " " + ("Wishlist"))"
        let rating = data?.rating ?? "0"
        if rating != "0" {
            cell.lbl_Rating.text = "\(rating.formattedToDecimal())"
        } else {
            cell.lbl_Rating.text = "0.0"
        }
        let hour = data?.hourlyRate ?? ""
        if hour != "" {
            cell.lbl_Time.text = "$\(hour.formattedPriceString())/h"
        } else {
            cell.lbl_Time.text = ""
        }
        
        let distanceInMiles = data?.location_in_miles ?? ""
        cell.lbl_Distance.text = "\(distanceInMiles) miles away"
       
        cell.imgArr = data?.images ?? []
        print(data?.hostName)
        cell.lbl_NameHostedBy.text = "Hosted by \((data?.hostName ?? "").abbreviatedHostName)"
        cell.lbl_AddressHostedby.text = data?.hostAddress ?? ""
        cell.btnImgDistance.isHidden = true
        //cell.lbl_Distance.isHidden = true
        let hostProfileImgUrl = data?.hostProfileImageUrl ?? ""
       
        let imgURL = AppURL.imageURL + hostProfileImgUrl
        cell.imgHostedBy.loadImage(from:imgURL,placeholder: UIImage(named: ""))
        
        let imagesCount = data?.images?.count ?? 0
        if imagesCount == 1{
            cell.pageV.isHidden = true
        }else{
            cell.pageV.isHidden = false
            cell.pageV.currentPage = 0
            cell.pageV.numberOfPages = data?.images?.count ?? 0
        }
//        cell.pageV.currentPage = 0
//        cell.pageV.numberOfPages = data?.images?.count ?? 0
        cell.CollecV.reloadData()
       
        let reviewCount = data?.reviewCount ?? "(0)"
        cell.lbl_NumberOfUser.text = reviewCount > "(0)" ? "(\(reviewCount))" : "(0)"
        
        let heartStatus = data?.isInWishlist ?? 0
        // let distanceInMiles = data?.distanceMiles ?? "0"
       // cell.lbl_Distance.isHidden = true
        if heartStatus == 0 {
            cell.btnHeart.setImage(UIImage(named: "hearticons"), for: .normal)
        } else {
            cell.btnHeart.setImage(UIImage(named: "day"), for: .normal)
        }
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
          
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
//                vc.backAction = { str in
//                    if str == "Ravi" {
//                        mainTabVC.progressBar?.isHidden = false
//                    }
//                }
            vc.propertyDistanceInMiles = "\(data?.location_in_miles ?? "")"
                vc.propertyID = "\(data?.propertyID ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            //}
        }
        return cell
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let data = getItemsArr?[sender.tag]
        self.viewModel.apiforRemoveFromWishlist(propertyID: "\(data?.propertyID ?? 0)")
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout


extension EditWishListVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 2 cells per row
        
        // Return the size with fixed height of 120
        return CGSize(width: cellWidth, height: 390)
    }
}

    
    extension EditWishListVC {
        func bindVC(){
            viewModel.$ItemsInWishlistResult
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let self = self else{return}
                    result?.handle(success: { response in
                        print(response.message ?? "")
                        // self.showToast(response.message ?? "")
                        self.getItemsArr = response.data ?? []
                        print(self.getItemsArr ?? [],"getItemsArr")
                        //self.getItemsArr?.removeAll()
                        if self.getItemsArr?.count == 0 {
                            self.collecV.setEmptyView(message: response.message ?? "")
                        } else {
                            self.collecV.setEmptyView(message: "")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() ) {
                            //  self.updateCollectionViewHeight()
                            self.collecV.reloadData()
                        }
                    })
                }.store(in: &cancellables)
            
            viewModel.$getWishlistRemoveResult
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink { [weak self] result in
                    
                    guard let self = self else{return}
                    result?.handle(success: { response in
                        self.showToast(response.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.viewModel.apiForGetItemsInWishList()
                        }
                    })
                }.store(in: &cancellables)
        }
    }
