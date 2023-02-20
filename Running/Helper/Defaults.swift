//
//  Defaults.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 03/02/2023.
//

import Foundation

@propertyWrapper

// Cette structure Emails permet de composer un e-mail en utilisant l'application de messagerie par défaut du système d'exploitation.
// La méthode compose prend un sujet en paramètre et ouvre une URL de messagerie avec le sujet spécifié.

struct Defaults<ValueType> {
    let defaults = UserDefaults.standard
    
    let key: String // Clé pour stocker et récupérer les valeurs.
    let defaultValue: ValueType // valeur par défaut si aucune valeur n'est stockée pour cette clé.
    
    // Fonction pour réinitialiser la valeur stockée pour la clé avec la valeur par défaut.
    func reset() {
        defaults.set(defaultValue, forKey: key)
    }

    // Stocke et récupère les valeurs pour la clé spécifiée.
    var wrappedValue: ValueType {
        get {
            defaults.object(forKey: key) as? ValueType ?? defaultValue // Récupère la valeur stockée ou renvoie la valeur par défaut.
        }
        set {
            defaults.set(newValue, forKey: key) // Stocke la valeur pour la clé spécifiée.
        }
    }
}
