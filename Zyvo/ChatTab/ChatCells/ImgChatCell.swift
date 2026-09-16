//
//  ImgChatCell.swift
//  Zyvo
//
//  Created by ravi on 26/03/25.
//

import UIKit
import SDWebImage

class ImgChatCell: UITableViewCell {

    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var img11: ImageViewWithPreview!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        lbl_Time.adjustsFontSizeToFitWidth = true
        lbl_Time.minimumScaleFactor = 0.75
        img11.isUserInteractionEnabled = true
        img11.previewType = 1
        img11.gestureType = .tap
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        img11.sd_cancelCurrentImageLoad()
        img11.image = nil
    }
    
    func setUser(user:String!,imgArr:Media?,messageBody:TCHMessage,user_id:String) {
        print(messageBody,"messageBody")
      
        lbl_Time.text = self.updateLastMsgTime(messageBody.dateUpdated ?? "")
        if let image = imgArr?.image {
            self.imgUser.image = image
        }else {
            imgUser.image = UIImage(named: "usericon")
        }
        let conversationsManager = QuickstartConversationsManager.shared.self
        if let conversation = conversationsManager.conversation {
            let s = conversation.participants()
            s.forEach { (per) in
                let identity = per.identity ?? ""
                if identity != "\(user_id)" {
                    let lastReadMessageIndex = per.lastReadMessageIndex as? Int ?? -1
                    let index = messageBody.index as? Int ?? 0
                }
            }
        }
    }
    
    func updateLastMsgTime(_ time:String) -> String{
        ChatMessageTimestampFormatter.string(from: time)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
