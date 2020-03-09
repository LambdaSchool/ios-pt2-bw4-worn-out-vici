//
//  RunListHeaderView.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/4/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

protocol RunListHeaderViewDelegate: AnyObject {
    func addRunPressed()
}

class RunListHeaderView: UITableViewHeaderFooterView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = 8
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        // setting up the add icon
        let largeSize = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: largeSize)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 37/255, green: 134/255, blue: 67/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPressed), for: .primaryActionTriggered)
        return button
    }()
    
    weak var delegate: RunListHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addPressed() {
        self.delegate?.addRunPressed()
    }
    
    private func setupStackView() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        self.stackView.addArrangedSubview(headerLabel)
        self.stackView.addArrangedSubview(addButton)
        self.headerLabel.text = "Run History"
    }
}
