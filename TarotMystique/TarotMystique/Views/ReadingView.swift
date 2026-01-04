//
//  ReadingView.swift
//  TarotMystique
//
//  Vue de tirage avec cartes interactives et animations
//

import SwiftUI

struct ReadingView: View {
    let reading: TarotReading
    let onDismiss: () -> Void

    @State private var revealedCards: Set<Int> = []
    @State private var selectedCard: TarotCard?
    @State private var showingEntropyDetails = false

    var body: some View {
        ZStack {
            // Fond étoilé
            CosmicStarfieldView()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.malibu)
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text(reading.configuration.spreadType.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gold)

                        Text(reading.configuration.randomMode.rawValue)
                            .font(.system(size: 12))
                            .foregroundColor(.malibu.opacity(0.8))
                    }

                    Spacer()

                    Button(action: { showingEntropyDetails = true }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.sunglow)
                    }
                }
                .padding()

                // Zone de cartes
                GeometryReader { geometry in
                    let positions = reading.configuration.spreadType.cardPositions(containerSize: geometry.size)

                    ZStack {
                        ForEach(Array(reading.cards.enumerated()), id: \.element.id) { index, card in
                            let position = positions[index]
                            let isRevealed = revealedCards.contains(index)

                            CardView3D(
                                card: card,
                                isRevealed: isRevealed,
                                position: reading.configuration.spreadType.positions[index]
                            )
                            .position(x: position.x, y: position.y)
                            .rotationEffect(.degrees(position.rotation))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    if isRevealed {
                                        selectedCard = card
                                    } else {
                                        revealCard(at: index)
                                    }
                                }
                            }
                        }
                    }
                }

                // Bouton de révélation automatique
                if revealedCards.count < reading.cards.count {
                    Button(action: revealNextCard) {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("Révéler la Prochaine Carte")
                        }
                        .foregroundColor(.trueBlack)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [.gold, .sunglow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .padding()
                    }
                } else {
                    Text("Tapez sur une carte pour voir sa signification")
                        .font(.system(size: 14))
                        .foregroundColor(.malibu.opacity(0.7))
                        .padding()
                }
            }
        }
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card)
        }
        .sheet(isPresented: $showingEntropyDetails) {
            EntropyDetailsView(reading: reading)
        }
        .onAppear {
            // Révélation automatique séquentielle
            revealCardsSequentially()
        }
    }

    private func revealCard(at index: Int) {
        revealedCards.insert(index)
        // Feedback haptique
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func revealNextCard() {
        if let nextIndex = (0..<reading.cards.count).first(where: { !revealedCards.contains($0) }) {
            revealCard(at: nextIndex)
        }
    }

    private func revealCardsSequentially() {
        for (index, _) in reading.cards.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    revealCard(at: index)
                }
            }
        }
    }
}

// MARK: - Vue de carte 3D avec flip

struct CardView3D: View {
    let card: TarotCard
    let isRevealed: Bool
    let position: String

    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Face cachée (dos de carte)
                CardBackView()
                    .opacity(isRevealed ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(rotationAngle),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )

                // Face révélée
                CardFrontView(card: card)
                    .opacity(isRevealed ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(rotationAngle + 180),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )
                    .rotationEffect(.degrees(card.orientation == .reversed ? 180 : 0))
            }
            .frame(width: 80, height: 120)
            .shadow(color: isRevealed ? .gold.opacity(0.5) : .clear, radius: 15)

            // Label de position
            Text(position)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.malibu)
                .multilineTextAlignment(.center)
                .frame(width: 90)
        }
        .onChange(of: isRevealed) { _, newValue in
            withAnimation(.easeInOut(duration: 0.6)) {
                rotationAngle = newValue ? 180 : 0
            }
        }
    }
}

struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(
                    colors: [.deepKoamaru, .amethyst],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                ZStack {
                    // Motif mystique
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gold.opacity(0.3))

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gold.opacity(0.5), lineWidth: 2)
                        .padding(5)
                }
            )
    }
}

struct CardFrontView: View {
    let card: TarotCard

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .overlay(
                VStack(spacing: 8) {
                    // Symbole
                    Image(systemName: card.symbolImage)
                        .font(.system(size: 30))
                        .foregroundColor(card.primaryColor)

                    // Nom
                    Text(card.nameFr)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.trueBlack)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 4)

                    // Indicateur d'orientation
                    if card.orientation == .reversed {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.7))
                    }
                }
                .padding(8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(card.primaryColor, lineWidth: 2)
            )
    }
}

// MARK: - Vue de détails d'une carte

struct CardDetailView: View {
    @Environment(\.dismiss) var dismiss
    let card: TarotCard

