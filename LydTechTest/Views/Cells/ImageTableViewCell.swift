//
//  ImageTableViewCell.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 01/11/2021.
//

import SnapKit
import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let identifier = "ImageTableViewCell"
    
    static let cellHeight: CGFloat = 400
    
    private var pictureImageView: UIImageView = {
        let view: UIImageView = .init()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()

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
        
        self.contentView.addSubview(pictureImageView)
        
        pictureImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.margins/2)
        }
    }
    
    public func configure(imageUri: String) {
        pictureImageView.download(from: imageUri, completion: nil)
    }
    
    private func resetFields() {
        self.pictureImageView.image = nil
    }
}
