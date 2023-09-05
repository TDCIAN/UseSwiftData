//
//  AddExpenseView.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    /// View Properties
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    /// Categories
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Magic Keyboard", text: $title)
                }
                
                Section("Description") {
                    TextField("Bought a keyboard at the Apple Store", text: $subTitle)
                }
                
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("$")
                            .fontWeight(.semibold)
                        
                        TextField("0.0", value: $amount, formatter: self.formatter)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                /// Category Picker
                if !self.allCategories.isEmpty {
                    HStack {
                        Text("Category")
                        
                        Spacer()
                        
                        Menu {
                            ForEach(self.allCategories) { category in
                                Button(category.categoryName) {
                                    self.category = category
                                }
                            }
                            
                            /// None Button
                            Button("None") {
                                self.category = nil
                            }
                        } label: {
                            if let categoryName = self.category?.categoryName {
                                Text(categoryName)
                            } else {
                                Text("None")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                /// Cancel & Add Button
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        self.dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: self.addExpense)
                        .disabled(self.isAddButtonDisabled)
                }
            }
        }
    }
    
    /// Disabling Add Button, until all data has been entered
    var isAddButtonDisabled: Bool {
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    /// Adding Expense to the Swift Data
    func addExpense() {
        let expense = Expense(title: self.title, subTitle: self.subTitle, amount: self.amount, date: self.date, category: self.category)
        self.context.insert(expense)
        /// Closing View, Once the Data has been Added Successfully
        self.dismiss()
    }
    
    /// Decimal Formatter
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
