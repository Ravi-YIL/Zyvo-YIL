//
//  CalendarEmptyCell.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//


import UIKit

final class CalendarEmptyCell: UICollectionViewCell {
    static let id = "CalendarEmptyCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .white
        contentView.backgroundColor = UIColor(red: 239/255, green: 242/255, blue: 245/255, alpha: 1)
        contentView.layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
