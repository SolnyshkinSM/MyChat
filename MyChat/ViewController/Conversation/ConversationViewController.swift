//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit
import Firebase

// MARK: - ConversationViewController

class ConversationViewController: UIViewController {

    // MARK: - Public properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var vaultView: UIView!

    // MARK: - Private properties

    private var keyboardHeight: CGFloat = 0

    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString

    private var fileLoader: FileLoaderProtocol = GCDFileLoader.shared

    private var profile: Profile?

    lazy var db = Firestore.firestore()

    var reference: CollectionReference?

    var listener: ListenerRegistration?

    private var messages: [Message] = []

    // MARK: - Lifecycle

    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.showsVerticalScrollIndicator = false

        messageField.setPlaceholder("Your message here...")

        navigationItem.largeTitleDisplayMode = .never

        fileLoader.readFile { [weak self] (result: Result<Profile, Error>) -> Void in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure:
                break
            }
        }
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

    // MARK: - Public methods

    func configure(with channel: Channel) {

        title = channel.name

        reference = db.collection("channels").document(channel.identifier).collection("messages")
        loadData()
    }

    // MARK: - Private methods

    private func loadData() {

        listener = reference?.addSnapshotListener { [weak self] snapshot, _ in

            self?.messages.removeAll()
            snapshot?.documents.forEach({ document in

                let message = Message(identifier: document.documentID,
                                      with: document.data())
                self?.messages.append(message)
            })

            self?.messages.sort { $0.created < $1.created }

            self?.tableView.reloadData()
        }
    }

    @objc private func keyboardWillShow(notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            if keyboardHeight != keyboardRectangle.height {
                keyboardHeight = keyboardRectangle.height
                moveTextField(moveDistance: keyboardHeight, moveUp: false)
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {

        moveTextField(moveDistance: keyboardHeight, moveUp: true)
        keyboardHeight = 0
    }

    private func moveTextField(moveDistance: CGFloat, moveUp: Bool) {

        let movement: CGFloat = CGFloat(moveUp ? moveDistance: -moveDistance)

        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }

    // MARK: - UIResponder

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]
        let inbox = message.senderId != deviceID
        let cellIdentifier = inbox ? "ConversationInboxCell" : "ConversationOutboxCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }

        cell.configure(with: message, inbox: inbox)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == messages.count - 1 {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.bounds.size.height)
            UIView.animate(withDuration: 0.7, delay: 0.05,
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: [], animations: {
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

        if let text = textField.text, !text.isEmpty, !text.blank {

            let messageData: [String: Any] = [
                "content": text,
                "created": Date(),
                "senderId": deviceID ?? "",
                "senderName": profile?.fullname ?? ""
            ]

            let messageRef = reference?.addDocument(data: messageData)
            if let messageRef = messageRef {
                messages.append(Message(identifier: messageRef.documentID, with: messageData))
            }
            
            textField.text = .none
            tableView.reloadData()

            let lastIndex = IndexPath(item: messages.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndex,
                                  at: UITableView.ScrollPosition.bottom, animated: true)
        }

        textField.resignFirstResponder()
        return true
    }
}

extension String {

    var blank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}
