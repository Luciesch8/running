//
//  Date.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 02/02/2023.
//

import Foundation

extension Date {
    
    // Méthode pour formatter la date selon les règles d'Apple
    func formattedApple() -> String {
        
        // Initialisation du formatter de date
        let formatter = DateFormatter()
        
        // Initialisation du calendrier
        let calendar = Calendar.current
        
        // Définition des bornes temporelles d'une semaine avant et après la date courante
        let oneWeekAgo = calendar.startOfDay(for: Date.now.addingTimeInterval(-7*24*3600))
        let oneWeekAfter = calendar.startOfDay(for: Date.now.addingTimeInterval(7*24*3600))
        
        // Si la date est aujourd'hui, on renvoie le format court de l'heure
        if calendar.isDateInToday(self) {
            return formatted(date: .omitted, time: .shortened)
            
            // Si la date est hier ou demain, on utilise un format relatif
        } else if calendar.isDateInYesterday(self) || calendar.isDateInTomorrow(self) {
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .full
            
            // Si la date est dans la semaine courante, on utilise le nom du jour de la semaine
        } else if self > oneWeekAgo && self < oneWeekAfter {
            formatter.dateFormat = "EEEE"
            
            // Si la date est dans l'année courante, on utilise le format "jour mois"
        } else if calendar.isDate(self, equalTo: .now, toGranularity: .year) {
            formatter.dateFormat = "d MMM"
            
            // Sinon, on utilise le format complet "jour mois année"
        } else {
            formatter.dateFormat = "d MMM y"
        }
        
        // Retourne la date formatée
        return formatter.string(from: self)
    }
}
