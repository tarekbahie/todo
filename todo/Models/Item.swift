//
//  Item.swift
//  todo
//
//  Created by tarek bahie on 1/28/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation

class Item {
    var title : String = ""
    var done : Bool = false



    init(nameOfItme : String, completion : Bool) {
        self.title = nameOfItme
        self.done = completion
    }

}
