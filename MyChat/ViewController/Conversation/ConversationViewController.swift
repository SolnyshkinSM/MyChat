//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit

// MARK: - ConversationViewController

class ConversationViewController: UIViewController {
        
    // MARK: - Public properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var vaultView: UIView!
    
    // MARK: - Private properties
    
    private var keyboardHeight: CGFloat = 0
    
    private var messages: [ConversationsListViewController.Message] = []
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.showsVerticalScrollIndicator = false
        
        //tableView.separatorStyle = .none
        //tableView.separatorColor = .clear
        
        //tableView.tableFooterView = UIView(frame: .zero)
        //tableView.separatorInset = .zero
        
        //tableView.layoutMargins = UIEdgeInsets.zero
        //tableView.separatorInset = UIEdgeInsets.zero
        
        
        /*if let placeholder = messageField.placeholder {
            messageField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: Theme.current.mainColor])
        }
        
                
        for view in messageField.subviews {
            view.backgroundColor = .clear
        }*/
        
        messageField.setPlaceholder("Your message here...")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageField.clipsToBounds = true
        messageField.layer.cornerRadius = messageField.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public methods
    
    func configure(with user: ConversationsListViewController.User) {
        title = user.name
        if let messages = user.messages {
            self.messages = messages
        }
    }
    
    // MARK: - Private methods
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            if keyboardHeight != keyboardRectangle.height {
                keyboardHeight = keyboardRectangle.height
                moveTextField(moveDistance: keyboardHeight, up: false)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        moveTextField(moveDistance: keyboardHeight, up: true)
        keyboardHeight = 0
    }
    
    private func moveTextField(moveDistance: CGFloat, up: Bool) {
        
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        guard let text = message.text else { return UITableViewCell() }
        
        let cellIdentifier = message.inbox ? "ConversationInboxCell" : "ConversationOutboxCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
                
        cell.configure(withMessage: text, inbox: message.inbox)
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //cell.layoutMargins = .zero
        
        //cell.layoutMargins = UIEdgeInsets.zero
        
        //cell.backgroundColor = .clear
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == messages.count - 1 {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.bounds.size.height)
            UIView.animate(withDuration: 0.7, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text {
            messages.append(ConversationsListViewController.Message(text: text, inbox: false))
            textField.text = .none
            tableView.reloadData()
            
            let lastIndex = IndexPath(item: messages.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndex, at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
