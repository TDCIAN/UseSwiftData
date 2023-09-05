//
//  Item.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
