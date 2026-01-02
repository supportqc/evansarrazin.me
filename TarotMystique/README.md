# 🌙 Tarot Mystique

Application iOS complète de tarot mystique avec génération aléatoire quantique et cosmique, développée en Swift avec SwiftUI.

## ✨ Fonctionnalités Principales

### 🎴 Tirages de Tarot
- **Simple** : 1 carte pour une réponse rapide
- **Passé-Présent-Futur** : 3 cartes alignées horizontalement
- **Croix Celtique** : 10 cartes disposées en croix (tirage complet)
- **Fer à Cheval** : 7 cartes en arc de cercle

### 🃏 Deck Complet (78 cartes)
- **22 Arcanes Majeurs** : Du Mat (0) au Monde (21), avec significations détaillées de 300-500 mots par carte
- **56 Arcanes Mineurs** : 4 suites (Bâtons/Feu, Coupes/Eau, Épées/Air, Deniers/Terre)
  - As à 10 pour chaque suite
  - Valet, Chevalier, Reine, Roi pour chaque suite

### 🎲 Modes de Génération Aléatoire

#### 🔬 Mode Quantique (Recommandé)
- Connexion à l'**API ANU QRNG** (Australian National University)
- Génération de nombres vraiment aléatoires basés sur les fluctuations quantiques du vide
- Affichage des données brutes, hash SHA-256 de vérification, et sceau "Quantique Vérifié"
- Fallback automatique sur le mode Cosmique en cas d'erreur réseau

#### 🌌 Mode Cosmique
- Utilise les capteurs iPhone pour générer une entropie unique :
  - **Gyroscope** et **Accéléromètre** (Core Motion)
  - **GPS** (latitude, longitude, altitude via Core Location)
  - **Phase lunaire** calculée en temps réel
  - **Déclinaison solaire** calculée en temps réel
  - **Jour julien** (conversion de date)
  - **Timestamp haute précision** (nanoseconde)
- Combinaison de toutes ces sources via hash **SHA-256** (CryptoKit)
- Affichage de toutes les données de capteurs et de la carte du ciel

### 🎨 Design et UI

