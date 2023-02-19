//
//  DraggableView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//

import SwiftUI

struct DraggableBar: View {
    let title: String?
    
    init(_ title: String? = nil) {
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 35, height: 5)
                .foregroundColor(Color(.placeholderText))
                .cornerRadius(2.5)
            Spacer(minLength: 0)
            if let title {
                Text(title)
                    .font(.headline)
                Spacer(minLength: 0)
            }
        }
    }
}
