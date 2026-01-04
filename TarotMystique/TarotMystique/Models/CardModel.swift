//
//  CardModel.swift
//  TarotMystique
//
//  Modèle de carte de tarot avec significations complètes
//

import Foundation
import SwiftUI

/// Orientation de la carte (droite ou inversée)
enum CardOrientation: String, Codable {
    case upright = "Droite"
    case reversed = "Inversée"
}

/// Suite des Arcanes Mineurs
enum Suit: String, CaseIterable, Codable {
    case wands = "Bâtons"      // Feu
    case cups = "Coupes"       // Eau
    case swords = "Épées"      // Air
    case pentacles = "Deniers" // Terre

    var element: String {
        switch self {
        case .wands: return "Feu"
        case .cups: return "Eau"
        case .swords: return "Air"
        case .pentacles: return "Terre"
        }
    }

    var color: Color {
        switch self {
        case .wands: return .red
        case .cups: return .blue
        case .swords: return .gray
        case .pentacles: return .green
        }
    }
}

/// Type de carte (Arcane Majeur ou Mineur)
enum CardType: Codable {
    case major
    case minor(suit: Suit, rank: Int) // rank: 1-14 (1=As, 11=Valet, 12=Chevalier, 13=Reine, 14=Roi)
}

/// Signification détaillée d'une carte
struct CardMeaning: Codable {
    let general: String
    let upright: String
    let reversed: String
    let love: String
    let career: String
    let health: String
    let spirituality: String
    let advice: String
}

/// Modèle de carte de tarot
struct TarotCard: Identifiable, Codable, Hashable {
    let id: UUID
    let number: Int                    // 0-77 (0-21 pour Majeurs, 22-77 pour Mineurs)
    let nameFr: String
    let nameEn: String
    let type: CardType
    var orientation: CardOrientation
    let meaning: CardMeaning
    let keywords: [String]
    let symbolism: String

    /// Nom affiché selon la langue
    func displayName(language: String = "fr") -> String {
        language == "fr" ? nameFr : nameEn
    }

    /// Signification selon l'orientation
    var currentMeaning: String {
        orientation == .upright ? meaning.upright : meaning.reversed
    }

    /// Image système de symbole (fallback, à remplacer par assets personnalisés)
    var symbolImage: String {
        switch type {
        case .major:
            // Pour les Arcanes Majeurs, utiliser des symboles mystiques
            return ["moon.stars.fill", "sun.max.fill", "sparkles", "star.fill",
                    "flame.fill", "bolt.fill", "heart.fill", "crown.fill",
                    "leaf.fill", "drop.fill", "wind", "globe.americas.fill",
                    "eye.fill", "hand.raised.fill", "person.fill", "figure.stand",
                    "building.columns.fill", "scroll.fill", "book.closed.fill",
                    "hourglass", "scales", "shield.fill"][number % 22]
        case .minor(let suit, let rank):
            switch suit {
            case .wands: return "flame.fill"
            case .cups: return "cup.and.saucer.fill"
            case .swords: return "triangle.fill"
            case .pentacles: return "circle.fill"
            }
        }
    }

    /// Couleur principale de la carte
    var primaryColor: Color {
        switch type {
        case .major:
            return Color("Amethyst")
        case .minor(let suit, _):
            return suit.color
        }
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TarotCard, rhs: TarotCard) -> Bool {
        lhs.id == rhs.id
    }
}
