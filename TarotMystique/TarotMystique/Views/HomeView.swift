//
//  HomeView.swift
//  TarotMystique
//
//  Vue d'accueil principale de l'application
//

import SwiftUI

struct HomeView: View {
    @StateObject private var readingService = ReadingService()
    @State private var selectedSpread: SpreadType = .single
    @State private var selectedMode: ReadingConfiguration.RandomMode = .quantum
    @State private var allowReversed: Bool = true
    @State private var deckType: ReadingConfiguration.DeckType = .full
    @State private var language: String = "fr"
    @State private var showingReading = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                // Fond étoilé cosmique
                CosmicStarfieldView()

                ScrollView {
                    VStack(spacing: 30) {
                        // Titre mystique
                        VStack(spacing: 10) {
                            Image(systemName: "moon.stars.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.gold, .amethyst, .sunglow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .gold.opacity(0.5), radius: 20)

                            Text("Tarot Mystique")
                                .font(.system(size: 42, weight: .bold, design: .serif))
                                .foregroundColor(.gold)
                                .shadow(color: .gold.opacity(0.5), radius: 10)

                            Text("Exploration Cosmique des Arcanes")
                                .font(.system(size: 16, weight: .light, design: .serif))
                                .foregroundColor(.malibu)
                                .opacity(0.8)
                        }
                        .padding(.top, 60)

                        // Sélection du type de tirage
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Type de Tirage")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.gold)

                            ForEach(SpreadType.allCases) { spread in
                                SpreadButton(
                                    spread: spread,
                                    isSelected: selectedSpread == spread
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSpread = spread
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Sélection du mode aléatoire
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Mode de Génération")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.gold)

                            HStack(spacing: 15) {
                                ModeButton(
                                    title: "Quantique",
                                    subtitle: "API ANU QRNG",
                                    icon: "atom",
                                    isSelected: selectedMode == .quantum
                                ) {
                                    withAnimation {
                                        selectedMode = .quantum
                                    }
                                }

                                ModeButton(
                                    title: "Cosmique",
                                    subtitle: "Capteurs iPhone",
                                    icon: "gyroscope",
                                    isSelected: selectedMode == .cosmic
                                ) {
                                    withAnimation {
                                        selectedMode = .cosmic
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Options
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Options")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.gold)

                            VStack(spacing: 12) {
                                OptionToggle(
                                    title: "Cartes Inversées",
                                    subtitle: "Permet aux cartes d'être inversées",
                                    isOn: $allowReversed
                                )

                                Picker("Deck", selection: $deckType) {
                                    ForEach(ReadingConfiguration.DeckType.allCases, id: \.self) { type in
                                        Text(type.rawValue)
                                            .tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .colorMultiply(.amethyst)
                            }
                            .padding()
                            .background(Color.deepKoamaru.opacity(0.5))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)

                        // Bouton principal de tirage
                        Button(action: performReading) {
                            HStack(spacing: 15) {
                                if readingService.isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .trueBlack))
                                } else {
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                }

                                Text(readingService.isGenerating ? "Génération..." : "Commencer le Tirage")
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .foregroundColor(.trueBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.gold, .sunglow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: .gold.opacity(0.5), radius: 15, y: 5)
                        }
                        .disabled(readingService.isGenerating)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.malibu)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(language: $language)
        }
        .fullScreenCover(isPresented: $showingReading) {
            if let reading = readingService.currentReading {
                ReadingView(reading: reading) {
                    showingReading = false
                }
            }
        }
    }

    private func performReading() {
        let configuration = ReadingConfiguration(
            spreadType: selectedSpread,
            allowReversed: allowReversed,
            deckType: deckType,
            randomMode: selectedMode,
            language: language
        )

        Task {
            do {
                try await readingService.generateReading(configuration: configuration)
                await MainActor.run {
                    showingReading = true
                }
            } catch {
                print("❌ Erreur de génération: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Composants d'UI

struct SpreadButton: View {
    let spread: SpreadType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: spread.iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .gold : .malibu)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(spread.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Text(spread.description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }

                Spacer()

                Text("\(spread.cardCount)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? .gold : .malibu.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(isSelected ? Color.gold.opacity(0.2) : Color.malibu.opacity(0.1))
                    )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.deepKoamaru.opacity(0.8) : Color.deepKoamaru.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color.gold : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ModeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .gold : .malibu)

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.deepKoamaru.opacity(0.8) : Color.deepKoamaru.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color.gold : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OptionToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .gold))
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var language: String

    var body: some View {
        NavigationView {
            ZStack {
                CosmicStarfieldView()

                Form {
                    Section("Langue") {
                        Picker("Langue", selection: $language) {
                            Text("Français").tag("fr")
                            Text("English").tag("en")
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Paramètres")
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

#Preview {
    HomeView()
}
