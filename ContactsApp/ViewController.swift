//
//  ViewController.swift
//  ContactsApp
//
//  Created by Admin on 6/23/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let Identifier = "Cell"
    
    private var twoDimensionallArray = [ExpandableNames]()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        setupNabigationBar()
    }
    
    //MARK: - Private Methods
    private func setupData() {
        twoDimensionallArray = [ExpandableNames(names: [Contact(name: "asdt", hasFavorited: false),
                                                        Contact(name: "asdfasdf", hasFavorited: false)], isExpandable: true),
                                ExpandableNames(names: [Contact(name: "fasdf", hasFavorited: false),
                                                        Contact(name: "sdfsdf", hasFavorited: false)], isExpandable: true),
                                ExpandableNames(names: [Contact(name: "fghv", hasFavorited: false),
                                                        Contact(name: "rtwrt", hasFavorited: false)], isExpandable: true),
                                ExpandableNames(names: ["Sergey", "Alexy", "Oleg", "Alexande", "Roma", "Evganiy"].map { Contact(name: $0, hasFavorited: false) }, isExpandable: true)]
        
    }
    
    private func setupNabigationBar() {
        title = "Contacts"
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navItem = UIBarButtonItem(title: "Show index path", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.rightBarButtonItem = navItem
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.registerCell(ContactCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: - Actions
    @objc private func handleShowIndexPath() {
        var indexPathsToReload = [IndexPath]()
        
        for section in twoDimensionallArray.indices {
            if !twoDimensionallArray[section].isExpandable {
                continue
            }
            for row in twoDimensionallArray[section].names.indices {
                indexPathsToReload.append(IndexPath(row: row, section: section))
            }
        }
        showIndexPaths = !showIndexPaths
        let animationStyle = showIndexPaths ? UITableViewRowAnimation.right : .left
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
        
    }
    
    @objc private func handleExpandClose(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in twoDimensionallArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
//        twoDimensionallArray[section].removeAll()
        let isExpanded = !twoDimensionallArray[section].isExpandable
        twoDimensionallArray[section].isExpandable = isExpanded
        
        button.setTitle(isExpanded ? "Close" : "Open", for: .normal)
        
        if isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionallArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .gray
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if twoDimensionallArray[section].isExpandable {
             return twoDimensionallArray[section].names.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ContactCell.self)
        let contact = twoDimensionallArray[indexPath.section].names[indexPath.row]
        
        cell.delegate = self
        cell.textLabel?.text = contact.name
        
        cell.accessoryView?.tintColor = contact.hasFavorited ? .red : .gray
       
        if showIndexPaths {
           cell.textLabel?.text = "\(contact.name) Section \(indexPath.section) Row \(indexPath.row)"
        }
        return cell
    }
}

extension ViewController: ContactCellDelegate {
    
    func starButtonPressed(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let isFavorited = !twoDimensionallArray[indexPath.section].names[indexPath.row].hasFavorited
        twoDimensionallArray[indexPath.section].names[indexPath.row].hasFavorited = isFavorited
        
//        tableView.reloadRows(at: [indexPath], with: .none)
        cell.accessoryView?.tintColor = isFavorited ? .red : .lightGray
    }
    
    
    
    
    
    
    
    
}
