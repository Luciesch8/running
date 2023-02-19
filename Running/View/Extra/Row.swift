//
//  Row.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 17/01/2023.
//

import SwiftUI

struct Row<Leading: View, Trailing: View>: View {
    let leading: () -> Leading
    let trailing: () -> Trailing
    
    var body: some View {
        HStack {
            leading()
            Spacer()
            trailing()
        }
    }
}
