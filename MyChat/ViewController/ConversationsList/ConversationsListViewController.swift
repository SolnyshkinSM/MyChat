//
//  ConversationsListViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit
import Firebase
import CoreData

// MARK: - ConversationsListViewController

class ConversationsListViewController: UIViewController {

    // MARK: - Public properties

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties
    
    private let refreshControl = UIRefreshControl()

    private let theme = ThemeManager.shared.currentTheme

    private lazy var db = Firestore.firestore()

    private lazy var reference = db.collection("channels")

    private var listener: ListenerRegistration?

    private let coreDataStack = CoreDataStack()
    
    private var _fetchedResultsController: NSFetchedResultsController<Channel>?
    
    private var fetchedResultsController: NSFetchedResultsController<Channel> {
        
        if let _fetchedResultsController = _fetchedResultsController {
            return _fetchedResultsController
        }        
        
        let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
        fetchRequest.fetchBatchSize = 10

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.context,
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
        
        return _fetchedResultsController ?? NSFetchedResultsController<Channel>()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreenSaver()

        navigationItem.largeTitleDisplayMode = .always
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }

    deinit {
        listener?.remove()
    }

    // MARK: - Public methods

    @IBAction func profileButoonPressing(_ sender: UIBarButtonItem) {

        if let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") {
            present(controller, animated: true)
        }
    }

    @IBAction func settingsButoonPressing(_ sender: UIBarButtonItem) {

        guard let controller = storyboard?.instantiateViewController(
                withIdentifier: "ThemesViewController") as? ThemesViewController else { return }
        let themeManager = ThemeManager()
        controller.themeManager = themeManager
        controller.closure = themeManager.closureApplyTheme
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func newChannelsButoonPressing(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Enter channel name",
                                      message: nil, preferredStyle: .alert)
        alert.addTextField()

        let createButton = UIAlertAction(title: "Create", style: .default) { [unowned alert] _ in

            if let answer = alert.textFields?.first,
               let name = answer.text, !name.isEmpty {

                let channel: [String: Any] = ["name": name]
                self.reference.addDocument(data: channel)
            }
        }
        alert.addAction(createButton)

        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelButton)

        alert.setBackgroundColor(color: theme.buttonBackgroundColor)

        present(alert, animated: true)
    }

    @objc
    func refreshTableView() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            self?.loadData()
            self?.refreshControl.endRefreshing()
        }
    }

    // MARK: - Private methods
    
    private func setupScreenSaver() {

        let screensaver = UIImageView(frame: view.bounds)
        screensaver.backgroundColor = theme.backgroundColor
        screensaver.contentMode = .center
        screensaver.image = UIImage(named: "logo")
        screensaver.clipsToBounds = true
        view.addSubview(screensaver)

        UIView.animate(withDuration: 3) {
            screensaver.alpha = 0
            self.navigationController?.navigationBar.alpha = 1
        }
    }
    
    private func loadData() {
        
        let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        
        listener = reference.addSnapshotListener { [weak self] snapshot, _ in
            
            if let context = self?.coreDataStack.context {
                snapshot?.documents.forEach { document in
                    
                    fetchRequest.predicate = NSPredicate(format: "identifier = %@", document.documentID)
                    
                    if let fetchResults = try? context.fetch(fetchRequest) {
                        if fetchResults.isEmpty {
                            _ = Channel(identifier: document.documentID, with: document.data(), in: context)
                        } else if let channel = fetchResults.first {
                            let data = document.data()
                            if channel.lastMessage != data["lastMessage"] as? String {
                                _ = Channel(identifier: document.documentID, with: data, in: context)
                            }
                        }
                    }
                }
                self?.coreDataStack.saveContext()
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsListCell",
                                                       for: indexPath) as? ConversationsListCell
        else { return UITableViewCell() }

        let channel = fetchedResultsController.object(at: indexPath)
        cell.configure(with: channel)
                
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let controller = storyboard?.instantiateViewController(
            withIdentifier: "ConversationViewController") as? ConversationViewController {
            
            listener?.remove()
            
            let channel = fetchedResultsController.object(at: indexPath)
            controller.coreDataStack = coreDataStack
            controller.configure(with: channel)
            navigationController?.pushViewController(controller, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let channel = fetchedResultsController.object(at: indexPath)
        
        if editingStyle == .delete {
            
            if let identifier = channel.identifier {
                db.collection("channels").document(identifier).delete()
            }
            
            coreDataStack.context.delete(channel)
            coreDataStack.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
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
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationsListCell,
                  let channel = anObject as? Channel
            else { return }
            cell.configure(with: channel)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationsListCell,
                  let channel = anObject as? Channel
            else { return }
            cell.configure(with: channel)
            tableView.moveRow(at: indexPath, to: newIndexPath)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
