//
//  LogoutPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 10/12/24.
//

import UIKit
import FirebaseMessaging
import Combine
class LogoutPopUpVC: UIViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var deleteLbl: UILabel!
    var backAction: () -> () = {}
    private var cancellables = Set<AnyCancellable>()
    var viewModel = LogoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        btnYes.layer.cornerRadius = btnYes.layer.frame.height / 2
        
        btnCancel.layer.cornerRadius = btnCancel.layer.frame.height / 2
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.init(red: 74/255, green: 237/255, blue: 177/255, alpha: 1).cgColor
        
        let rawText = "Are you sure you want to \n logout?"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // Adjust line spacing as needed
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(
            string: rawText,
           
            attributes: [
                
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label // Optional: customize color
            ]
        )

        self.deleteLbl.font = UIFont(name: "Poppins-Regular", size: 17)
        self.deleteLbl.attributedText = attributedString
        
    }
    
    @IBAction func btnYes_Tap(_ sender: UIButton) {
       
        viewModel.apiForLogOut()
       
    }
    
    func deleteFCMToken() {
        // Delete FCM Token on local
        UserDefaults.standard.removeObject(forKey: "twilioToken")
        UserDefaults.standard.removeObject(forKey: "fcmtoken")
        // Delete FCM Token on Firebase
        FirebaseMessaging.Messaging.messaging().deleteData { error in
            guard let error = error else {
                print("Delete FCMToken successful!")
                return
            }
            print("Delete FCMToken failed: \(String(describing: error.localizedDescription))!")
        }
    }
    @IBAction func btnCancel_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension LogoutPopUpVC {
    func bindVC(){
        viewModel.$logOutResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    UserDetail.shared.removeUserId()
                    UserDetail.shared.removeChatToken()
                    UserDetail.shared.removeKeepMeLogin()
                    UserDetail.shared.removeUserType()
                    UserDetail.shared.removeTokenWith()
                    UserDetail.shared.removeisTimeExtend()
                    UserDetail.shared.removeisCompleteProfile()
                    CurrentDateTimer.shared.stopTimer()
                    self.deleteFCMToken()
                    UserDetail.shared.removeProfileimg()
                    UserDetail.shared.removeName()
                    WhereSaveData.shared.clearData()
                    FilterSavedData.shared.clearData()
                    
                   
                    isappliedField = false
                    UserDefaults.standard.removeObject(forKey: "AppleFirstName")
                    UserDefaults.standard.removeObject(forKey: "AppleLastName")
                    UserDefaults.standard.removeObject(forKey: "AppleEmail")
                    
                    self.tabBarController?.tabBar.isHidden = false
                    UserDefaults.standard.removeObject(forKey: "timeZone")
                    self.dismiss(animated: true) {
                        self.backAction()
                    }
                })
            }.store(in: &cancellables)
    }
}
