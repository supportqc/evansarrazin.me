//
//  QuantumRandomService.swift
//  TarotMystique
//
//  Service de génération aléatoire quantique via l'API ANU QRNG
//

import Foundation
import CryptoKit

/// Service de génération aléatoire quantique
class QuantumRandomService: ObservableObject {
    @Published var isLoading = false
    @Published var lastError: String?
    @Published var rawQuantumData: [UInt16]?
    @Published var verificationSeal: String?

    /// URL de l'API ANU QRNG
    private let apiBaseURL = "https://qrng.anu.edu.au/API/jsonI.php"

    /// Génère des nombres aléatoires quantiques
    /// - Parameter length: Nombre de valeurs uint16 à générer (minimum 1, maximum 1024)
    /// - Returns: Tableau de nombres aléatoires quantiques ou nil en cas d'erreur
    func generateQuantumNumbers(length: Int = 78) async throws -> [UInt16] {
        guard length > 0 && length <= 1024 else {
            throw QuantumError.invalidLength
        }

        await MainActor.run {
            isLoading = true
            lastError = nil
        }

        // Construction de l'URL avec paramètres
        var components = URLComponents(string: apiBaseURL)!
        components.queryItems = [
            URLQueryItem(name: "length", value: "\(length)"),
            URLQueryItem(name: "type", value: "uint16")
        ]

        guard let url = components.url else {
            await MainActor.run { isLoading = false }
            throw QuantumError.invalidURL
        }

        // Configuration de la requête avec timeout
        var request = URLRequest(url: url)
        request.timeoutInterval = 15.0

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw QuantumError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw QuantumError.httpError(statusCode: httpResponse.statusCode)
            }

            // Parse de la réponse JSON
            let quantumResponse = try JSONDecoder().decode(QuantumResponse.self, from: data)

            guard quantumResponse.success else {
                throw QuantumError.apiError(message: "API returned success=false")
            }

            let numbers = quantumResponse.data

            // Sauvegarde des données brutes et génération du sceau
            await MainActor.run {
                rawQuantumData = numbers
                verificationSeal = generateVerificationSeal(data: numbers)
                isLoading = false
            }

            return numbers

        } catch {
            await MainActor.run {
                lastError = error.localizedDescription
                isLoading = false
            }
            throw error
        }
    }

    /// Génère un sceau de vérification (hash) pour les données quantiques
    private func generateVerificationSeal(data: [UInt16]) -> String {
        let dataString = data.map { String($0) }.joined(separator: ",")
        let hash = SHA256.hash(data: Data(dataString.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Réinitialise le service
    func reset() {
        isLoading = false
        lastError = nil
        rawQuantumData = nil
        verificationSeal = nil
    }
}

/// Réponse de l'API ANU QRNG
private struct QuantumResponse: Codable {
    let type: String
    let length: Int
    let data: [UInt16]
    let success: Bool
}

/// Erreurs quantiques
enum QuantumError: LocalizedError {
    case invalidLength
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case apiError(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidLength:
            return "La longueur doit être entre 1 et 1024"
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse serveur invalide"
        case .httpError(let code):
            return "Erreur HTTP: \(code)"
        case .apiError(let message):
            return "Erreur API: \(message)"
        }
    }
}
