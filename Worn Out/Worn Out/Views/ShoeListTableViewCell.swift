//
//  ShoeListTableViewCell.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/1/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

class ShoeListTableViewCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = 8
        return view
    }()
    
    private lazy var circleBar: CircleView = {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var innerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()
    
    private lazy var milesLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureWithShoe(shoe: Shoe) {
        self.titleLabel.text = shoe.nickname
        self.subtitleLabel.text = shoe.brand
        self.milesLabel.text = shoe.displayTotalMiles.map { "\($0) miles" }
        self.circleBar.animateProgressBar(progress: shoe.progress)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.setupStackView()
        self.setupProgressBar()
        self.setupInnerStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupStackView() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupProgressBar() {
        self.stackView.addArrangedSubview(self.circleBar)
        NSLayoutConstraint.activate([
            self.circleBar.heightAnchor.constraint(equalToConstant: 40),
            self.circleBar.widthAnchor.constraint(equalTo: self.circleBar.heightAnchor),
        ])
    }
    
    private func setupInnerStackView() {
        self.stackView.addArrangedSubview(self.innerStackView)
        self.innerStackView.addArrangedSubview(self.titleLabel)
        self.innerStackView.addArrangedSubview(self.subtitleLabel)
        self.stackView.addArrangedSubview(self.milesLabel)
    }
}
