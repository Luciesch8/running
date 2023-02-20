//
//  Store.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 03/02/2023.
//

import UIKit
import StoreKit

struct Store {
    // Cette méthode demande à l'utilisateur de laisser une évaluation de l'application s'il est dans la vue active de l'application.
    static func requestRating() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    

}