    var body: some View {
        NavigationView {
            ZStack {
                CosmicStarfieldView()

                ScrollView {
                    VStack(spacing: 25) {
                        // Grande carte
                        VStack(spacing: 15) {
                            Image(systemName: card.symbolImage)
                                .font(.system(size: 80))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [card.primaryColor, .gold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: card.primaryColor.opacity(0.5), radius: 20)

                            Text(card.displayName())
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.gold)
                                .multilineTextAlignment(.center)

                            Text(card.orientation.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(card.orientation == .upright ? .malibu : .red)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.deepKoamaru.opacity(0.7))
                                )
                        }
                        .padding(.top, 30)

                        // Mots-clés
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(card.keywords, id: \.self) { keyword in
                                    Text(keyword)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(card.primaryColor.opacity(0.3))
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Signification principale
                        DetailSection(
                            title: "Signification Générale",
                            content: card.meaning.general,
                            icon: "book.fill"
                        )

                        // Signification selon orientation
                        DetailSection(
                            title: card.orientation == .upright ? "Droite" : "Inversée",
                            content: card.currentMeaning,
                            icon: card.orientation == .upright ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
                        )

                        // Domaines spécifiques
                        DetailSection(title: "Amour", content: card.meaning.love, icon: "heart.fill")
                        DetailSection(title: "Carrière", content: card.meaning.career, icon: "briefcase.fill")
                        DetailSection(title: "Santé", content: card.meaning.health, icon: "heart.text.square.fill")
                        DetailSection(title: "Spiritualité", content: card.meaning.spirituality, icon: "sparkles")

                        // Conseil
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Conseil", systemImage: "lightbulb.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.sunglow)

                            Text(card.meaning.advice)
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(.white)
                                .italic()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.sunglow.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.sunglow.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .padding(.horizontal)

                        // Symbolisme
                        DetailSection(title: "Symbolisme", content: card.symbolism, icon: "eye.fill")
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(.gold)
                }
            }
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gold)

            Text(content)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.deepKoamaru.opacity(0.5))
        )
        .padding(.horizontal)
    }
}

// MARK: - Vue des détails d'entropie

struct EntropyDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let reading: TarotReading

    var body: some View {
        NavigationView {
            ZStack {
                CosmicStarfieldView()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if let entropy = reading.entropyData {
                            // Mode
                            InfoCard(title: "Mode de Génération", value: entropy.mode, icon: "atom")

                            // Timestamp
                            InfoCard(
                                title: "Timestamp",
                                value: entropy.timestamp.formatted(date: .long, time: .complete),
                                icon: "clock.fill"
                            )

                            // Hash
                            if let hash = entropy.hash {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Hash SHA-256", systemImage: "number.circle.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.gold)

                                    Text(hash)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.malibu)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.deepKoamaru.opacity(0.7))
                                        )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.deepKoamaru.opacity(0.5))
                                )
                                .padding(.horizontal)
                            }

                            // Données de capteurs (mode cosmique)
                            if let sensors = entropy.sensorData {
                                SensorDataCard(sensors: sensors)
                            }

                            // Sceau de vérification
                            if entropy.mode.contains("Quantique") {
                                VStack(spacing: 10) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gold)

                                    Text("Quantique Vérifié")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.gold)

                                    Text("Généré via ANU QRNG")
                                        .font(.system(size: 13))
                                        .foregroundColor(.malibu)

                                    Link("Vérifier sur qrng.anu.edu.au", destination: URL(string: "https://qrng.anu.edu.au")!)
                                        .font(.system(size: 12))
                                        .foregroundColor(.sunglow)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.deepKoamaru.opacity(0.7))
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Détails d'Entropie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(.gold)
                }
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gold.opacity(0.8))

            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.deepKoamaru.opacity(0.5))
        )
        .padding(.horizontal)
    }
}

struct SensorDataCard: View {
    let sensors: TarotReading.EntropyData.SensorSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Données des Capteurs")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gold)

            if let gyro = sensors.gyro {
                DataRow(title: "Gyroscope", value: "\(gyro.count) échantillons")
            }

            if let accel = sensors.accelerometer {
                DataRow(title: "Accéléromètre", value: "\(accel.count) échantillons")
            }

            if let location = sensors.location {
                DataRow(title: "Latitude", value: String(format: "%.6f°", location.latitude))
                DataRow(title: "Longitude", value: String(format: "%.6f°", location.longitude))
                DataRow(title: "Altitude", value: String(format: "%.1f m", location.altitude))
            }

            if let moonPhase = sensors.moonPhase {
                DataRow(title: "Phase Lunaire", value: String(format: "%.2f", moonPhase))
            }

            if let solarDec = sensors.solarDeclination {
                DataRow(title: "Déclinaison Solaire", value: String(format: "%.2f°", solarDec))
            }

            if let julian = sensors.julianDay {
                DataRow(title: "Jour Julien", value: String(format: "%.2f", julian))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.deepKoamaru.opacity(0.5))
        )
        .padding(.horizontal)
    }
}

struct DataRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.malibu.opacity(0.8))

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    let mockCard = TarotDeck.majorArcana[0]
    let mockReading = TarotReading(
        id: UUID(),
        date: Date(),
        configuration: ReadingConfiguration(
            spreadType: .single,
            allowReversed: true,
            deckType: .full,
            randomMode: .quantum,
            language: "fr"
        ),
        cards: [mockCard],
        entropyData: nil
    )
    return ReadingView(reading: mockReading) {}
}
