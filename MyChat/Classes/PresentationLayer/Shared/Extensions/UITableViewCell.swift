//
//  UITableViewCell.swift
//  MyChat
//
//  Created by Administrator on 07.03.2021.
//

import UIKit

// MARK: - UITableViewCell

extension UITableViewCell {

    func removeBottomSeparator() {
        for view in self.subviews where String(describing: type(of: view)).hasSuffix("SeparatorView") {
            view.removeFromSuperview()
        }
    }
}
