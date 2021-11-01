//
//  UserTableViewCell.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import SnapKit
import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    static let cellHeight: CGFloat = 550
    
    private(set) var user: User? {
        didSet {
            self.fillFields()
        }
    }
    
    // MARK: - Views
    private lazy var containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var pictureImageView: UIImageView = {
        let view: UIImageView = .init()
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize+6)
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetFields()
    }
    
    private func configure() {
        self.clipsToBounds = true
        
        let mainStackView: UIStackView = .init(arrangedSubviews: [pictureImageView, nameLabel])
        mainStackView.clipsToBounds = true
        mainStackView.axis = .vertical
        mainStackView.spacing = Constants.margins/2
        self.contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview().inset(Constants.margins)
        }
        
        pictureImageView.snp.makeConstraints { make in
            make.height.equalTo(UserTableViewCell.cellHeight/1.5)
        }
    }
    
    public func configure(with user: User) {
        self.user = user
    }
    
    private func resetFields() {
        self.pictureImageView.image = nil
        self.nameLabel.text = ""
    }
    
    private func fillFields() {
        self.pictureImageView.download(from: self.user?.picture ?? "", completion: nil)
        self.nameLabel.text = self.user?.getFlagNameAge(showTitle: false, showAge: true)
    }
}
