//
//  CosmicRandomService.swift
//  TarotMystique
//
//  Service de génération aléatoire cosmique utilisant les capteurs iPhone
//

import Foundation
import CoreMotion
import CoreLocation
import CryptoKit

/// Service de génération aléatoire cosmique
class CosmicRandomService: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var lastError: String?
    @Published var sensorSnapshot: SensorData?
    @Published var entropyHash: String?

    // Managers
    private let motionManager = CMMotionManager()
    private let locationManager = CLLocationManager()

    // Données de capteurs
    private var gyroData: [Double] = []
    private var accelData: [Double] = []
    private var locationData: LocationInfo?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    /// Génère de l'entropie cosmique à partir des capteurs
    func generateCosmicEntropy() async throws -> String {
        await MainActor.run {
            isLoading = true
            lastError = nil
        }

        // Collecte des données de capteurs en parallèle
        async let gyro = collectGyroscopeData()
        async let accel = collectAccelerometerData()
        async let location = requestLocation()

        do {
            let (gyroValues, accelValues, locationInfo) = try await (gyro, accel, location)

            // Calculs astronomiques
            let timestamp = Date()
            let moonPhase = calculateMoonPhase(date: timestamp)
            let solarDeclination = calculateSolarDeclination(date: timestamp)
            let julianDay = calculateJulianDay(date: timestamp)

            // Combinaison de toutes les sources d'entropie
            var entropyString = ""
            entropyString += gyroValues.map { String($0) }.joined(separator: ",")
            entropyString += accelValues.map { String($0) }.joined(separator: ",")
            if let loc = locationInfo {
                entropyString += "\(loc.latitude),\(loc.longitude),\(loc.altitude)"
            }
            entropyString += "\(moonPhase),\(solarDeclination),\(julianDay)"
            entropyString += "\(timestamp.timeIntervalSince1970)"
            entropyString += "\(mach_absolute_time())" // Timestamp nanoseconde

            // Génération du hash SHA-256
            let hash = SHA256.hash(data: Data(entropyString.utf8))
            let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()

            // Sauvegarde du snapshot
            let snapshot = SensorData(
                gyroscope: gyroValues,
                accelerometer: accelValues,
                location: locationInfo,
                moonPhase: moonPhase,
                solarDeclination: solarDeclination,
                julianDay: julianDay,
                timestamp: timestamp,
                entropyString: entropyString
            )

            await MainActor.run {
                sensorSnapshot = snapshot
                entropyHash = hashString
                isLoading = false
            }

            return hashString

        } catch {
            await MainActor.run {
                lastError = error.localizedDescription
                isLoading = false
            }
            throw error
        }
    }

    /// Collecte les données du gyroscope
    private func collectGyroscopeData() async throws -> [Double] {
        return try await withCheckedThrowingContinuation { continuation in
            guard motionManager.isGyroAvailable else {
                // Fallback si gyroscope non disponible
                continuation.resume(returning: [])
                return
            }

            motionManager.gyroUpdateInterval = 0.01 // 100 Hz
            var samples: [Double] = []

            motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                guard let self = self else { return }

                if let error = error {
                    self.motionManager.stopGyroUpdates()
                    continuation.resume(throwing: error)
                    return
                }

                if let gyro = data {
                    samples.append(gyro.rotationRate.x)
                    samples.append(gyro.rotationRate.y)
                    samples.append(gyro.rotationRate.z)

                    if samples.count >= 30 { // 10 échantillons (3 valeurs chacun)
                        self.motionManager.stopGyroUpdates()
                        continuation.resume(returning: samples)
                    }
                }
            }

            // Timeout de 2 secondes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.motionManager.stopGyroUpdates()
                if !samples.isEmpty {
                    continuation.resume(returning: samples)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }

    /// Collecte les données de l'accéléromètre
    private func collectAccelerometerData() async throws -> [Double] {
        return try await withCheckedThrowingContinuation { continuation in
            guard motionManager.isAccelerometerAvailable else {
                continuation.resume(returning: [])
                return
            }

            motionManager.accelerometerUpdateInterval = 0.01
            var samples: [Double] = []

            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let self = self else { return }

                if let error = error {
                    self.motionManager.stopAccelerometerUpdates()
                    continuation.resume(throwing: error)
                    return
                }

                if let accel = data {
                    samples.append(accel.acceleration.x)
                    samples.append(accel.acceleration.y)
                    samples.append(accel.acceleration.z)

                    if samples.count >= 30 {
                        self.motionManager.stopAccelerometerUpdates()
                        continuation.resume(returning: samples)
                    }
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.motionManager.stopAccelerometerUpdates()
                if !samples.isEmpty {
                    continuation.resume(returning: samples)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }

    /// Demande la localisation
    private func requestLocation() async throws -> LocationInfo? {
        // Vérifie l'autorisation
        let status = locationManager.authorizationStatus

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            // Retourne nil si permission refusée (fallback gracieux)
            return nil
        }

        return try await withCheckedThrowingContinuation { continuation in
            var resumed = false

            locationManager.requestLocation()

            // Timeout de 3 secondes
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if !resumed {
                    resumed = true
                    continuation.resume(returning: nil)
                }
            }

            // Callback via delegate (voir extension ci-dessous)
            locationCompletion = { result in
                if !resumed {
                    resumed = true
                    continuation.resume(with: result)
                }
            }
        }
    }

    // Closure pour la complétion de localisation
    private var locationCompletion: ((Result<LocationInfo?, Error>) -> Void)?

    // MARK: - Calculs astronomiques

    /// Calcule la phase lunaire (0-1, où 0 = Nouvelle Lune, 0.5 = Pleine Lune)
    private func calculateMoonPhase(date: Date) -> Double {
        // Algorithme simple basé sur les cycles lunaires
        // Référence: Nouvelle Lune connue: 6 janvier 2000, 18:14 UTC
        let knownNewMoon = Date(timeIntervalSince1970: 947182440) // 2000-01-06
        let lunarCycle = 29.53058867 * 24 * 3600 // ~29.53 jours en secondes

        let elapsed = date.timeIntervalSince(knownNewMoon)
        let cycles = elapsed / lunarCycle
        let phase = cycles - floor(cycles) // Partie fractionnaire

        return phase
    }

    /// Calcule la déclinaison solaire (en degrés)
    private func calculateSolarDeclination(date: Date) -> Double {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1

        // Formule d'approximation
        let declination = -23.44 * cos((360.0 / 365.0) * Double(dayOfYear + 10) * .pi / 180.0)

        return declination
    }

    /// Calcule le jour julien
    private func calculateJulianDay(date: Date) -> Double {
        let timeInterval = date.timeIntervalSince1970
        let julianDay = (timeInterval / 86400.0) + 2440587.5 // Conversion Unix -> JD

        return julianDay
    }

    /// Réinitialise le service
    func reset() {
        isLoading = false
        lastError = nil
        sensorSnapshot = nil
        entropyHash = nil
    }
}

// MARK: - CLLocationManagerDelegate

extension CosmicRandomService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let locationInfo = LocationInfo(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude
        )

        locationCompletion?(.success(locationInfo))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Fallback gracieux: retourne nil plutôt qu'une erreur
        locationCompletion?(.success(nil))
    }
}

// MARK: - Structures de données

struct SensorData {
    let gyroscope: [Double]
    let accelerometer: [Double]
    let location: LocationInfo?
    let moonPhase: Double
    let solarDeclination: Double
    let julianDay: Double
    let timestamp: Date
    let entropyString: String
}

struct LocationInfo: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
}
