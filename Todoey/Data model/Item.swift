//
//  Item.swift
//  Todoey
//
//  Created by P on 4/16/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    // Reverse category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
