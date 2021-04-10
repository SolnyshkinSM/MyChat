//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit
import Firebase
import CoreData

// MARK: - ConversationViewController

class ConversationViewController: UIViewController {

    // MARK: - Public properties
    
    var coreDataStack: CoreDataStack?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var vaultView: UIView!

    // MARK: - Private properties
        
    lazy private var tableViewDataSource: TableViewDataSource<Message> = {
        let tableViewDataSource = TableViewDataSource(
            database: db,
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController)
        return tableViewDataSource
    }()
    
    lazy private var tableViewDelegate: TableViewDelegate<Message> = {
        let tableViewDelegate = TableViewDelegate(
            coordinator: nil,
            coreDataStack: nil,
            listener: listener,
            fetchedResultsController: fetchedResultsController)
        return tableViewDelegate
    }()
    
    lazy private var textFieldDelegate = TextFieldDelegate { [weak self] textField in
        
        if let text = textField.text, !text.isEmpty, !text.blank {

            _ = self?.reference?.addDocument(data: [
                "content": text, "created": Date(),
                "senderId": self?.deviceID ?? "",
                "senderName": self?.profile?.fullname ?? ""
            ])
            textField.text = .none
        }
    }
    
    lazy private var firebaseManager = FirebaseManager<Message>(
        coreDataStack: coreDataStack, reference: reference,
        fetchRequest: Message.fetchRequest(), channel: channel)

    private var keyboardHeight: CGFloat = 0

    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString

    private var fileLoader: FileLoaderProtocol = GCDFileLoader.shared

    private var profile: Profile? { didSet { messageField.delegate = textFieldDelegate } }

    private lazy var db = Firestore.firestore()

    private var reference: CollectionReference?

    private var listener: ListenerRegistration?
    
    private var channel: Channel?
    
    private var predicate: NSPredicate?
    
    private lazy var fetchedResultsManager = FetchedResultsManager<Message>(
        tableView: tableView,
        sortDescriptors: [NSSortDescriptor(key: "created", ascending: true)],
        fetchRequest: Message.fetchRequest(),
        predicate: predicate,
        coreDataStack: coreDataStack)
    
    private lazy var fetchedResultsController = fetchedResultsManager.fetchedResultsController
    
    lazy private var fetchedResultsControllerDelegate = fetchedResultsManager.fetchedResultsControllerDelegate
    
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
                
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let fetchedResultsController = fetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult> {
            fetchedResultsControllerDelegate.scrollToRowFetchedObjects(controller: fetchedResultsController)
        }
    }
    
    // MARK: - Public methods

    func configure(with channel: Channel) {

        title = channel.name
        self.channel = channel
        
        if let identifier = channel.identifier {
            predicate = NSPredicate(format: "channel.identifier = %@", identifier)
            reference = db.collection("channels").document(identifier).collection("messages")
            listener = firebaseManager.addSnapshotListener()
        }
    }

    // MARK: - Private methods
    
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
