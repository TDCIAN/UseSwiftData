//
//  ExpenseCardView.swift
//  ExpenseTrackerApp
//
//  Created by 김정민 on 2023/09/04.
//

import SwiftUI

struct ExpenseCardView: View {
    /*
     SwiftData Objects conform to @Observable, so we can use them as Bindable objects too.
     In this project, there is no use for the Bindable object, but you can make use of it.
     */
    @Bindable var expense: Expense
    var displayTag: Bool = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let categoryName = expense.category?.categoryName,
                   self.displayTag {
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.red.gradient, in: .capsule)
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            /// Currency String
            Text(expense.currencyString)
                .font(.title3.bold())
        }
    }
}
