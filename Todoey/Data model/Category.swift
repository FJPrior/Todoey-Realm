//
//  Category.swift
//  Todoey
//
//  Created by P on 4/16/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // Foward relationship
    let items = List<Item>()
}
