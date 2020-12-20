//
//  Menu.swift
//  IOSCorner
//
//  Created by Andrey on 18.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

/// Structure for Menu model.
struct Menu: Codable {
    var id: String
    var name: String
    var description: String
    var price: Int
    var image: String?
    var imageData: Data?
}
