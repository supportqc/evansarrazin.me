# 🔥 Gaydar - Proximity-based Abstract Social App

Une application mobile de proximité sensorielle, basée sur la géolocalisation réelle, l'anonymat total, et les vibrations codées. Disponible sur iOS et Android.

## 🎯 Concept

Gaydar n'est pas une application de dating classique. C'est une **expérience sensorielle** basée sur la proximité réelle et l'anonymat.

**L'utilisateur ne voit pas les autres. Il les perçoit.**

## ✨ Fonctionnalités

### 📍 Géolocalisation Réelle
- Utilise la vraie position GPS de l'utilisateur
- Permissions foreground et background (iOS & Android)
- Précision volontairement réduite pour la discrétion
- Mises à jour raisonnables (conformité iOS)

### 🎚️ Radar Abstrait
- Interface minimaliste avec cercles concentriques
- Points lumineux représentant les utilisateurs proches
- Positionnement abstrait (pas de direction précise)
- Intensité et taille des points basées sur la distance réelle
- Animations fluides et organiques

### 📳 Vibrations Codées
- Vibrations déclenchées par la proximité réelle
- **< 20m** : vibrations rapides (500ms)
- **20-50m** : vibrations modérées (1.5s)
- **50-100m** : vibrations lentes (3s)
- **100-200m** : vibrations très lentes (5s)
- **> 200m** : aucune vibration

### 👻 Mode Fantôme
- L'utilisateur continue à recevoir les vibrations
- Il n'apparaît plus dans le radar des autres
- Aucun nouveau croisement n'est créé
- Toggle discret dans l'en-tête

### 🔁 Croisements
- Créés automatiquement quand deux utilisateurs restent proches (< 50m) pendant 15+ secondes
- Affichage de l'heure relative ("il y a 8 min")
- Distance approximative
- Permet d'initier un chat anonyme

### 💬 Chat Anonyme
- Identités éphémères (ex: "Echo-27")
- Messages texte uniquement
- Interface sobre et intime
- Possibilité de supprimer la conversation instantanément
- Local state uniquement (pas de backend)

### 🎚️ Filtres de Visibilité
- **Âge** : range min-max
- **Rôle** : top / versatile / bottom
- **Visibilité** : toggle pour apparaître ou non dans le radar

**Important** : Ces filtres déterminent si l'utilisateur apparaît dans le radar des autres, ils ne filtrent pas ce que l'utilisateur voit.

### 🧪 Mode Test
- Active des utilisateurs fictifs autour de la position GPS réelle
- Permet de tester l'app sans autres utilisateurs réels
- Utilisateurs fictifs :
  - Apparaissent dans le radar
  - Déclenchent les vibrations
  - Créent des croisements
  - Peuvent chatter (réponses automatiques simulées)
- Toggle discret dans les filtres
- Facile à supprimer plus tard

## 🏗️ Architecture Technique

### Stack
- **React Native** avec **Expo**
- **Mono-fichier** : toute la logique dans `App.js`
- **expo-location** pour la géolocalisation
- **expo-haptics** pour les vibrations
- **Animated API** pour les animations

### Structure du Code
```
App.js (1200+ lignes)
├── State Management
├── Location & Permissions
├── Test Mode (fake users)
├── Distance Calculation (Haversine)
├── Haptic Feedback
├── Crossings/Encounters
├── Chat System
├── Animations
├── Radar Visualization
├── UI Views (Radar, Crossings, Chat, Filters)
└── Styles
```

### Permissions Configurées
**iOS** :
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `UIBackgroundModes: ["location"]`

**Android** :
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `ACCESS_BACKGROUND_LOCATION`
- `VIBRATE`

## 🚀 Installation & Lancement

### Prérequis
- Node.js (v18+)
- npm ou yarn
- Expo Go app (sur votre téléphone) OU un simulateur iOS/Android

### Installation
```bash
cd Gaydar
npm install
```

### Lancement
```bash
# Démarrer le serveur Expo
npm start

# Ou directement sur une plateforme
npm run ios      # iOS (nécessite macOS)
npm run android  # Android
npm run web      # Web (fonctionnalités limitées)
```

### Tester sur un appareil physique
1. Installez **Expo Go** depuis l'App Store (iOS) ou Play Store (Android)
2. Lancez `npm start`
3. Scannez le QR code avec votre téléphone
4. Autorisez les permissions de localisation

### Mode Test
Pour tester l'app sans autres utilisateurs réels :
1. Ouvrez l'app
2. Allez dans l'onglet **Filtres**
3. Activez **"Mode Test (utilisateurs fictifs)"**
4. Retournez sur le **Radar** pour voir les utilisateurs simulés
5. Les vibrations et croisements fonctionnent normalement

## 🎨 Design Principles

### Esthétique Premium
- Fond noir graphite (#0a0a0a)
- Couleurs principales : vert néon (#00ff88), cyan (#00ccff)
- Glow subtil sur les éléments interactifs
- Typographie claire et lisible
- Animations douces et organiques

### UX Stricte
- ❌ Pas de photos
- ❌ Pas de profils détaillés
- ❌ Pas de swipe
- ❌ Pas de gamification
- ✅ Discrétion
- ✅ Mystère
- ✅ Présence
- ✅ Intimité

### Contraintes iOS & Android
- Précision GPS volontairement réduite
- Fréquence de mise à jour raisonnable (10s, 10m)
- Pas de carte (MapView)
- Pas de coordonnées affichées
- Pas de direction précise

## 📱 Captures d'écran

### Écran Radar
- Cercles concentriques animés
- Points lumineux représentant les utilisateurs proches
- Point central pulsant (utilisateur)
- Balayage radar en rotation

### Écran Croisements
- Liste des rencontres récentes
- Heure relative, distance, localisation abstraite
- Tap pour initier un chat

### Écran Chat
- Interface minimaliste
- Bulles de messages (vous / eux)
- Input avec bouton d'envoi
- Bouton de suppression

### Écran Filtres
- Range d'âge
- Sélection de rôle
- Toggle de visibilité
- Toggle mode test
- Identité éphémère affichée

## 🔒 Vie Privée & Sécurité

- Aucune donnée personnelle collectée
- Identités éphémères générées aléatoirement
- Pas de backend (tout en local)
- Pas de stockage permanent
- Localisation utilisée uniquement pour calculer des distances relatives
- Aucune coordonnée GPS affichée ou stockée

## 🧹 Code Quality

- Code clair et commenté (français + anglais)
- Architecture single-file pour simplicité
- Gestion d'état React avec hooks
- Nettoyage des intervals/listeners
- Gestion des permissions robuste
- Fallbacks et error handling

## 📋 TODO Future

- [ ] Backend pour utilisateurs réels (WebSocket)
- [ ] Notifications push
- [ ] Historique des croisements persistant
- [ ] Photos floues/abstraites optionnelles
- [ ] Suppression du mode test
- [ ] Analytics anonymes
- [ ] Rapport de bugs in-app
- [ ] Authentification anonyme

## 🤝 Contribution

Ce projet est un prototype. Les contributions sont les bienvenues pour :
- Améliorer les animations
- Optimiser les performances
- Ajouter des tests
- Améliorer l'accessibilité

## 📄 Licence

MIT License - Libre d'utilisation et modification

## 🙏 Remerciements

Créé avec passion pour explorer les limites de la proximité digitale et de l'anonymat dans les apps sociales.

**Gaydar** - *"You don't see them. You feel them."*

---

**⚠️ Note importante** : Cette application utilise la géolocalisation réelle. Assurez-vous de respecter les lois locales et la vie privée des utilisateurs lors du déploiement en production.
