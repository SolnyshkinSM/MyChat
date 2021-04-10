//
//  ProfileButton.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

class ProfileButton: UIButton {

    private let theme = ThemeManager.shared.currentTheme
    
    required init() {
        super.init(frame: .zero)
        
        layer.masksToBounds = true
        backgroundColor = theme.profileImageButtonColor
        layer.cornerRadius = bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        backgroundColor = theme.profileImageButtonColor
        layer.cornerRadius = bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
