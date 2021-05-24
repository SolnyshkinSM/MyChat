//
//  TableViewDataSourceProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import UIKit

// MARK: - TableViewDataSourceProtocol

protocol TableViewDataSourceProtocol: NSObject, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath)
}
