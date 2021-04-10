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
    
    public var coordinator: IChannelsCoordinator?

    // MARK: - Private properties
    
    lazy private var tableViewDataSource: TableViewDataSource<Channel> = {
        let tableViewDataSource = TableViewDataSource(
            database: db,
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController)
        return tableViewDataSource
    }()
    
    lazy private var tableViewDelegate: TableViewDelegate<Channel> = {
        let tableViewDelegate = TableViewDelegate<Channel>(
            coordinator: coordinator,
            coreDataStack: coreDataStack,
            listener: listener,
            fetchedResultsController: fetchedResultsController)
        return tableViewDelegate
    }()
    
    lazy private var fetchedResultsControllerDelegate =
        FetchedResultsControllerDelegate<Channel>(tableView: tableView)
    
    lazy private var screenSaver = ScreenSaver(viewController: self)
    
    lazy private var firebaseManager = FirebaseManager(coreDataStack: coreDataStack,
                                                       reference: reference)
    
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
        
        aFetchedResultsController.delegate = fetchedResultsControllerDelegate
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
        
        screenSaver.loadScreenSaver()

        navigationItem.largeTitleDisplayMode = .always
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
                
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listener = firebaseManager.addSnapshotListenerChannel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.rowHeight = tableView.bounds.height * 0.3
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
            self?.listener = self?.firebaseManager.addSnapshotListenerChannel()
            self?.refreshControl.endRefreshing()
        }
    }
}
