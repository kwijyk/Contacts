//
//  ExpandableNames.swift
//  ContactsApp
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames {
    
    var names: [FavoritableContact]
    var isExpandable: Bool
}

struct FavoritableContact {
    let contact: CNContact
    var hasFavorited: Bool
}
