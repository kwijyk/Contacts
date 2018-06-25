//
//  ViewController.swift
//  ContactsApp
//
//  Created by Admin on 6/23/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    private let Identifier = "Cell"
    
    private var twoDimensionallArray = [ExpandableNames]() {
        didSet {
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
        }
    }
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        fecthContacts()
    }
    
     //MARK: - Api
    private func fecthContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Failed to request access:", error)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    var favoritableContacts = [FavoritableContact]()
                    try store.enumerateContacts(with: request, usingBlock: { contact, stopPoint in
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        print(contact.thumbnailImageData)
                    
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                    })
                    
                    let names = ExpandableNames(names: favoritableContacts, isExpandable: true)
                    self.twoDimensionallArray = [names]
                    
                } catch let error {
                    print("Failed to request access:", error)
                }

            } else {
                print("Access denied")
            }
            
        }
    }
    
    //MARK: - Private Methods
    private func setupNavigationBar() {
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
        let favoritableContact = twoDimensionallArray[indexPath.section].names[indexPath.row]
        cell.delegate = self
        let contactName: String = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        
        if let contactAvatar = favoritableContact.contact.thumbnailImageData {
            cell.imageView?.layer.cornerRadius = (cell.imageView?.bounds.width)! / 2
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.image = UIImage(data: contactAvatar)
        }
        cell.textLabel?.text = contactName
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? .red : .gray
       
        if showIndexPaths {
           cell.textLabel?.text = "\(contactName) Section \(indexPath.section) Row \(indexPath.row)"
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
