//
//  HomeCell.swift
//  Zyvo
//
//  Created by ravi on 11/10/24.
//

import UIKit

class HomeCell: UICollectionViewCell {
    var didSelectItem: ((IndexPath) -> Void)? // Closure to handle selection
    @IBOutlet weak var btnInstantBook: UIButton!
    @IBOutlet weak var btnImgDistance: UIButton!
    @IBOutlet weak var imgBookMark: UIButton!
    @IBOutlet weak var lbl_AddressHostedby: UILabel!
    @IBOutlet weak var lbl_NameHostedBy: UILabel!
    @IBOutlet weak var viewMain_hostedBy: UIView!
    @IBOutlet weak var view_Instant: UIView!
    @IBOutlet weak var imgHostedBy: UIImageView!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btninstant: UIButton!
    @IBOutlet weak var view_Main: UIView!

    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var lbl_NumberOfUser: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var pageV: UIPageControl!
    @IBOutlet weak var CollecV: UICollectionView!
    var imgArr = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain_hostedBy.layer.cornerRadius = 12
        
        view_Instant.layer.cornerRadius = view_Instant.layer.frame.height / 2
        let nib3 = UINib(nibName: "imgCell", bundle: nil)
        CollecV?.register(nib3, forCellWithReuseIdentifier: "imgCell")
        CollecV.delegate = self
        CollecV.dataSource = self
        CollecV.layer.cornerRadius = 20
//        pageV.currentPage = 0
//        
//        pageV.numberOfPages = imgArr.count
        
        print(imgArr.count,"imgArr Count")
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.CollecV.contentOffset, size: self.CollecV.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        if let visibleIndexPath = self.CollecV.indexPathForItem(at: visiblePoint) {
//            self.pageV.currentPage = visibleIndexPath.row
//
//        }
//    }
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        targetContentOffset.pointee = scrollView.contentOffset
//        var indexes = self.CollecV.indexPathsForVisibleItems
//        indexes.sort()
//        var index = indexes.first!
//        let cell = self.CollecV.cellForItem(at: index)!
//        let position = self.CollecV.contentOffset.x - cell.frame.origin.x
//        if position > cell.frame.size.width/2{
//            index.row = index.row+1
//        }
//        self.CollecV.scrollToItem(at: index, at: .left, animated: true )
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let layout = (scrollView as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout
        let lineSpacing = layout?.minimumLineSpacing ?? 0
        let pageWidth = scrollView.bounds.width + lineSpacing
        
        guard pageWidth > 0, !imgArr.isEmpty else { return }
        let page = Int((scrollView.contentOffset.x + (scrollView.bounds.width / 2)) / pageWidth)
        pageV.currentPage = max(0, min(page, imgArr.count - 1))
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = (scrollView as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout
        let lineSpacing = layout?.minimumLineSpacing ?? 0
        let pageWidth = scrollView.bounds.width + lineSpacing
        
        guard pageWidth > 0, !imgArr.isEmpty else { return }
        
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.pointee.x
        
        var page = round(targetOffset / pageWidth)
        
        // Fast swipe velocity handling
        if velocity.x > 0.3 {
            page = ceil(currentOffset / pageWidth)
        } else if velocity.x < -0.3 {
            page = floor(currentOffset / pageWidth)
        }
        
        let maxPage = CGFloat(imgArr.count - 1)
        page = max(0, min(page, maxPage))
        
        targetContentOffset.pointee.x = page * pageWidth
    }

}

extension HomeCell :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = CollecV.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell
        
        var image = imgArr[indexPath.row]
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: ""))
       
        return cell
    }
    
    // MARK: - UICollectionView Delegate
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           didSelectItem?(indexPath) // Forward the selection
       }
   
}
extension HomeCell:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
        func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Calculate the width based on screen size, subtracting padding or spacing as needed
            let padding: CGFloat = 5  // Example padding (adjust as needed)
            let collectionViewWidth = collectionView.frame.width - padding
            let cellWidth = collectionViewWidth / 1  //Display 2 cells per row
            // Return the size with fixed height of 120
            print(collectionView.bounds.size.width,"width")
            print((collectionView.bounds.size.width*0.9),"height")
            return CGSize(width: collectionView.bounds.size.width, height: (collectionView.bounds.size.width*0.9).rounded(.up))
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

