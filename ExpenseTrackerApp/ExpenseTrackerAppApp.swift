//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        /// Setting Up the Container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
