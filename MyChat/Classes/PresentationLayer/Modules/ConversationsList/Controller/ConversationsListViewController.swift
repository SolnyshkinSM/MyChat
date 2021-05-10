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

    // MARK: - IBOutlet properties

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Public properties

    public var coordinator: GoToCoordinatorProtocol?

    // MARK: - Private properties

    lazy private var tableViewDataSource: TableViewDataSourceProtocol = {
        let tableViewDataSource = TableViewDataSource(
            database: database,
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController)
        return tableViewDataSource
    }()

    private weak var tableViewDelegate: TableViewDelegateProtocol?

    lazy private var screenSaver: ScreenSaverProtocol = ScreenSaver(viewController: self)

    lazy private var firebaseManager: FirebaseManagerProtocol = ChatsFirebaseManager.getChannelFirebaseManager(coreDataStack: coreDataStack, reference: reference)

    lazy private var channelsManager: ChannelsManagerProtocol = ChannelsManager(viewController: self) { [weak self] alert in
        if let answer = alert.textFields?.first,
           let name = answer.text, !name.isEmpty {
            self?.reference.addDocument(data: ["name": name])
        }
    }

    private let refreshControl = UIRefreshControl()

    private let theme = ThemeManager.shared.currentTheme

    private lazy var database = Firestore.firestore()

    private lazy var reference = database.collection("channels")

    private var listener: ListenerRegistration?

    private lazy var coreDataStack: CoreDataStackProtocol = ChatsCoreDataStack.getCoreDataStack()

    private lazy var fetchedResultsManager = FetchedResultsManager<Channel>(
        tableView: tableView,
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: false)],
        fetchRequest: Channel.fetchRequest(),
        coreDataStack: coreDataStack)

    private lazy var fetchedResultsController = fetchedResultsManager.fetchedResultsController

    private lazy var gestureRecognizerManager = GestureRecognizerManager(view: view)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewDelegate = TableViewDelegate<Channel>(coordinator: coordinator,
                                                       coreDataStack: coreDataStack,
                                                       listener: listener,
                                                       fetchedResultsController: fetchedResultsController)

        screenSaver.loadScreenSaver(by: "logo")

        navigationItem.largeTitleDisplayMode = .always

        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)

        let longPressRecognizer = UILongPressGestureRecognizer(target: gestureRecognizerManager, action: #selector(gestureRecognizerManager.longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        listener = firebaseManager.addSnapshotListener()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.rowHeight = tableView.bounds.height * 0.3
    }

    deinit { listener?.remove() }

    // MARK: - Public methods

    @IBAction func profileButoonPressing(_ sender: UIBarButtonItem) {
        coordinator?.goToProfileViewController()
    }

    @IBAction func settingsButoonPressing(_ sender: UIBarButtonItem) {
        coordinator?.goToThemesViewController()
    }

    @IBAction func newChannelsButoonPressing(_ sender: UIBarButtonItem) {
        channelsManager.addNewChannel()
    }

    @objc
    func refreshTableView() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            self?.listener = self?.firebaseManager.addSnapshotListener()
            self?.refreshControl.endRefreshing()
        }
    }
}
