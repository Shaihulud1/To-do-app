//
//  Item.swift
//  Todoey
//
//  Created by Илья Дернов on 12.11.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item_encodable: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
