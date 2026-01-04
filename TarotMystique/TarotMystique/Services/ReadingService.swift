//
//  ReadingService.swift
//  TarotMystique
//
//  Service de gestion des tirages de tarot
//

import Foundation
import CryptoKit

/// Service de gestion des tirages
class ReadingService: ObservableObject {
    @Published var currentReading: TarotReading?
    @Published var isGenerating = false

    private let quantumService = QuantumRandomService()
    private let cosmicService = CosmicRandomService()

    /// Génère un nouveau tirage de tarot
    func generateReading(configuration: ReadingConfiguration) async throws {
        await MainActor.run {
            isGenerating = true
        }

        // Sélection du deck
        let deck = configuration.deckType == .full ? TarotDeck.fullDeck : TarotDeck.majorArcana

        // Génération de l'entropie selon le mode
        var shuffledDeck: [TarotCard]
        var entropyData: TarotReading.EntropyData?

        switch configuration.randomMode {
        case .quantum:
            do {
                // Tentative quantique
                let quantumNumbers = try await quantumService.generateQuantumNumbers(length: deck.count)
                shuffledDeck = shuffleWithQuantumNumbers(deck: deck, numbers: quantumNumbers)

                // Sauvegarde des données d'entropie
                let rawData = quantumNumbers.map { String($0) }.joined(separator: ",")
                let hash = quantumService.verificationSeal ?? ""

                entropyData = TarotReading.EntropyData(
                    mode: "Quantique (ANU QRNG)",
                    rawData: rawData,
                    hash: hash,
                    timestamp: Date(),
                    sensorData: nil
                )

            } catch {
                // Fallback automatique sur mode cosmique
                print("⚠️ Fallback quantique -> cosmique: \(error.localizedDescription)")
                let result = try await performCosmicShuffle(deck: deck)
                shuffledDeck = result.deck
                entropyData = result.entropy
                entropyData?.mode = "Cosmique (Fallback)"
            }

        case .cosmic:
            // Mode cosmique direct
            let result = try await performCosmicShuffle(deck: deck)
            shuffledDeck = result.deck
            entropyData = result.entropy
        }

        // Application de l'orientation inversée si activée
        if configuration.allowReversed {
            shuffledDeck = applyReversedOrientation(to: shuffledDeck)
        }

        // Sélection des cartes pour le tirage
        let selectedCards = Array(shuffledDeck.prefix(configuration.spreadType.cardCount))

        // Création du tirage
        let reading = TarotReading(
            id: UUID(),
            date: Date(),
            configuration: configuration,
            cards: selectedCards,
            entropyData: entropyData
        )

        await MainActor.run {
            currentReading = reading
            isGenerating = false
        }
    }

    /// Shuffle avec nombres quantiques (algorithme Fisher-Yates optimisé)
    private func shuffleWithQuantumNumbers(deck: [TarotCard], numbers: [UInt16]) -> [TarotCard] {
        var shuffled = deck
        let count = shuffled.count

        for i in 0..<(count - 1) {
            let randomIndex = Int(numbers[i % numbers.count]) % (count - i)
            let swapIndex = i + randomIndex
            shuffled.swapAt(i, swapIndex)
        }

        return shuffled
    }

    /// Shuffle cosmique
    private func performCosmicShuffle(deck: [TarotCard]) async throws -> (deck: [TarotCard], entropy: TarotReading.EntropyData) {
        // Génération de l'entropie cosmique
        let entropyHash = try await cosmicService.generateCosmicEntropy()

        // Utilisation du hash comme seed pour le shuffle
        let shuffled = shuffleWithHash(deck: deck, hash: entropyHash)

        // Création des données d'entropie
        let snapshot = cosmicService.sensorSnapshot
        let sensorData = TarotReading.EntropyData.SensorSnapshot(
            gyro: snapshot?.gyroscope,
            accelerometer: snapshot?.accelerometer,
            location: snapshot?.location.map {
                TarotReading.EntropyData.SensorSnapshot.LocationData(
                    latitude: $0.latitude,
                    longitude: $0.longitude,
                    altitude: $0.altitude
                )
            },
            moonPhase: snapshot?.moonPhase,
            solarDeclination: snapshot?.solarDeclination,
            julianDay: snapshot?.julianDay
        )

        let entropyData = TarotReading.EntropyData(
            mode: "Cosmique (Capteurs iPhone)",
            rawData: snapshot?.entropyString,
            hash: entropyHash,
            timestamp: Date(),
            sensorData: sensorData
        )

        return (shuffled, entropyData)
    }

    /// Shuffle avec hash (conversion hash -> indices)
    private func shuffleWithHash(deck: [TarotCard], hash: String) -> [TarotCard] {
        var shuffled = deck
        let count = shuffled.count

        // Convertir le hash en bytes
        var hashBytes: [UInt8] = []
        var index = hash.startIndex
        while index < hash.endIndex {
            let nextIndex = hash.index(index, offsetBy: 2, limitedBy: hash.endIndex) ?? hash.endIndex
            let byteString = hash[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                hashBytes.append(byte)
            }
            index = nextIndex
        }

        // Fisher-Yates avec les bytes du hash
        for i in 0..<(count - 1) {
            let randomByte = hashBytes[i % hashBytes.count]
            let randomIndex = Int(randomByte) % (count - i)
            let swapIndex = i + randomIndex
            shuffled.swapAt(i, swapIndex)
        }

        return shuffled
    }

    /// Applique l'orientation inversée aléatoirement (50% de chance)
    private func applyReversedOrientation(to cards: [TarotCard]) -> [TarotCard] {
        return cards.map { card in
            var mutableCard = card
            // Utilisation de CryptoKit pour un random sécurisé
            let randomValue = Int.random(in: 0...1)
            mutableCard.orientation = randomValue == 0 ? .upright : .reversed
            return mutableCard
        }
    }

    /// Réinitialise le service
    func reset() {
        currentReading = nil
        isGenerating = false
        quantumService.reset()
        cosmicService.reset()
    }
}
