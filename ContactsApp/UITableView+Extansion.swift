//
//  UITableView+Extansion.swift
//  ContactsApp
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Registers given cell with the tableView
    ///
    /// - Parameter type: Cell's Type
    func registerCell<TableViewCell: UITableViewCell>(_ type:TableViewCell.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    
    /// Dequeue cell using given cell type
    ///
    /// - Parameter type: Cell's Type
    /// - Returns: Dequeue Reusable Cell from tableView
    func dequeueCell<TableViewCell: UITableViewCell>(_ type:TableViewCell.Type) -> TableViewCell {
        return dequeueReusableCell(withIdentifier: String(describing: type)) as! TableViewCell
    }
}
