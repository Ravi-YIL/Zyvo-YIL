//
//  CalendarTimeCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//


import UIKit

final class CalendarTimeCell: UICollectionViewCell {
    static let id = "CalendarTimeCell"

    private let lbl = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor(red: 239/255, green: 242/255, blue: 245/255, alpha: 1)
        contentView.layer.cornerRadius = 14

        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = UIColor(red: 55/255, green: 59/255, blue: 99/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 14, weight: .medium)

        lbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lbl)

        NSLayoutConstraint.activate([
            lbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(_ text: String) {
        lbl.text = text
    }

    required init?(coder: NSCoder) { fatalError() }
}
