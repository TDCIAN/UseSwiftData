//
//  ExpensesView.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTab: String
    /// Grouped Expenses Properties
    @Query(
        sort: [SortDescriptor(\Expense.date, order: .reverse)],
        animation: .snappy
    )
    private var allExpenses: [Expense]
    @Environment(\.modelContext) private var context
    
    /// Grouped Expenses
    /// This will also be used for filtering purpose
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var originalGroupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
        
    /// Search Text
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.$groupedExpenses) { $group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            /// Card View
                            ExpenseCardView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    /// Delete Button
                                    Button {
                                        /// Deleting Data
                                        self.context.delete(expense)
                                        withAnimation {
                                            group.expenses.removeAll(where: { $0.id == expense.id })
                                            /// Removing Group, if no expenses present
                                            if group.expenses.isEmpty {
                                                self.groupedExpenses.removeAll(where: { $0.id == group.id })
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .searchable(text: self.$searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
            .overlay {
                if self.allExpenses.isEmpty || self.groupedExpenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            /// New Expense Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of: self.searchText, initial: false) { oldValue, newValue in
            if !newValue.isEmpty {
                self.filterExpenses(newValue)
            } else {
                self.groupedExpenses = self.originalGroupedExpenses
            }
        }
        .onChange(of: self.allExpenses, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || self.groupedExpenses.isEmpty || self.currentTab == "Categories" {
                self.createGroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
                .interactiveDismissDisabled()
        }
    }
    
    /// Filtering Expenses
    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpenses = self.originalGroupedExpenses.compactMap { group -> GroupedExpenses? in
                let expenses = group.expenses.filter({ $0.title.lowercased().contains(query) })
                if expenses.isEmpty {
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run {
                self.groupedExpenses = filteredExpenses
            }
        }
    }
    
    /// Creating Grouped Expenses (Grouping By Date)
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
                return dateComponents
            }
            
            /// Sorting Dictionary in Descending Order
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            /// Adding to the Grouped Expenses Array
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                self.groupedExpenses = sortedDict.compactMap { dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                }
                self.originalGroupedExpenses = self.groupedExpenses
            }
        }
    }
}

#Preview {
    ContentView()
}
