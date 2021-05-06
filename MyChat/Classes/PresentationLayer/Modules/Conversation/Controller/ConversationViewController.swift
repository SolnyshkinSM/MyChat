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

    // MARK: - IBOutlet properties    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var vaultView: UIView!
    
    // MARK: - Public properties
    
    var coreDataStack: CoreDataStackProtocol?
    
    // MARK: - Private properties
        
    lazy private var tableViewDataSource: TableViewDataSourceProtocol = {
        let tableViewDataSource = TableViewDataSource(
            database: database,
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController)
        return tableViewDataSource
    }()
    
    lazy private var tableViewDelegate: TableViewDelegateProtocol = {
        let tableViewDelegate = TableViewDelegate(
            coordinator: nil,
            coreDataStack: coreDataStack,
            listener: listener,
            fetchedResultsController: fetchedResultsController)
        return tableViewDelegate
    }()
    
    lazy private var textFieldDelegate: TextFieldDelegateProtocol = TextFieldDelegate { [weak self] textField in
        
        if let text = textField.text, !text.isEmpty, !text.blank {

            _ = self?.reference?.addDocument(data: [
                "content": text, "created": Date(),
                "senderId": self?.deviceID ?? "",
                "senderName": self?.profile?.fullname ?? ""
            ])
            textField.text = .none
        }
    }
    
    lazy private var firebaseManager: FirebaseManagerProtocol = ChatsFirebaseManager.getMessageFirebaseManager(coreDataStack: coreDataStack, reference: reference, channel: channel)

    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString

    private var fileLoader: FileLoaderProtocol = GCDFileLoader.shared

    private var profile: Profile? { didSet { messageField.delegate = textFieldDelegate } }

    private lazy var database = Firestore.firestore()

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
    
    lazy private var fetchedResultsControllerDelegate: FetchedResultsControllerProtocol = fetchedResultsManager.fetchedResultsControllerDelegate
    
    lazy private var moveTextFieldManager: MoveTextFieldProtocol = MoveTextFieldManager(view: self.view)
    
    private lazy var gestureRecognizerManager = GestureRecognizerManager(view: view)
    
    // MARK: - Lifecycle

    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.showsVerticalScrollIndicator = false

        messageField.setPlaceholder("Your message here...")

        fileLoader.readFile { [weak self] (result: Result<Profile, Error>) -> Void in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure:
                break
            }
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: gestureRecognizerManager, action: #selector(gestureRecognizerManager.longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        messageField.clipsToBounds = true
        messageField.layer.cornerRadius = messageField.bounds.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            moveTextFieldManager,
            selector: #selector(moveTextFieldManager.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            moveTextFieldManager,
            selector: #selector(moveTextFieldManager.keyboardWillHide(notification:)),
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
            reference = database.collection("channels").document(identifier).collection("messages")
            listener = firebaseManager.addSnapshotListener()
        }
    }

    // MARK: - UIResponder

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
