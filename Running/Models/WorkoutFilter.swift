//
//  WorkoutFilter.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//

import Foundation

enum WorkoutDate: String, CaseIterable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    
    var granularity: Calendar.Component {
        switch self {
        case .thisWeek:
            return .weekOfMonth
        case .thisMonth:
            return .month
        case .thisYear:
            return .year
        }
    }
}
