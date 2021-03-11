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
    
    func configure(with user: ConversationsListViewController.User) {
        
        logoImageView.image = UIImage(named: "nologo")
        nameLabel.text = user.name
        messageLabel.text = user.unreadMessage ?? "No messages yet"
        onlineImageView.isHidden = !user.online
        
        if user.hasUnreadMessage {
            messageLabel.font = .boldSystemFont(ofSize: 13)
            messageLabel.textColor = .black
        } else {
            messageLabel.font = .systemFont(ofSize: 13)
            messageLabel.textColor = .lightGray
        }
       
        if let date = user.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }

}
