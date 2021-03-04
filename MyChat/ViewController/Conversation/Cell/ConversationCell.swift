//
//  ConversationCell.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    // MARK: - Public properties

    @IBOutlet weak var bubbleView: BubbleView!    
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleView.layer.cornerRadius = bubbleView.bounds.height / 2
    }
    
    func configure (withMessage message: String, inbox: Bool) {
        
        messageLabel.text = message
        bubbleView.inbox = inbox
    }
        
}
