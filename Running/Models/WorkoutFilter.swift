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
            return .weekOfMonth // Granularité de la date pour cette semaine est semaine du mois
        case .thisMonth:
            return .month // Granularité de la date pour ce mois
        case .thisYear:
            return .year // Granularité de la date pour cette année
        }
    }
}
