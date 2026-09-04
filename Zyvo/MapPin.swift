//
//  MapPin.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 10/01/25.
//

import UIKit

class MapPin: UIView {

    @IBOutlet weak var lbl_Price: UILabel!
    
     var isUpdated = false
//    var viewData:MapData?{
//        didSet{
//          //  upateView()
//        }
//    }
    
    func updateView(price: String) {
         guard !isUpdated else { return } // Prevent multiple updates
         isUpdated = true
         print("$\(price)/h", "Updating label")
         lbl_Price.text = "$\(price)/h"
     }
    
}
