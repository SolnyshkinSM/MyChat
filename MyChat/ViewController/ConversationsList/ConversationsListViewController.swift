//
//  ConversationsListViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit
import Firebase

// MARK: - ConversationsListViewController

class ConversationsListViewController: UIViewController {

    // MARK: - Public properties

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties
    
    private let coreDataStack = CoreDataStack()

    private let refreshControl = UIRefreshControl()

    private let theme = ThemeManager.shared.currentTheme

    lazy var db = Firestore.firestore()

    lazy var reference = db.collection("channels")

    var listener: ListenerRegistration?

    lazy var channels: [Channel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreenSaver()
        setupCoreDataStack()
        loadData()

        navigationItem.largeTitleDisplayMode = .always
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
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

            if let answer = alert.textFields?.first, let name = answer.text {

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
    
    private func setupCoreDataStack() {
        
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistice()
        }
        coreDataStack.enableObservers()
    }

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

        listener = reference.addSnapshotListener { [weak self] snapshot, _ in
            
            let models = snapshot?.documents.map { document -> Channel in
                return Channel(identifier: document.documentID, with: document.data())
            }
            
            guard let channels = models else { return }
            
            self?.channels = channels
            self?.tableView.reloadData()
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.saveDataStorage()
            // self?.coreDataStack.printDatabaseStatistice()
        }
    }
    
    private func saveDataStorage() {
        
        self.coreDataStack.performSave { [weak self] context in
            
            // TODO: sleep
            // sleep(10)
            
            self?.channels.forEach { channel in
                let channel_db = Channel_db(channel: channel, in: context)
                channel.messages.forEach { message in
                    let message_db = Message_db(message: message, in: context)
                    channel_db.addToMessages(message_db)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ConversationsListCell", for: indexPath)
                as? ConversationsListCell
        else {
            return UITableViewCell()
        }

        let channel = channels[indexPath.row]
        cell.configure(with: channel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let controller = storyboard?.instantiateViewController(
            withIdentifier: "ConversationViewController") as? ConversationViewController {

            let channel = channels[indexPath.row]
            controller.configure(with: channel)
            navigationController?.pushViewController(controller, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.3
    }
}
