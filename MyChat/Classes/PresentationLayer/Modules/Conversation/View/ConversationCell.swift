//
//  ConversationCell.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit

class ConversationCell: UITableViewCell {

    // MARK: - IBOutlet properties

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

        [nameLabel, messageLabel].forEach { $0.backgroundColor = .none }

        nameLabel.textColor = theme.buttonTintColor

        self.removeBottomSeparator()
    }

    // MARK: - Public methods

    func configure (with message: Message, inbox: Bool) {

        if var content = message.content, let senderName = message.senderName {
            if content.count < senderName.count {
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
