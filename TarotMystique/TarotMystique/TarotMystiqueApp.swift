//
//  TarotMystiqueApp.swift
//  TarotMystique
//
//  Point d'entrée principal de l'application
//

import SwiftUI

@main
struct TarotMystiqueApp: App {
    init() {
        // Configuration initiale de l'app
        setupAppearance()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark) // Force le mode sombre
        }
    }

    /// Configure l'apparence globale de l'app
    private func setupAppearance() {
        // Navigation bar personnalisée
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color.trueBlack.opacity(0.8))
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.gold),
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.gold),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // Tab bar (si nécessaire)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.trueBlack.opacity(0.95))
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
