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
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.layer.cornerRadius = logoImageView.bounds.height / 2
    }
    
    // MARK: - Public methods
    
    func configure(with user: UserProtocol) {
        
        onlineImageView.backgroundColor = .clear
        
        logoImageView.image = UIImage(named: "nologo")
        nameLabel.text = user.name
        messageLabel.text = user.unreadMessage ?? "No messages yet"
        
        if user.hasUnreadMessage {
            messageLabel.font = .boldSystemFont(ofSize: 13)
        } else {
            messageLabel.font = .systemFont(ofSize: 13)
        }
        
        onlineImageView.isHidden = !user.online
                       
        if let date = user.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "no date"
        }
    }
}
