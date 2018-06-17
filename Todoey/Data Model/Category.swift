//
//  Category.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 15/06/2018.
//  Copyright © 2018 Joselson DIas. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