#### Palette de Couleurs Cosmique
- **Deep Koamaru** (#1a0a2e) : Fonds secondaires et bordures
- **Amethyst** (#ab47bd) : Accents mystiques et boutons primaires
- **Gold** (#ffd700) : Lueurs, textes importants et effets dorés
- **Malibu** (#65b5f6) : Éléments interactifs et icônes
- **Sunglow** (#ffc929) : Highlights et animations
- **True Black OLED** (#000000) : Fond principal pour économiser la batterie

#### Fond Étoilé Cosmique
- ~400 étoiles scintillantes avec couleurs stellaires réalistes (types O, B, A, F, G, K, M)
- 15 étoiles brillantes avec rayons de diffraction (lens flare)
- Effet parallaxe réagissant au gyroscope en temps réel
- Gradient de la Voie Lactée subtil et animé

### 🎭 Fonctionnalités Avancées
- **Cartes inversées** : Option pour tirer des cartes droites ou inversées (50% de chance)
- **Animations fluides** : Flip 3D des cartes, révélation séquentielle avec délai
- **Feedback haptique** : Vibrations lors des interactions (flip, glissement)
- **Significations détaillées** : Général, Amour, Carrière, Santé, Spiritualité, Conseil, Symbolisme
- **Support multilingue** : Français et Anglais

## 📋 Prérequis

- **Xcode 15+** (iOS 17+)
- **macOS Ventura** ou supérieur
- **iPhone** ou **iPad** avec iOS 17+ pour tester les capteurs
- **Connexion Internet** pour le mode Quantique (API ANU QRNG)

## 🛠 Installation et Configuration

### 1. Ouvrir le projet dans Xcode

```bash
cd TarotMystique
open TarotMystique.xcodeproj
```

Si vous n'avez pas encore créé le projet Xcode :

1. Ouvrez Xcode
2. File > New > Project
3. Sélectionnez **iOS > App**
4. Remplissez :
   - **Product Name** : TarotMystique
   - **Team** : Votre équipe de développement
   - **Organization Identifier** : com.votreentreprise
   - **Interface** : SwiftUI
   - **Language** : Swift
   - **Storage** : None
5. Créez le projet
6. Copiez tous les fichiers de ce repository dans le dossier du projet

### 2. Configurer les permissions (Info.plist)

Le fichier `Info.plist` est déjà configuré avec les permissions nécessaires :

- ✅ **NSMotionUsageDescription** : Gyroscope et accéléromètre
- ✅ **NSLocationWhenInUseUsageDescription** : GPS/localisation
- ✅ **NSAppTransportSecurity** : Sécurité réseau pour l'API ANU QRNG

**Important** : Assurez-vous que le fichier `Info.plist` est bien inclus dans votre projet Xcode :
- Sélectionnez le projet dans le navigateur
- Target > TarotMystique > Build Phases > Copy Bundle Resources
- Vérifiez que `Info.plist` est présent (sinon, ajoutez-le)

### 3. Configurer les Capabilities

Dans Xcode :
1. Sélectionnez le projet dans le navigateur
2. Target > TarotMystique > Signing & Capabilities
3. Ajoutez :
   - ✅ **Location** (si absent, ajoutez via + Capability)
   - ✅ **Background Modes** (cochez "Location updates" si nécessaire pour le mode cosmique)

### 4. Structure des fichiers

```
TarotMystique/
├── TarotMystique/
│   ├── Models/
│   │   ├── CardModel.swift              # Modèle de carte de tarot
│   │   ├── SpreadType.swift             # Types de tirages
│   │   └── TarotDeck.swift              # Deck complet (78 cartes)
│   ├── Services/
│   │   ├── QuantumRandomService.swift   # Service API ANU QRNG
│   │   ├── CosmicRandomService.swift    # Service entropie cosmique
│   │   └── ReadingService.swift         # Service de gestion des tirages
│   ├── Views/
│   │   ├── HomeView.swift               # Vue d'accueil
│   │   ├── ReadingView.swift            # Vue de tirage
│   │   └── CosmicStarfieldView.swift    # Fond étoilé animé
│   ├── Utilities/
│   │   └── ColorPalette.swift           # Palette de couleurs
│   ├── Assets.xcassets/                 # Assets (images, couleurs)
│   ├── Info.plist                       # Permissions et configuration
│   └── TarotMystiqueApp.swift           # Point d'entrée
└── README.md                            # Ce fichier
```

### 5. Ajouter des assets de cartes (Optionnel mais recommandé)

Pour améliorer l'expérience visuelle, vous pouvez ajouter des illustrations personnalisées :

1. Créez ou téléchargez des illustrations de tarot (format PNG, SVG ou PDF)
2. Dans Xcode, ouvrez `Assets.xcassets`
3. Créez un dossier "Cards" (clic droit > New Folder)
4. Ajoutez vos images (ex: `the-fool.png`, `the-magician.png`, etc.)
5. Dans `CardModel.swift`, modifiez la propriété `symbolImage` pour utiliser vos assets :

```swift
var symbolImage: String {
    // Remplacez par le nom de votre asset
    return "cards/\(nameFr.lowercased().replacingOccurrences(of: " ", with: "-"))"
}
```

**Sources d'illustrations gratuites** :
- [Rider-Waite Tarot](https://en.wikipedia.org/wiki/Rider%E2%80%93Waite_Tarot) (domaine public)
- [Tarot de Marseille](https://fr.wikipedia.org/wiki/Tarot_de_Marseille) (domaine public)
- Sites comme Pixabay, Unsplash (vérifiez les licences)

## 🚀 Utilisation

### Lancer l'application

1. Connectez votre iPhone/iPad (recommandé pour tester les capteurs) ou utilisez le simulateur
2. Sélectionnez votre appareil dans la barre d'outils Xcode
3. Cliquez sur **Run** (▶︎) ou appuyez sur `Cmd + R`
4. **Autorisez les permissions** :
   - Motion & Fitness (gyroscope/accéléromètre)
   - Localisation (GPS)

### Effectuer un tirage

1. **Sélectionnez un type de tirage** :
   - Simple (1 carte)
   - Passé-Présent-Futur (3 cartes)
   - Croix Celtique (10 cartes)
   - Fer à Cheval (7 cartes)

2. **Choisissez un mode de génération** :
   - **Quantique** : Utilise l'API ANU QRNG (requiert Internet)
   - **Cosmique** : Utilise les capteurs de l'iPhone

3. **Configurez les options** :
   - Activez/désactivez les cartes inversées
   - Choisissez le deck (Complet 78 cartes ou Majeurs uniquement 22 cartes)

4. **Appuyez sur "Commencer le Tirage"**
   - Les cartes seront révélées séquentiellement avec animation
   - Tapez sur une carte révélée pour voir sa signification complète
   - Tapez sur l'icône info (ⓘ) pour voir les détails d'entropie

### Navigation

- **Bouton X** : Retour à l'écran d'accueil
- **Bouton Info** : Afficher les détails d'entropie (données quantiques/cosmiques)
- **Tap sur carte** : Afficher la signification détaillée
- **Paramètres** : Changer la langue (français/anglais)

## 🔬 API ANU QRNG

L'application utilise l'API publique de l'Australian National University :
- **URL** : `https://qrng.anu.edu.au/API/jsonI.php`
- **Type** : uint16 (entiers non signés de 16 bits)
- **Limite** : 1024 nombres par requête
- **Gratuite** et accessible sans clé API

**Exemple de requête** :
```
https://qrng.anu.edu.au/API/jsonI.php?length=78&type=uint16
```

**Réponse** :
```json
{
  "type": "uint16",
  "length": 78,
  "data": [12345, 54321, ...],
  "success": true
}
```

## 🧪 Tests

### Tests sur simulateur
- Le fond étoilé et les animations fonctionnent
- Le mode Quantique fonctionne (si Internet disponible)
- ⚠️ Le mode Cosmique sera limité (pas de gyroscope/GPS sur simulateur)

### Tests sur appareil physique (Recommandé)
- Toutes les fonctionnalités sont disponibles
- Testez les mouvements pour voir l'effet parallaxe du fond étoilé
- Testez les deux modes de génération (Quantique et Cosmique)
- Testez en mode avion (fallback Quantique → Cosmique)

## 📐 Architecture

### Modèles (Models/)
- **CardModel** : Représente une carte de tarot avec orientation, significations, etc.
- **SpreadType** : Énumération des types de tirages avec positions
- **TarotDeck** : Deck complet de 78 cartes avec significations détaillées

### Services (Services/)
- **QuantumRandomService** : Gère l'API ANU QRNG avec fallback
- **CosmicRandomService** : Collecte l'entropie des capteurs (Core Motion, Core Location)
- **ReadingService** : Orchestre la génération des tirages et le shuffle

### Vues (Views/)
- **HomeView** : Écran d'accueil avec sélection de tirage et options
- **ReadingView** : Affichage des cartes avec animations 3D
- **CosmicStarfieldView** : Fond étoilé animé avec parallaxe gyroscopique

### Utilities (Utilities/)
- **ColorPalette** : Palette de couleurs cosmique (extensions SwiftUI Color)

## 🎨 Personnalisation

### Modifier les couleurs
Éditez `Utilities/ColorPalette.swift` :

```swift
static let myCustomColor = Color(red: 255/255, green: 100/255, blue: 50/255)
```

### Ajouter des significations de cartes
Éditez `Models/TarotDeck.swift` et complétez la fonction `generateMinorMeaning()` pour les rangs 4-10 des Arcanes Mineurs.

### Personnaliser les animations
Dans `Views/ReadingView.swift`, modifiez les durées et styles d'animation :

```swift
withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
    // Votre animation
}
```

## 🐛 Dépannage

### Problème : "Permission denied" pour les capteurs
- Vérifiez que les descriptions de permissions sont bien dans `Info.plist`
- Allez dans Réglages > Tarot Mystique > Autorisez Motion & Localisation

### Problème : "API Quantique échoue systématiquement"
- Vérifiez votre connexion Internet
- L'app devrait fallback automatiquement sur le mode Cosmique
- Testez l'URL de l'API dans un navigateur : https://qrng.anu.edu.au/API/jsonI.php?length=10&type=uint16

### Problème : "Fond étoilé ne s'affiche pas"
- Vérifiez que `CosmicStarfieldView.swift` est bien inclus dans le projet
- Relancez l'app (Cmd + R)

### Problème : "Les cartes ne se retournent pas"
- Vérifiez que vous avez bien attendu la révélation séquentielle (0.5s par carte)
- Tapez sur une carte révélée (pas sur le dos)

## 📚 Ressources

### Tarot
- [Rider-Waite Tarot](https://en.wikipedia.org/wiki/Rider%E2%80%93Waite_Tarot)
- [Tarot de Marseille](https://fr.wikipedia.org/wiki/Tarot_de_Marseille)
- [Rachel Pollack - "Seventy-Eight Degrees of Wisdom"](https://www.goodreads.com/book/show/119052.Seventy_Eight_Degrees_of_Wisdom)

### SwiftUI et iOS
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Core Motion Framework](https://developer.apple.com/documentation/coremotion)
- [Core Location Framework](https://developer.apple.com/documentation/corelocation)
- [CryptoKit](https://developer.apple.com/documentation/cryptokit)

### API Quantique
- [ANU QRNG](https://qrng.anu.edu.au/)
- [QRNG API Documentation](https://qrng.anu.edu.au/contact/api-documentation/)

## 📄 Licence

Ce projet est fourni à titre éducatif et de démonstration. Les significations de tarot sont basées sur des interprétations classiques du domaine public.

## 🙏 Crédits

- **Développement** : Application iOS Swift/SwiftUI
- **API Quantique** : Australian National University (ANU) QRNG
- **Inspiration Design** : Apple Design Awards Winners
- **Significations de Tarot** : Interprétations classiques (Rider-Waite-Smith, Tarot de Marseille)

---

**Développé avec ❤️ et ✨ magie cosmique**

🌙 *Que les arcanes vous guident* 🌟
