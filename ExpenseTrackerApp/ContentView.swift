//
//  ContentView.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /// View Properties
    @State private var currentTab: String = "Expenses"
    
    var body: some View {
        TabView(selection: self.$currentTab) {
            ExpensesView(currentTab: self.$currentTab)
                .tag("Expenses")
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            CategoriesView()
                .tag("Categories")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
        }
    }
}
