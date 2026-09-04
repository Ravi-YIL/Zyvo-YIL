//
//  CalendarBookingCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//


import UIKit

final class CalendarBookingCell: UICollectionViewCell {
    static let id = "CalendarBookingCell"

    private let nameLbl = UILabel()
    private let statusLbl = UILabel()
    private let timeLbl = UILabel()
    private let backgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Background image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 18
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // Overlay setup
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        
        nameLbl.font = .systemFont(ofSize: 16, weight: .bold)
        statusLbl.font = .systemFont(ofSize: 14, weight: .medium)
        timeLbl.font = .systemFont(ofSize: 14)

        nameLbl.textColor = .black
        timeLbl.textColor = .black

        let stack = UIStackView(arrangedSubviews: [nameLbl, statusLbl, timeLbl])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }


    func configure(_ booking: BookingNew, forHour hour: Int) {
        nameLbl.text = booking.guestName
        timeLbl.text = String(format: "%02d:00 - %02d:00", hour, hour + 1)
//        contentView.layer.borderWidth = 0
//        contentView.layer.borderColor = UIColor.clear.cgColor
        if booking.status == "finished" {
            statusLbl.text = "Finished"
            statusLbl.textColor = .systemGreen
            backgroundImageView.image = UIImage(named: "GREENBG")
            
        }  else if booking.status == "cancelled" {
            statusLbl.text = "Cancelled"
            statusLbl.textColor = .systemOrange
            backgroundImageView.image = UIImage(named: "ORANGEBG")
            
        } else if booking.status == "confirmed" {
            statusLbl.text = "Confirmed"
            statusLbl.textColor = .systemGreen
            backgroundImageView.image = UIImage(named: "GREENBG")
            
        }else {
            statusLbl.text = "Waiting payment"
            statusLbl.textColor = .systemOrange
            backgroundImageView.image = UIImage(named: "ORANGEBG")
        }
    }



    func empty() {
        nameLbl.text = nil
        statusLbl.text = nil
        timeLbl.text = nil
//        contentView.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
//        contentView.layer.borderWidth = 1
        backgroundImageView.image = UIImage(named: "")
    }

    required init?(coder: NSCoder) { fatalError() }
}
