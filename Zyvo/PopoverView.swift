//
//  PopoverView.swift
//  Zyvo
//
//  Created by ravi on 11/12/24.
//

import UIKit

class PopoverView: UIView {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "This is some small information."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
        
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
