//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

@Model
class Expense {
    /// Expense Properties
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    /// Expense Category
    var category: Category?
    
    init(title: String, subTitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.category = category
    }
    
    /// Currency String
    @Transient // The @Transient macro is used to avoid storing properties on disk.
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(for: self.date) ?? ""
    }
    
}
