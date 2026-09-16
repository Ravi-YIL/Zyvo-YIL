//
//  ChatCell.swift
//  Zyvo
//
//  Created by ravi on 22/11/24.
//

import UIKit

enum ChatMessageTimestampFormatter {
    private static let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter
    }()

    private static let isoFormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    static func string(from value: String) -> String {
        let date = isoFormatterWithFractionalSeconds.date(from: value)
            ?? isoFormatter.date(from: value)
            ?? legacyDate(from: value)
        guard let date else { return "" }
        return outputFormatter.string(from: date)
    }

    private static func legacyDate(from value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: value)
    }
}

class ChatCell: UITableViewCell {

  
    @IBOutlet weak var lbl_msg: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_time.adjustsFontSizeToFitWidth = true
        lbl_time.minimumScaleFactor = 0.75
       // self.lbl_msg.font = UIFont(name: "Poppins-Regular", size: 14)
       
    }
    
    func setUser(user:String!,imgArr:Media?,messageBody:TCHMessage,user_id:String) {
        print(messageBody,"messageBody")
        
        lbl_msg.text = messageBody.body
       
        img.makeCircular()
        img.contentMode = .scaleAspectFill
       
        lbl_time.text = self.updateLastMsgTime(messageBody.dateUpdated ?? "")
//        if let image = imgArr?.image {
//            self.img.image = image
//        }else {
//            img.image = UIImage(named: "usericon")
//        }
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

final class ChatDocumentCell: UITableViewCell {
    static let reuseIdentifier = "ChatDocumentCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let fileButton = UIButton(type: .system)
    var onFileTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        fileButton.setAttributedTitle(nil, for: .normal)
        onFileTapped = nil
    }

    func configure(name: String, avatarURL: String, fileName: String, time: String) {
        nameLabel.text = name
        timeLabel.text = time
        avatarImageView.loadImage(from: avatarURL, placeholder: UIImage(named: "user"))

        let title = NSMutableAttributedString(
            string: "📄  \(fileName)\n",
            attributes: [
                .font: UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.label
            ]
        )
        title.append(NSAttributedString(
            string: "      PDF • View or download",
            attributes: [
                .font: UIFont(name: "Poppins-Regular", size: 11) ?? UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))
        fileButton.setAttributedTitle(title, for: .normal)
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 16

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Poppins-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = .label
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.75
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        fileButton.translatesAutoresizingMaskIntoConstraints = false
        fileButton.contentHorizontalAlignment = .left
        fileButton.titleLabel?.numberOfLines = 2
        fileButton.titleLabel?.lineBreakMode = .byTruncatingMiddle
        fileButton.backgroundColor = UIColor(red: 242/255, green: 245/255, blue: 246/255, alpha: 1)
        fileButton.layer.cornerRadius = 10
        fileButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        fileButton.addTarget(self, action: #selector(fileTapped), for: .touchUpInside)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(fileButton)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -10),

            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            fileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            fileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            fileButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            fileButton.heightAnchor.constraint(equalToConstant: 54),
            fileButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }

    @objc private func fileTapped() {
        onFileTapped?()
    }
}
