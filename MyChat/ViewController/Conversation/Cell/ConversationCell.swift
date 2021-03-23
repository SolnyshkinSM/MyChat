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
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Private properties

    private let theme = ThemeManager.shared.currentTheme

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        nameLabel.backgroundColor = .none
        messageLabel.backgroundColor = .none

        nameLabel.textColor = theme.buttonTintColor

        self.removeBottomSeparator()
    }

    // MARK: - Public methods

    func configure (with message: Message, inbox: Bool) {

        if var content = message.content {
            if let senderName = message.senderName, content.count < senderName.count {
                for _ in 0...senderName.count - content.count + 4 {
                    content += " "
                }
            }
            messageLabel.text = content
        }

        nameLabel.text = inbox ? message.senderName : .none
        bubbleView.inbox = inbox
    }
}
