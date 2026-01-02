//
//  SpreadType.swift
//  TarotMystique
//
//  Types de tirages de tarot et leurs positions
//

import Foundation
import CoreGraphics

/// Type de tirage de tarot
enum SpreadType: String, CaseIterable, Identifiable {
    case single = "Simple"
    case pastPresentFuture = "Passé-Présent-Futur"
    case celticCross = "Croix Celtique"
    case horseshoe = "Fer à Cheval"

    var id: String { rawValue }

    /// Nombre de cartes dans le tirage
    var cardCount: Int {
        switch self {
        case .single: return 1
        case .pastPresentFuture: return 3
        case .celticCross: return 10
        case .horseshoe: return 7
        }
    }

    /// Description du tirage
    var description: String {
        switch self {
        case .single:
            return "Une carte pour une réponse rapide et directe à votre question."
        case .pastPresentFuture:
            return "Trois cartes révélant le passé, le présent et le futur de votre situation."
        case .celticCross:
            return "Le tirage le plus complet : 10 cartes explorant tous les aspects de votre vie."
        case .horseshoe:
            return "Sept cartes en arc de cercle pour une vision panoramique de votre chemin."
        }
    }

    /// Positions des cartes (signification de chaque position)
    var positions: [String] {
        switch self {
        case .single:
            return ["La Réponse"]
        case .pastPresentFuture:
            return ["Le Passé", "Le Présent", "Le Futur"]
        case .celticCross:
            return [
                "Situation Actuelle",      // 1
                "Défi/Obstacle",           // 2
                "Passé Récent",            // 3
                "Futur Proche",            // 4
                "Objectif Conscient",      // 5
                "Influences Inconscientes",// 6
                "Votre Position",          // 7
                "Influences Extérieures",  // 8
                "Espoirs et Peurs",        // 9
                "Résultat Final"           // 10
            ]
        case .horseshoe:
            return [
                "Le Passé",
                "Le Présent",
                "Influences Cachées",
                "Obstacles",
                "Environnement",
                "Action Recommandée",
                "Résultat Probable"
            ]
        }
    }

    /// Coordonnées relatives des cartes pour l'affichage (x, y normalisées entre -1 et 1)
    func cardPositions(containerSize: CGSize) -> [(x: CGFloat, y: CGFloat, rotation: CGFloat)] {
        let centerX = containerSize.width / 2
        let centerY = containerSize.height / 2
        let cardSpacing: CGFloat = 100

        switch self {
        case .single:
            return [(x: centerX, y: centerY, rotation: 0)]

        case .pastPresentFuture:
            return [
                (x: centerX - cardSpacing, y: centerY, rotation: 0),      // Passé
                (x: centerX, y: centerY, rotation: 0),                    // Présent
                (x: centerX + cardSpacing, y: centerY, rotation: 0)       // Futur
            ]

        case .celticCross:
            return [
                (x: centerX, y: centerY, rotation: 0),                    // 1: Centre
                (x: centerX, y: centerY, rotation: 90),                   // 2: Croisée
                (x: centerX, y: centerY - cardSpacing, rotation: 0),      // 3: Haut
                (x: centerX, y: centerY + cardSpacing, rotation: 0),      // 4: Bas
                (x: centerX - cardSpacing, y: centerY, rotation: 0),      // 5: Gauche
                (x: centerX + cardSpacing, y: centerY, rotation: 0),      // 6: Droite
                (x: centerX + cardSpacing * 2, y: centerY + cardSpacing * 1.5, rotation: 0),  // 7
                (x: centerX + cardSpacing * 2, y: centerY + cardSpacing * 0.5, rotation: 0),  // 8
                (x: centerX + cardSpacing * 2, y: centerY - cardSpacing * 0.5, rotation: 0),  // 9
                (x: centerX + cardSpacing * 2, y: centerY - cardSpacing * 1.5, rotation: 0)   // 10
            ]

        case .horseshoe:
            let radius: CGFloat = cardSpacing * 1.5
            let startAngle: CGFloat = .pi * 0.75  // 135°
            let endAngle: CGFloat = .pi * 0.25    // 45°
            let angleStep = (startAngle - endAngle) / CGFloat(6)

            return (0..<7).map { i in
                let angle = startAngle - angleStep * CGFloat(i)
                return (
                    x: centerX + cos(angle) * radius,
                    y: centerY - sin(angle) * radius,
                    rotation: -angle * 180 / .pi
                )
            }
        }
    }

    /// Icône SF Symbol pour le tirage
    var iconName: String {
        switch self {
        case .single: return "square.fill"
        case .pastPresentFuture: return "square.split.3x1.fill"
        case .celticCross: return "plus.square.fill"
        case .horseshoe: return "arc.fill"
        }
    }
}

/// Configuration d'un tirage en cours
struct ReadingConfiguration: Codable {
    let spreadType: SpreadType
    let allowReversed: Bool
    let deckType: DeckType
    let randomMode: RandomMode
    let language: String

    enum DeckType: String, Codable, CaseIterable {
        case full = "Deck Complet (78 cartes)"
        case majorOnly = "Arcanes Majeurs uniquement (22 cartes)"
    }

    enum RandomMode: String, Codable, CaseIterable {
        case quantum = "Quantique (API ANU)"
        case cosmic = "Cosmique (Capteurs)"
    }
}

/// Résultat d'un tirage
struct TarotReading: Identifiable, Codable {
    let id: UUID
    let date: Date
    let configuration: ReadingConfiguration
    let cards: [TarotCard]
    let entropyData: EntropyData?

    /// Données d'entropie pour la traçabilité
    struct EntropyData: Codable {
        let mode: String
        let rawData: String?          // Données brutes (ex: nombres quantiques)
        let hash: String?             // Hash SHA-256
        let timestamp: Date
        let sensorData: SensorSnapshot?

        struct SensorSnapshot: Codable {
            let gyro: [Double]?
            let accelerometer: [Double]?
            let location: LocationData?
            let moonPhase: Double?
            let solarDeclination: Double?
            let julianDay: Double?

            struct LocationData: Codable {
                let latitude: Double
                let longitude: Double
                let altitude: Double
            }
        }
    }
}
