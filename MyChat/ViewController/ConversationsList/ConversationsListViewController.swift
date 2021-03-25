//
//  ConversationsListViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

// MARK: - ConversationsListViewController

class ConversationsListViewController: UIViewController {

    // MARK: - Public properties

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties

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

                let channel = Channel(id: nil, name: name, lastMessage: nil, lastActivity: nil)

                do {
                    _ = try self.reference.addDocument(from: channel)
                } catch let error {
                    print("Error message website to Firestore: \(error)")
                }
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
        screensaver.backgroundColor = .white
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

            self?.channels.removeAll()
            snapshot?.documents.forEach({ document in

                let result = Result {
                    try document.data(as: Channel.self)
                }

                switch result {
                case .success(let channel):
                    if let channel = channel {
                        self?.channels.append(channel)
                    }
                case .failure:
                    break
                }
            })
            self?.tableView.reloadData()
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
