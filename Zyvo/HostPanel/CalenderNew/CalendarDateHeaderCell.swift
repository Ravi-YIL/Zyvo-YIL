//
//  CalendarDateHeaderCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//


import UIKit

final class CalendarDateHeaderCell: UICollectionViewCell {
    static let id = "CalendarDateHeaderCell"

    private let lbl = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 239/255, green: 242/255, blue: 245/255, alpha: 1)
        contentView.layer.cornerRadius = 16

        lbl.textColor = UIColor(red: 55/255, green: 59/255, blue: 99/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center

        lbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lbl)

        NSLayoutConstraint.activate([
            lbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(_ date: Date) {
        let f = DateFormatter()
        f.dateFormat = "dd - EEE"
        lbl.text = f.string(from: date)
    }

    required init?(coder: NSCoder) { fatalError() }
}
