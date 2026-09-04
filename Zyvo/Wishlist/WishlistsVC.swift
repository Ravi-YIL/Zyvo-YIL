//
//  WishlistsVC.swift
//  Zyvo
//  Created by ravi on 22/10/24.


import UIKit
import Combine

class WishlistsVC: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var btnedit: UIButton!
    private var viewModel = WishlistDataViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getWishlistArr : [WishlistDataModel]?
    
    var crossStatus = "false"
    var indexNeedtoBeDeleted = 0
    @IBOutlet weak var collecV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
       
        // Register the WishlistCell nib file
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        collecV.register(nib, forCellWithReuseIdentifier: "WishlistCell")
        collecV.delegate = self
        collecV.dataSource = self
        // Style the collection view
        collecV.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        btnedit.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 20)
        btnedit.setTitle("Edit", for: .normal)
        DispatchQueue.main.async {
            self.collecV.setEmptyView(message: "")
            self.viewModel.apiForGetCreatedWishList()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        crossStatus = "false"
    }
    
    @IBAction func btnEdit_Tap(_ sender: UIButton) {
        
        if self.getWishlistArr?.count != 0 {
            if crossStatus == "false" {
                crossStatus = "true"
            } else {
                crossStatus = "false"
            }
            self.btnedit.setTitle(crossStatus == "true" ? "Done" : "Edit", for: .normal)
            self.collecV.reloadData()
        }
    }
}

// MARK: - UICollectionView Delegate and DataSource
extension WishlistsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getWishlistArr?.count ?? 0//arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        let data = getWishlistArr?[indexPath.item]
        // Configure the cell here if needed
        cell.lbl_name.text =  data?.wishlistName ?? ""
        var image = data?.lastSavedPropertyImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "no_image (1)"))
        cell.lbl_SavedCount.text = "\(data?.itemsInWishlist ?? 0)" + " Saved"
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(deleteBtn(_:)), for: .touchUpInside)
        if crossStatus == "true" {
            cell.btnCross.isHidden = false
        }
        if crossStatus == "false" {
            cell.btnCross.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = getWishlistArr?[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditWishListVC") as! EditWishListVC
        vc.hidesBottomBarWhenPushed = true
        vc.WishlistID = "\(data?.wishlistID ?? 0)"
        vc.WishlistName = "\(data?.wishlistName ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteBtn(_ sender: UIButton){
        indexNeedtoBeDeleted = sender.tag
        viewModel.wishlistID = "\(getWishlistArr?[sender.tag].wishlistID ?? 0)"
        viewModel.apiForDeleteWishlist()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension WishlistsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20 // Spacing between cells
        let itemsPerRow: CGFloat = 2 // 1
        let totalPadding = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalPadding
        let cellWidth = availableWidth / itemsPerRow
        return CGSize(width: cellWidth, height: 250) // 400
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5  // Vertical spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5  // Horizontal spacing between cells
    }
}

extension WishlistsVC {
    func bindVC(){
        viewModel.$getWishListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.getWishlistArr = response.data
                    print(self.getWishlistArr ?? [],"getWishlistArr")
                    if self.getWishlistArr?.count == 0 {
                        self.collecV.setEmptyView(message: "No Wishlist Found.")
                    } else {
                        self.collecV.setEmptyView(message: "")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {         self.collecV.reloadData()
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$deleteWishlistResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.getWishlistArr?.remove(at: self.indexNeedtoBeDeleted)
                    
                    if self.getWishlistArr?.count == 0 {
                        self.collecV.setEmptyView(message: "No Wishlist Found.")
                    } else {
                        self.collecV.setEmptyView(message: "")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        self.collecV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
}
