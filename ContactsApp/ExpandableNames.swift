//
//  ExpandableNames.swift
//  ContactsApp
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct ExpandableNames {
    
    var names: [Contact]
    var isExpandable: Bool
}

struct Contact {
    let name: String
    var hasFavorited: Bool
}
