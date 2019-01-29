//
//  Category.swift
//  todo
//
//  Created by tarek bahie on 1/29/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
