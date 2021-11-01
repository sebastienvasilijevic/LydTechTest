//
//  UIImageView+Extensions.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import UIKit

// MARK: - UIImageView
extension UIImageView {
    private func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, completion: (() -> Void)?) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                DispatchQueue.main.async() {
                    completion?()
                }
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?()
            }
        }.resume()
    }
    
    func download(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFill, completion: (() -> Void)?) {
        guard link != nil, !link!.isEmpty, let url = URL(string: link!) else {
            self.image = nil
            completion?()
            return
        }
        download(from: url, contentMode: mode, completion: completion)
    }
}
