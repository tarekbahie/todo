//
//  Item.swift
//  todo
//
//  Created by tarek bahie on 1/29/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
