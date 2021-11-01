//
//  TextTableViewCell.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 01/11/2021.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    static let identifier = "TextTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetFields()
    }
    
    public func configure(text: String) {
        var content = self.defaultContentConfiguration()
        content.textProperties.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        content.text = text
        contentConfiguration = content
    }
    
    public func configure(text: String, detail: String) {
        var content = self.defaultContentConfiguration()
        content.textProperties.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize-3)
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        content.text = text
        content.secondaryText = detail
        contentConfiguration = content
    }
    
    private func resetFields() {
        if var content = self.contentConfiguration as? UIListContentConfiguration {
            content.text = ""
            content.secondaryText = ""
            contentConfiguration = content
        }
    }
}
