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

    private var keyboardHeight: CGFloat = 0

    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString

    private var fileLoader: FileLoaderProtocol = GCDFileLoader.shared

    private var profile: Profile?

    private lazy var db = Firestore.firestore()

    private var reference: CollectionReference?

    private var listener: ListenerRegistration?
    
    private var channel: Channel?
    
    private var predicate: NSPredicate?
    
    private var _fetchedResultsController: NSFetchedResultsController<Message>?
    
    private var fetchedResultsController: NSFetchedResultsController<Message> {
        
        if let _fetchedResultsController = _fetchedResultsController {
            return _fetchedResultsController
        }
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.fetchBatchSize = 50
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        guard let context = coreDataStack?.context else {
            return NSFetchedResultsController<Message>()
        }
        
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController ?? NSFetchedResultsController<Message>()
    }

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
        
        scrollToRowFetchedObjects()
    }
    
    // MARK: - Public methods

    func configure(with channel: Channel) {

        title = channel.name

        self.channel = channel
        
        if let identifier = channel.identifier {
            predicate = NSPredicate(format: "channel.identifier = %@", identifier)
            reference = db.collection("channels").document(identifier).collection("messages")
            loadData()
        }
    }

    // MARK: - Private methods

    private func loadData() {
        
        guard let context = coreDataStack?.context else { return }
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        
        listener = reference?.addSnapshotListener { [weak self] snapshot, _ in
            
            snapshot?.documentChanges.forEach { diff in
                
                let document = diff.document
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", document.documentID)
                guard let fetchResults = try? context.fetch(fetchRequest) else { return }
                
                if fetchResults.isEmpty {
                    let message_db = Message(identifier: document.documentID,
                                             with: document.data(), in: context)
                    self?.channel?.addToMessages(message_db)
                } else {
                    guard let message = fetchResults.first else { return }
                    
                    switch diff.type {
                    case .modified:
                        let data = document.data()
                        if message.content != data["content"] as? String {
                            let message_db = Message(identifier: document.documentID,
                                                     with: document.data(), in: context)
                            self?.channel?.addToMessages(message_db)
                        }
                    case .removed:
                        context.delete(message)
                    default:
                        break
                    }
                }
            }
            self?.coreDataStack?.saveContext()
        }
    }
    
    private func scrollToRowFetchedObjects() {
        
        if let countFetchedObjects = fetchedResultsController.fetchedObjects?.count,
           countFetchedObjects != 0 {
            let lastIndex = IndexPath(item: countFetchedObjects - 1, section: 0)
            tableView.scrollToRow(at: lastIndex,
                                  at: UITableView.ScrollPosition.bottom, animated: true)
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
            
            _ = reference?.addDocument(data: messageData)
            
            textField.text = .none
        }

        textField.resignFirstResponder()
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if tableView.window == nil { return }
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        if tableView.window == nil { return }
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if tableView.window == nil { return }
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationCell,
                  let message = anObject as? Message
            else { return }
            let inbox = message.senderId != deviceID
            cell.configure(with: message, inbox: inbox)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationCell,
                  let message = anObject as? Message
            else { return }
            let inbox = message.senderId != deviceID
            cell.configure(with: message, inbox: inbox)
            tableView.moveRow(at: indexPath, to: newIndexPath)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if tableView.window == nil { return }
        tableView.endUpdates()
        scrollToRowFetchedObjects()
    }
}
