//
//  ConversationsListViewController.swift
//  MyChat
//
//  Created by Administrator on 27.02.2021.
//

import UIKit

// MARK: - ConversationsListViewController

class ConversationsListViewController: UIViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
        
    private let refreshControl = UIRefreshControl()
    
    private let names = [
        "Sergey", "Kirill", "Isabella", "Sophie", "Bob",
        "Alex", "Olga", "Heather", "Alla", "Max",
        "Anna", "Kate", "Nicole", "Jon", "Harry",
        "Oliver", "Olivia", "Emily", "Ava", "Mia"
    ]
    
    private let messages = [
        "Hello my friend!", "Hello", "Let's go", "What do you do?", "Howdy!", nil
    ]
        
    private lazy var users: [UserProtocol] = names.map { name -> User in
        let message = messages[Int.random(in: 0..<messages.count)]
        var user = User(name: name,
             unreadMessage: message,
             date: Calendar.current.date(
                byAdding: Int.random(in: 0...1) != 0 ? .day : .hour,
                value: Int(Int.random(in: 0...5)) * -1,
                to: Date()),
             online: (Int.random(in: 0...1) != 0),
             hasUnreadMessage: message != nil,
             messages: [
                Message(text: message,
                        inbox: true)
             ])
        if names.firstIndex(of: name) == 0 {
            user.messages = [
                Message(text: "Hello!", inbox: true),
                Message(text: "Hello my friend!", inbox: false),
                Message(text: "How are you?", inbox: true),
                Message(text: "Things are good. Was recently on vacation.", inbox: false),
                Message(text: "Let's go for a walk? The weather is fine today.", inbox: true),
                
            ]
        }
        user.date = Int.random(in: 0...1) != 0 ? nil : user.date
        return user
    }
    
    private let sections: [Section] = [
        Section(name: "Online", online: true),
        Section(name: "History", online: false)
    ]
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
                
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
                
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Public methods
    
    @IBAction func profileButoonPressing(_ sender: UIBarButtonItem) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") {
            present(controller, animated: true)
        }
    }
    
    @IBAction func settingsButoonPressing(_ sender: UIBarButtonItem) {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController else { return }
        let themeManager = ThemeManager()
        controller.themeManager = themeManager
        controller.closure = themeManager.closureApplyTheme
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func refreshTableView() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.backgroundColor = .clear
        header.contentView.backgroundColor = .lightGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.filter { $0.online == sections[section].online }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsListCell", for: indexPath) as? ConversationsListCell else {
            return UITableViewCell()
        }
        
        let usersByType = users.filter { $0.online == sections[indexPath.section].online }
        
        let user = usersByType[indexPath.row]
        
        cell.configure(with: user)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController {
            let usersByType = users.filter { $0.online == sections[indexPath.section].online }
            controller.configure(with: usersByType[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
