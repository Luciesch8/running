//
//  Emails.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 03/02/2023.
//

import UIKit

struct Emails {
    static func compose(subject: String) {
        // Créer une URL avec le format "mailto:" + adresse e-mail + "?subject=" + sujet de l'e-mail, en remplaçant les espaces dans le sujet par "%20"
        if let url = URL(string: "mailto:" + EMAIL + "?subject=" + subject.replaceSpaces) {
            // Ouvre l'URL créée avec l'application de messagerie par défaut

            UIApplication.shared.open(url)
        }
    }
}

// Cette extension String ajoute une propriété calculée pour remplacer tous les espaces dans une chaîne de caractères par "%20".
extension String {
    var replaceSpaces: String {
        replacingOccurrences(of: " ", with: "%20")
    }
}
