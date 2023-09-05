//
//  CategoriesView.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    /// View Properties
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    /// Category Delete Request
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: Category?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.allCategories.sorted(by: {
                    ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })) { category in
                    DisclosureGroup {
                        if let expenses = category.expenses,
                           !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Expenses", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            self.deleteRequest.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                    .alert(
                        "If you delete a category, all the associated expenses will be deleted too.",
                        isPresented: self.$deleteRequest
                    ) {
                        Button(role: .destructive) {
                            /// Deleting Category
                            self.requestedCategory = category
                            if let requestedCategory = self.requestedCategory {
                                self.context.delete(requestedCategory)
                                self.requestedCategory = nil
                            }
                        } label: {
                            Text("Delete")
                        }
                        
                        Button(role: .cancel) {
                            self.requestedCategory = nil
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .overlay {
                if self.allCategories.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            /// New Category Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: self.$addCategory) {
                self.categoryName = ""
            } content: {
                NavigationStack {
                    List {
                        Section("Title") {
                            TextField("General", text: $categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    /// Add & Cancel Button
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                /// Adding New Category
                                let category = Category(categoryName: self.categoryName)
                                self.context.insert(category)
                                /// Closing View
                                self.categoryName = ""
                                self.addCategory = false
                            }
                            .disabled(self.categoryName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }
        }
        
    }
}
