//
//  ConversationsListCell.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit

// MARK: - ConversationsListCell

class ConversationsListCell: UITableViewCell {

    // MARK: - Public properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    // MARK: - Private properties

    private let theme = ThemeManager.shared.currentTheme

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupContentView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by:
            UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    // MARK: - Public methods

    func configure(with channel: Channel) {

        nameLabel.text = channel.name
        messageLabel.text = channel.lastMessage ?? "No messages yet"

        if channel.lastMessage != nil {
            messageLabel.font = .boldSystemFont(ofSize: 13)
        } else {
            messageLabel.font = .systemFont(ofSize: 13)
        }

        if let date = channel.lastActivity {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "no date"
        }
    }

    // MARK: - Private methods

    func setupContentView() {

        backgroundColor = .clear
        clipsToBounds = false
        selectionStyle = .none

        layer.masksToBounds = false
        layer.shadowOpacity = 0.7
        layer.cornerRadius = 4
        layer.shadowColor = theme.shadowColor.cgColor

        contentView.backgroundColor = theme.contentViewColor
        contentView.layer.cornerRadius = contentView.bounds.height * 0.05
    }
}
