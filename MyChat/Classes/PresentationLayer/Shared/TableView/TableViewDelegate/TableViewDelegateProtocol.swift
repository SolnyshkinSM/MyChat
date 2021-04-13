//
//  TableViewDelegateProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import UIKit

// MARK: - TableViewDelegateProtocol

protocol TableViewDelegateProtocol: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}
