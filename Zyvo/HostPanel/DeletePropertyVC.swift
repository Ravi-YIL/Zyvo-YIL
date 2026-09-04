//
//  DeletePropertyVC.swift
//  Zyvo
//
//  Created by ravi on 31/12/24.
//

import UIKit
import Combine

class DeletePropertyVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var lbl_Message: UILabel!
    var propertyId: Int?
    private var DeleteviewModel = DeletePropertyViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var backAction:(_ str : String ) -> () = { str in}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
//        lbl_Message?.font = UIFont(name: "Poppins-Medium", size: 19)
//        btnCancel.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
//        btnConfirm.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        btnConfirm.layer.cornerRadius = btnConfirm.layer.frame.height / 2
        btnCancel.layer.cornerRadius = btnCancel.layer.frame.height / 2
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor

        
    }
    

    @IBAction func btnCancel_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func btnConfirm_Tap(_ sender: UIButton) {
        DeleteviewModel.apiforDeleteProperty(id: propertyId ?? 0)
        
    }
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
  
    
    
}
extension DeletePropertyVC {
    func bindVC(){
        DeleteviewModel.$deletePropertyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.dismiss(animated: true) {
                        self.backAction("Yes")
                    }
                })
            }.store(in: &cancellables)
    }
}
