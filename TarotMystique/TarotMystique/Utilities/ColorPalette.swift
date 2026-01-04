//
//  ColorPalette.swift
//  TarotMystique
//
//  Palette de couleurs cosmique et mystique
//

import SwiftUI

extension Color {
    // MARK: - Palette Cosmique Principale

    /// Deep Koamaru - Fonds secondaires et bordures (#1a0a2e)
    static let deepKoamaru = Color(red: 26/255, green: 10/255, blue: 46/255)

    /// Amethyst - Accents mystiques et boutons primaires (#ab47bd)
    static let amethyst = Color(red: 171/255, green: 71/255, blue: 189/255)

    /// Gold - Lueurs, textes importants et effets dorés (#ffd700)
    static let gold = Color(red: 255/255, green: 215/255, blue: 0/255)

    /// Malibu - Éléments interactifs et icônes (#65b5f6)
    static let malibu = Color(red: 101/255, green: 181/255, blue: 246/255)

    /// Sunglow - Highlights et animations (#ffc929)
    static let sunglow = Color(red: 255/255, green: 201/255, blue: 41/255)

    /// True Black OLED - Fond principal (#000000)
    static let trueBlack = Color(red: 0, green: 0, blue: 0)

    // MARK: - Couleurs Stellaires (basées sur les types spectraux)

    static let starBlue = Color(red: 157/255, green: 180/255, blue: 255/255)      // Type O/B
    static let starWhite = Color(red: 255/255, green: 255/255, blue: 255/255)     // Type A/F
    static let starYellow = Color(red: 255/255, green: 244/255, blue: 234/255)    // Type G
    static let starOrange = Color(red: 255/255, green: 209/255, blue: 178/255)    // Type K
    static let starRed = Color(red: 255/255, green: 204/255, blue: 111/255)       // Type M

    // MARK: - Gradients

    static let cosmicGradient = LinearGradient(
        colors: [deepKoamaru, amethyst, trueBlack],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldShimmerGradient = LinearGradient(
        colors: [gold.opacity(0), gold, gold.opacity(0)],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let milkyWayGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.01),
            Color.white.opacity(0.05),
            Color.white.opacity(0.02),
            Color.white.opacity(0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Helpers

    /// Retourne une couleur stellaire aléatoire basée sur la distribution réaliste
    static func randomStarColor() -> Color {
        let random = Double.random(in: 0...1)
        // Distribution basée sur les types spectraux réels
        if random < 0.15 { return starBlue }       // 15% O/B
        else if random < 0.35 { return starWhite } // 20% A/F
        else if random < 0.55 { return starYellow }// 20% G
        else if random < 0.80 { return starOrange }// 25% K
        else { return starRed }                    // 20% M
    }
}
