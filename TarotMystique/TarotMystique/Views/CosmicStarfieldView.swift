//
//  CosmicStarfieldView.swift
//  TarotMystique
//
//  Fond étoilé cosmique animé avec parallaxe gyroscopique
//

import SwiftUI
import CoreMotion

/// Vue de fond étoilé cosmique avec ~400 étoiles scintillantes
struct CosmicStarfieldView: View {
    @StateObject private var viewModel = StarfieldViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fond noir OLED
                Color.trueBlack
                    .ignoresSafeArea()

                // Voie Lactée subtile
                Color.milkyWayGradient
                    .blur(radius: 100)
                    .opacity(0.3)
                    .offset(
                        x: viewModel.parallaxOffset.x * 20,
                        y: viewModel.parallaxOffset.y * 20
                    )

                // Étoiles normales (~385 étoiles)
                ForEach(viewModel.stars.filter { !$0.isBright }) { star in
                    StarView(star: star, twinklePhase: viewModel.twinklePhase)
                        .offset(
                            x: star.position.x * geometry.size.width + viewModel.parallaxOffset.x * star.parallaxDepth,
                            y: star.position.y * geometry.size.height + viewModel.parallaxOffset.y * star.parallaxDepth
                        )
                }

                // Étoiles brillantes avec rayons de diffraction (~15 étoiles)
                ForEach(viewModel.stars.filter { $0.isBright }) { star in
                    BrightStarView(star: star, twinklePhase: viewModel.twinklePhase)
                        .offset(
                            x: star.position.x * geometry.size.width + viewModel.parallaxOffset.x * star.parallaxDepth,
                            y: star.position.y * geometry.size.height + viewModel.parallaxOffset.y * star.parallaxDepth
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.startAnimations()
        }
        .onDisappear {
            viewModel.stopAnimations()
        }
    }
}

/// Vue d'une étoile normale
struct StarView: View {
    let star: Star
    let twinklePhase: Double

    private var opacity: Double {
        let baseOpacity = star.brightness
        let twinkle = sin(twinklePhase * star.twinkleSpeed + star.twinkleOffset) * 0.3
        return min(1.0, baseOpacity + twinkle)
    }

    var body: some View {
        Circle()
            .fill(star.color)
            .frame(width: star.size, height: star.size)
            .opacity(opacity)
            .blur(radius: star.size * 0.3)
    }
}

/// Vue d'une étoile brillante avec rayons de diffraction
struct BrightStarView: View {
    let star: Star
    let twinklePhase: Double

    private var opacity: Double {
        let baseOpacity = star.brightness
        let twinkle = sin(twinklePhase * star.twinkleSpeed + star.twinkleOffset) * 0.2
        return min(1.0, baseOpacity + twinkle)
    }

    var body: some View {
        ZStack {
            // Core de l'étoile
            Circle()
                .fill(star.color)
                .frame(width: star.size * 1.5, height: star.size * 1.5)
                .blur(radius: star.size * 0.5)

            // Rayons de diffraction (effet lens flare)
            ForEach(0..<4) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [star.color.opacity(0), star.color.opacity(0.6), star.color.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: star.size * 6, height: star.size * 0.2)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .blur(radius: 1)
            }

            // Halo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [star.color.opacity(0.3), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: star.size * 3
                    )
                )
                .frame(width: star.size * 6, height: star.size * 6)
        }
        .opacity(opacity)
    }
}

/// Modèle de données d'une étoile
struct Star: Identifiable {
    let id = UUID()
    let position: CGPoint       // Position normalisée (0-1)
    let size: CGFloat           // Taille en points
    let color: Color            // Couleur stellaire
    let brightness: Double      // Luminosité de base (0-1)
    let twinkleSpeed: Double    // Vitesse de scintillement
    let twinkleOffset: Double   // Offset de phase pour variation
    let parallaxDepth: Double   // Profondeur pour effet parallaxe (0-1)
    let isBright: Bool          // Étoile brillante avec rayons?
}

/// ViewModel du fond étoilé
class StarfieldViewModel: ObservableObject {
    @Published var stars: [Star] = []
    @Published var twinklePhase: Double = 0
    @Published var parallaxOffset: CGPoint = .zero

    private let motionManager = CMMotionManager()
    private var twinkleTimer: Timer?

    init() {
        generateStars()
    }

    /// Génère ~400 étoiles avec distribution réaliste
    private func generateStars() {
        var generatedStars: [Star] = []

        // 15 étoiles brillantes
        for _ in 0..<15 {
            generatedStars.append(Star(
                position: CGPoint(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1)
                ),
                size: CGFloat.random(in: 3.0...5.0),
                color: Color.randomStarColor(),
                brightness: Double.random(in: 0.7...1.0),
                twinkleSpeed: Double.random(in: 0.8...1.5),
                twinkleOffset: Double.random(in: 0...(.pi * 2)),
                parallaxDepth: Double.random(in: 0.3...0.7),
                isBright: true
            ))
        }

        // 385 étoiles normales
        for _ in 0..<385 {
            generatedStars.append(Star(
                position: CGPoint(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1)
                ),
                size: CGFloat.random(in: 0.8...2.5),
                color: Color.randomStarColor(),
                brightness: Double.random(in: 0.3...0.8),
                twinkleSpeed: Double.random(in: 0.5...2.0),
                twinkleOffset: Double.random(in: 0...(.pi * 2)),
                parallaxDepth: Double.random(in: 0.1...1.0),
                isBright: false
            ))
        }

        stars = generatedStars
    }

    /// Démarre les animations
    func startAnimations() {
        // Animation de scintillement
        twinkleTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.twinklePhase += 0.1
        }

        // Animation de parallaxe gyroscopique
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let motion = motion, let self = self else { return }

                // Utilisation du gyroscope pour l'effet parallaxe
                let pitch = motion.attitude.pitch
                let roll = motion.attitude.roll

                withAnimation(.easeOut(duration: 0.3)) {
                    self.parallaxOffset = CGPoint(
                        x: CGFloat(roll) * 30,
                        y: CGFloat(pitch) * 30
                    )
                }
            }
        }
    }

    /// Arrête les animations
    func stopAnimations() {
        twinkleTimer?.invalidate()
        twinkleTimer = nil
        motionManager.stopDeviceMotionUpdates()
    }
}
