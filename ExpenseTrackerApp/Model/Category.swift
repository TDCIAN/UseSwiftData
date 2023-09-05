//
//  Category.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

@Model
class Category {
    var categoryName: String
    /// Category Expenses
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    /*
     Using the relationship macro, we can easily define the relationship and deletion rules for Swift Data properties.
     cascade: Make sure that when the category is deleted, all the associated expenses linked to this category will also be deleted.
     */
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
}
