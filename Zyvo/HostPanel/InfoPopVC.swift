//
//  InfoPopVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 13/01/25.
//

import UIKit

class InfoPopVC: UIViewController {

    @IBOutlet weak var infoLbl: UILabel!
    var msg = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.infoLbl.text = msg
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
