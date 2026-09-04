//
//  AddMoreTimePopUpVC.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit
import DropDown

class AddMoreTimePopUpVC: UIViewController,CircularSeekBarDelegate {
    
    func circularSeekBarDidStartDragging() {
        
    }
    
    func circularSeekBarDidEndDragging() {
        
    }

    
    func didUpdateCenterLabel(Hours: String) {
        
        let hoursInt = Int(Hours) ?? 0
        self.bookedHours = hoursInt
        
        print(hoursInt,"hoursInt")
        
        // TextField Update
        txt_selectHours.text = "\(hoursInt) hour"
        
        if hoursInt > 1 {
            txt_selectHours.text = "\(hoursInt) hours"
        }

        // Total Calculate
        self.hoursBasedTotal = "\(Double(hoursInt * (self.perHourRate ?? 0)))"
        print(self.hoursBasedTotal ?? 0,"hoursBasedTotal")
    }
    
    
    @IBOutlet weak var txt_selectHours: UITextField!
    @IBOutlet weak var btnSaveChange: UIButton!
    @IBOutlet weak var view_selectHours: UIView!
    
    @IBOutlet weak var view_Watch: CircularSeekBar!
    var perHourRate: Int? = 0
    var bookedHours: Int? = 0
    var hoursBasedTotal: String? = "0.0"
    let dropDown = DropDown()
    var backAction:(_ str : Int,_ str2 : String ) -> () = { str, str2 in}
    let items = ["2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var getUserBooking : UserBookingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_Watch.backgroundColor = .white
        
        view_Watch.delegate = self
        
        btnSaveChange.layer.cornerRadius = 10
        view_selectHours.layer.cornerRadius = 10
        view_selectHours.layer.borderWidth = 1
        view_selectHours.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSaveChanges_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.backAction(bookedHours ?? 0, hoursBasedTotal ?? "")
    }
    
    @IBAction func btnSelectHours_Tap(_ sender: UIButton) {
        // Set up the dropdown
        dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dropDown.dataSource = items
        dropDown.direction = .bottom
        dropDown.layer.cornerRadius = 10
        
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_selectHours.text =  "\(item)"
        
            let text = "\(item)"
            let numberOnly = text.filter { $0.isNumber }
            print(numberOnly)
            // Circular watch update
           
            self?.bookedHours = Int(numberOnly)
            self?.view_Watch.setHour(self?.bookedHours ?? 0)
            self?.hoursBasedTotal = "\(Double(((self?.bookedHours ?? 0) * (self?.perHourRate ?? 0))))"
            
        }
        dropDown.show()
    }
}
