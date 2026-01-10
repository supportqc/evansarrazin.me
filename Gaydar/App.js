import React, { useState, useEffect, useRef } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Animated,
  Dimensions,
  TouchableOpacity,
  ScrollView,
  TextInput,
  Switch,
  SafeAreaView,
  StatusBar,
  Alert,
  Platform,
} from 'react-native';
import * as Location from 'expo-location';
import * as Haptics from 'expo-haptics';
import { DeviceMotion } from 'expo-sensors';
import { LinearGradient } from 'expo-linear-gradient';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');
const RADAR_SIZE = Math.min(SCREEN_WIDTH, SCREEN_HEIGHT) * 0.7;

// ═══════════════════════════════════════════════════════════════════════════
// GAYDAR - Proximity-based abstract social app
// Architecture: Single file, real GPS, haptic feedback, anonymous & abstract
// ═══════════════════════════════════════════════════════════════════════════

export default function App() {
  // ─────────────────────────────────────────────────────────────────────────
  // STATE MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  // Location & Permissions
  const [location, setLocation] = useState(null);
  const [locationPermission, setLocationPermission] = useState(null);

  // Compass heading (0 = North)
  const [heading, setHeading] = useState(0);

  // User Profile (filters that determine visibility to others)
  const [userProfile, setUserProfile] = useState({
    id: `echo-${Math.floor(Math.random() * 999)}`,
    ageMin: 18,
    ageMax: 99,
    role: 'versatile', // 'top' | 'bottom' | 'versatile'
    visible: true,
  });

  // Ghost Mode
  const [ghostMode, setGhostMode] = useState(false);

  // Test Mode (fake users for testing)
  const [testMode, setTestMode] = useState(false);
  const [nearbyUsers, setNearbyUsers] = useState([]);

  // Radar sweep angle for fade effect
  const [radarSweepAngle, setRadarSweepAngle] = useState(0);

  // Crossings (encounters)
  const [crossings, setCrossings] = useState([]);

  // Chat
  const [activeChat, setActiveChat] = useState(null);
  const [messages, setMessages] = useState({});
  const [messageInput, setMessageInput] = useState('');

  // UI State
  const [currentView, setCurrentView] = useState('radar'); // 'radar' | 'crossings' | 'chat' | 'filters'

  // Animations
  const pulseAnim = useRef(new Animated.Value(1)).current;
  const radarRotation = useRef(new Animated.Value(0)).current;
  const waveAnim1 = useRef(new Animated.Value(0)).current;
  const waveAnim2 = useRef(new Animated.Value(0)).current;
  const waveAnim3 = useRef(new Animated.Value(0)).current;
  const [showWave, setShowWave] = useState(false);

  // Haptic feedback refs
  const hapticInterval = useRef(null);
  const directionalHapticInterval = useRef(null);

  // Animation intervals
  const sweepIntervalRef = useRef(null);
  const radarAnimRef = useRef(null);

  // ─────────────────────────────────────────────────────────────────────────
  // LOCATION & PERMISSIONS
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    requestLocationPermissions();
  }, []);

  const requestLocationPermissions = async () => {
    try {
      // Check existing permissions first
      const { status: existingStatus } = await Location.getForegroundPermissionsAsync();

      if (existingStatus === 'granted') {
        setLocationPermission('granted');
        startLocationTracking();
        return;
      }

      // Request foreground permissions
      const { status: foregroundStatus } = await Location.requestForegroundPermissionsAsync();

      if (foregroundStatus !== 'granted') {
        Alert.alert(
          'Permission requise',
          'Gaydar a besoin de votre localisation pour fonctionner.'
        );
        setLocationPermission('denied');
        return;
      }

      // Request background permissions (iOS) - optional, don't block if fails
      if (Platform.OS === 'ios') {
        try {
          await Location.requestBackgroundPermissionsAsync();
        } catch (bgError) {
          console.log('Background permission optional:', bgError);
        }
      }

      setLocationPermission('granted');
      startLocationTracking();
    } catch (error) {
      console.error('Location permission error:', error);
      // Set as granted anyway to not block the app
      setLocationPermission('granted');
      startLocationTracking();
    }
  };

  const startLocationTracking = async () => {
    try {
      // Get initial location
      const initialLocation = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.Balanced, // Reduced precision intentionally
      });

      setLocation({
        latitude: initialLocation.coords.latitude,
        longitude: initialLocation.coords.longitude,
      });

      // Watch location updates (reasonable frequency for iOS compliance)
      Location.watchPositionAsync(
        {
          accuracy: Location.Accuracy.Balanced,
          timeInterval: 10000, // 10 seconds
          distanceInterval: 10, // 10 meters
        },
        (newLocation) => {
          setLocation({
            latitude: newLocation.coords.latitude,
            longitude: newLocation.coords.longitude,
          });
        }
      );
    } catch (error) {
      console.error('Location tracking error:', error);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────
  // COMPASS / DEVICE MOTION
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    let subscription;

    const startCompass = async () => {
      try {
        DeviceMotion.setUpdateInterval(100); // Update every 100ms

        subscription = DeviceMotion.addListener((data) => {
          if (data.rotation) {
            // Convert rotation to heading (0-360 degrees, 0 = North)
            // rotation.alpha gives us the compass heading on iOS
            // On Android, we might need to calculate differently
            const alpha = data.rotation.alpha || 0;
            const headingDegrees = (alpha * 180 / Math.PI) % 360;
            setHeading(headingDegrees);
          }
        });
      } catch (error) {
        console.log('Compass not available:', error);
      }
    };

    startCompass();

    return () => {
      if (subscription) {
        subscription.remove();
      }
    };
  }, []);

  // ─────────────────────────────────────────────────────────────────────────
  // TEST MODE: FAKE NEARBY USERS
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    if (testMode && location) {
      generateFakeUsers();

      // Auto-generate crossings and conversations after 3 seconds
      setTimeout(() => {
        generateTestCrossingsAndChats();
      }, 3000);

      const interval = setInterval(() => {
        updateFakeUsersPositions();
      }, 5000);
      return () => clearInterval(interval);
    } else {
      setNearbyUsers([]);
      // Clear test crossings and messages when disabling test mode
      setCrossings(prev => prev.filter(c => !c.userId.startsWith('test-user-')));
      setMessages({});
    }
  }, [testMode, location]);

  const generateFakeUsers = () => {
    if (!location) return;

    const fakeUsers = Array.from({ length: 5 }, (_, i) => ({
      id: `test-user-${i}`,
      name: `Echo-${10 + i}`,
      // Offset in degrees (roughly 20-300 meters)
      latitude: location.latitude + (Math.random() - 0.5) * 0.003,
      longitude: location.longitude + (Math.random() - 0.5) * 0.003,
      role: ['top', 'bottom', 'versatile'][Math.floor(Math.random() * 3)],
      lastSeen: Date.now(),
      proximityTime: 0, // Time spent in close proximity
    }));

    setNearbyUsers(fakeUsers);
  };

  const updateFakeUsersPositions = () => {
    setNearbyUsers(prev => prev.map(user => ({
      ...user,
      // Slight random movement
      latitude: user.latitude + (Math.random() - 0.5) * 0.0001,
      longitude: user.longitude + (Math.random() - 0.5) * 0.0001,
      lastSeen: Date.now(),
    })));
  };

  const generateTestCrossingsAndChats = () => {
    if (!testMode || nearbyUsers.length === 0) return;

    // Generate 3 random crossings
    const numCrossings = Math.min(3, nearbyUsers.length);
    const selectedUsers = nearbyUsers.slice(0, numCrossings);

    const newCrossings = selectedUsers.map((user, index) => ({
      id: `crossing-${Date.now()}-${index}`,
      userId: user.id,
      userName: user.name,
      timestamp: Date.now() - (index + 1) * 180000, // 3, 6, 9 minutes ago
      distance: Math.round(20 + Math.random() * 80), // 20-100m
      location: 'proche',
    }));

    setCrossings(prev => [...newCrossings, ...prev]);

    // Pre-fill conversations for the first 2 crossings
    const testMessages = {
      [selectedUsers[0].id]: [
        { id: 'msg-1', text: 'Salut', sender: 'them', timestamp: Date.now() - 150000 },
        { id: 'msg-2', text: 'Hey ! Comment ça va ?', sender: 'me', timestamp: Date.now() - 120000 },
        { id: 'msg-3', text: 'Bien et toi ? Tu es dans le coin ?', sender: 'them', timestamp: Date.now() - 90000 },
      ],
      [selectedUsers[1].id]: [
        { id: 'msg-4', text: '👋', sender: 'them', timestamp: Date.now() - 300000 },
        { id: 'msg-5', text: 'Salut !', sender: 'me', timestamp: Date.now() - 270000 },
      ],
    };

    setMessages(testMessages);

    // Haptic feedback for success
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  };

  // ─────────────────────────────────────────────────────────────────────────
  // DISTANCE CALCULATION (Haversine formula)
  // ─────────────────────────────────────────────────────────────────────────

  const calculateDistance = (lat1, lon1, lat2, lon2) => {
    const R = 6371e3; // Earth radius in meters
    const φ1 = (lat1 * Math.PI) / 180;
    const φ2 = (lat2 * Math.PI) / 180;
    const Δφ = ((lat2 - lat1) * Math.PI) / 180;
    const Δλ = ((lon2 - lon1) * Math.PI) / 180;

    const a =
      Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
      Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c; // Distance in meters
  };

  // Calculate bearing/angle from point A to point B
  const calculateBearing = (lat1, lon1, lat2, lon2) => {
    const φ1 = (lat1 * Math.PI) / 180;
    const φ2 = (lat2 * Math.PI) / 180;
    const Δλ = ((lon2 - lon1) * Math.PI) / 180;

    const y = Math.sin(Δλ) * Math.cos(φ2);
    const x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
    const θ = Math.atan2(y, x);
    const bearing = ((θ * 180 / Math.PI) + 360) % 360; // in degrees

    return bearing;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // DIRECTIONAL HAPTIC FEEDBACK (when phone points at user)
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    if (!location || nearbyUsers.length === 0 || ghostMode) {
      if (directionalHapticInterval.current) {
        clearInterval(directionalHapticInterval.current);
        directionalHapticInterval.current = null;
      }
      return;
    }

    // Check every 500ms
    const checkDirectionalHaptic = () => {
      // Find users in the direction phone is pointing (within 30 degree cone)
      const usersInDirection = nearbyUsers.filter(user => {
        const bearing = calculateBearing(
          location.latitude,
          location.longitude,
          user.latitude,
          user.longitude
        );

        // Calculate angle difference between phone heading and user bearing
        let angleDiff = Math.abs(heading - bearing);
        if (angleDiff > 180) angleDiff = 360 - angleDiff;

        // Within 30 degree cone
        return angleDiff < 30;
      });

      if (usersInDirection.length > 0) {
        // Find closest user in direction
        let closestInDirection = usersInDirection[0];
        let minDistance = calculateDistance(
          location.latitude,
          location.longitude,
          closestInDirection.latitude,
          closestInDirection.longitude
        );

        usersInDirection.forEach(user => {
          const dist = calculateDistance(
            location.latitude,
            location.longitude,
            user.latitude,
            user.longitude
          );
          if (dist < minDistance) {
            minDistance = dist;
            closestInDirection = user;
          }
        });

        // Trigger haptic based on distance (closer = stronger)
        let impactStyle = Haptics.ImpactFeedbackStyle.Light;

        if (minDistance < 20) {
          impactStyle = Haptics.ImpactFeedbackStyle.Heavy;
        } else if (minDistance < 50) {
          impactStyle = Haptics.ImpactFeedbackStyle.Medium;
        } else if (minDistance < 100) {
          impactStyle = Haptics.ImpactFeedbackStyle.Light;
        }

        Haptics.impactAsync(impactStyle);
      }
    };

    // Run check immediately
    checkDirectionalHaptic();

    // Set up interval
    directionalHapticInterval.current = setInterval(checkDirectionalHaptic, 500);

    return () => {
      if (directionalHapticInterval.current) {
        clearInterval(directionalHapticInterval.current);
      }
    };
  }, [location, nearbyUsers, ghostMode, heading]);

  // ─────────────────────────────────────────────────────────────────────────
  // HAPTIC FEEDBACK BASED ON DISTANCE (general proximity)
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    if (!location || nearbyUsers.length === 0 || ghostMode) {
      if (hapticInterval.current) {
        clearInterval(hapticInterval.current);
        hapticInterval.current = null;
      }
      return;
    }

    const closestUser = getClosestUser();
    if (!closestUser) return;

    const distance = calculateDistance(
      location.latitude,
      location.longitude,
      closestUser.latitude,
      closestUser.longitude
    );

    triggerHapticByDistance(distance);

    return () => {
      if (hapticInterval.current) {
        clearInterval(hapticInterval.current);
      }
    };
  }, [location, nearbyUsers, ghostMode]);

  const getClosestUser = () => {
    if (!location || nearbyUsers.length === 0) return null;

    let closest = nearbyUsers[0];
    let minDistance = calculateDistance(
      location.latitude,
      location.longitude,
      closest.latitude,
      closest.longitude
    );

    nearbyUsers.forEach(user => {
      const dist = calculateDistance(
        location.latitude,
        location.longitude,
        user.latitude,
        user.longitude
      );
      if (dist < minDistance) {
        minDistance = dist;
        closest = user;
      }
    });

    return closest;
  };

  const triggerHapticByDistance = (distance) => {
    // Clear existing interval
    if (hapticInterval.current) {
      clearInterval(hapticInterval.current);
      hapticInterval.current = null;
    }

    let hapticFrequency = null;

    // Distance-based haptic patterns
    if (distance < 20) {
      // Very close: rapid pulses
      hapticFrequency = 500; // ms
    } else if (distance < 50) {
      // Close: moderate pulses
      hapticFrequency = 1500;
    } else if (distance < 100) {
      // Medium: slow pulses
      hapticFrequency = 3000;
    } else if (distance < 200) {
      // Far: very slow pulses
      hapticFrequency = 5000;
    }
    // Beyond 200m: no haptic

    if (hapticFrequency) {
      // Immediate first haptic
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);

      // Set up interval for ongoing haptics
      hapticInterval.current = setInterval(() => {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
      }, hapticFrequency);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────
  // CROSSINGS / ENCOUNTERS
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    if (!location || nearbyUsers.length === 0 || ghostMode) return;

    const checkForCrossings = setInterval(() => {
      nearbyUsers.forEach(user => {
        const distance = calculateDistance(
          location.latitude,
          location.longitude,
          user.latitude,
          user.longitude
        );

        // If within 50m for more than 15 seconds, create crossing
        if (distance < 50) {
          user.proximityTime = (user.proximityTime || 0) + 5;

          if (user.proximityTime >= 15) {
            createCrossing(user, distance);
            user.proximityTime = 0; // Reset after creating crossing
          }
        } else {
          user.proximityTime = 0;
        }
      });
    }, 5000);

    return () => clearInterval(checkForCrossings);
  }, [location, nearbyUsers, ghostMode]);

  const createCrossing = (user, distance) => {
    // Check if crossing already exists
    const exists = crossings.some(c => c.userId === user.id);
    if (exists) return;

    const crossing = {
      id: `crossing-${Date.now()}`,
      userId: user.id,
      userName: user.name,
      timestamp: Date.now(),
      distance: Math.round(distance),
      location: 'proche', // Abstract location
    };

    setCrossings(prev => [crossing, ...prev]);
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  };

  const getTimeSinceCrossing = (timestamp) => {
    const diff = Date.now() - timestamp;
    const minutes = Math.floor(diff / 60000);

    if (minutes < 1) return "à l'instant";
    if (minutes < 60) return `il y a ${minutes} min`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `il y a ${hours}h`;
    return `il y a ${Math.floor(hours / 24)}j`;
  };

  // ─────────────────────────────────────────────────────────────────────────
  // CHAT SYSTEM
  // ─────────────────────────────────────────────────────────────────────────

  const startChat = (userId, userName) => {
    setActiveChat({ userId, userName });
    setCurrentView('chat');

    if (!messages[userId]) {
      setMessages(prev => ({ ...prev, [userId]: [] }));
    }
  };

  const sendMessage = () => {
    if (!messageInput.trim() || !activeChat) return;

    const message = {
      id: `msg-${Date.now()}`,
      text: messageInput.trim(),
      sender: 'me',
      timestamp: Date.now(),
    };

    setMessages(prev => ({
      ...prev,
      [activeChat.userId]: [...(prev[activeChat.userId] || []), message],
    }));

    setMessageInput('');
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);

    // Simulate received message (for test mode)
    if (testMode) {
      setTimeout(() => {
        const reply = {
          id: `msg-${Date.now()}`,
          text: ['👋', 'Salut', 'Intéressant...', '😊'][Math.floor(Math.random() * 4)],
          sender: 'them',
          timestamp: Date.now(),
        };

        setMessages(prev => ({
          ...prev,
          [activeChat.userId]: [...(prev[activeChat.userId] || []), reply],
        }));
      }, 2000);
    }
  };

  const deleteChat = (userId) => {
    setMessages(prev => {
      const updated = { ...prev };
      delete updated[userId];
      return updated;
    });

    if (activeChat?.userId === userId) {
      setActiveChat(null);
      setCurrentView('crossings');
    }

    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
  };

  // ─────────────────────────────────────────────────────────────────────────
  // ANIMATIONS
  // ─────────────────────────────────────────────────────────────────────────

  useEffect(() => {
    // Pulse animation for center dot
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 1.3,
          duration: 1500,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1,
          duration: 1500,
          useNativeDriver: true,
        }),
      ])
    ).start();

    // Radar sweep rotation - continuous loop with reset
    radarRotation.setValue(0);
    radarAnimRef.current = Animated.loop(
      Animated.timing(radarRotation, {
        toValue: 1,
        duration: 4000,
        useNativeDriver: true,
        isInteraction: false,
      })
    );
    radarAnimRef.current.start();

    // Update sweep angle for fade effect - use ref to persist across view changes
    if (sweepIntervalRef.current) {
      clearInterval(sweepIntervalRef.current);
    }

    sweepIntervalRef.current = setInterval(() => {
      setRadarSweepAngle(prev => (prev + 2) % 360);
    }, 30);

    return () => {
      if (sweepIntervalRef.current) {
        clearInterval(sweepIntervalRef.current);
      }
      if (radarAnimRef.current) {
        radarAnimRef.current.stop();
      }
    };
  }, []);

  const radarRotationDegrees = radarRotation.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg'],
  });

  // Restart radar animation when returning to radar view
  useEffect(() => {
    if (currentView === 'radar') {
      // Stop existing animation
      if (radarAnimRef.current) {
        radarAnimRef.current.stop();
      }

      // Reset and restart
      radarRotation.setValue(0);
      radarAnimRef.current = Animated.loop(
        Animated.timing(radarRotation, {
          toValue: 1,
          duration: 4000,
          useNativeDriver: true,
          isInteraction: false,
        })
      );
      radarAnimRef.current.start();
    }
  }, [currentView]);

  // ─────────────────────────────────────────────────────────────────────────
  // GHOST MODE - LONG PRESS WITH WAVE ANIMATION
  // ─────────────────────────────────────────────────────────────────────────

  const handleCenterDotLongPress = () => {
    // Immediate haptic feedback at start
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);

    // Show wave animation immediately
    setShowWave(true);

    // Start wave animations (reverse direction - shrink first then expand)
    waveAnim1.setValue(1);
    waveAnim2.setValue(1);
    waveAnim3.setValue(1);

    // Shrink then expand
    Animated.sequence([
      Animated.parallel([
        Animated.timing(waveAnim1, {
          toValue: 0.5,
          duration: 200,
          useNativeDriver: true,
        }),
        Animated.timing(waveAnim2, {
          toValue: 0.5,
          duration: 200,
          delay: 50,
          useNativeDriver: true,
        }),
        Animated.timing(waveAnim3, {
          toValue: 0.5,
          duration: 200,
          delay: 100,
          useNativeDriver: true,
        }),
      ]),
      Animated.parallel([
        Animated.timing(waveAnim1, {
          toValue: 6,
          duration: 800,
          useNativeDriver: true,
        }),
        Animated.timing(waveAnim2, {
          toValue: 6,
          duration: 800,
          delay: 100,
          useNativeDriver: true,
        }),
        Animated.timing(waveAnim3, {
          toValue: 6,
          duration: 800,
          delay: 200,
          useNativeDriver: true,
        }),
      ]),
    ]).start(() => {
      setShowWave(false);
    });

    // Final haptic on toggle
    setTimeout(() => {
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
      setGhostMode(!ghostMode);
    }, 300);
  };

  // ─────────────────────────────────────────────────────────────────────────
  // RADAR VISUALIZATION
  // ─────────────────────────────────────────────────────────────────────────

  const renderRadarDots = () => {
    if (!location || nearbyUsers.length === 0) return null;

    return nearbyUsers.map((user, index) => {
      const distance = calculateDistance(
        location.latitude,
        location.longitude,
        user.latitude,
        user.longitude
      );

      const bearing = calculateBearing(
        location.latitude,
        location.longitude,
        user.latitude,
        user.longitude
      );

      // Calculate relative angle (bearing - heading)
      const relativeAngle = (bearing - heading + 360) % 360;
      const angleRad = (relativeAngle * Math.PI) / 180;

      // Map distance to radar position
      const maxDistance = 200; // meters
      const normalizedDistance = Math.min(distance / maxDistance, 1);

      // Position on radar (0 = center, RADAR_SIZE/2 = edge)
      const radius = normalizedDistance * (RADAR_SIZE / 2 - 30);
      const x = Math.sin(angleRad) * radius;
      const y = -Math.cos(angleRad) * radius;

      // Calculate angle difference for fade effect (classic radar sweep)
      let angleDiff = Math.abs(radarSweepAngle - relativeAngle);
      if (angleDiff > 180) angleDiff = 360 - angleDiff;

      // Fade trail: bright when swept, fades over 90 degrees
      const fadeOpacity = Math.max(0, 1 - angleDiff / 90);

      // Size and intensity based on distance (closer = larger/brighter)
      const dotSize = 15 - normalizedDistance * 8;
      const baseOpacity = 1 - normalizedDistance * 0.5;
      const finalOpacity = baseOpacity * (0.1 + fadeOpacity * 0.9); // 10% ambient + 90% sweep

      return (
        <Animated.View
          key={user.id}
          style={[
            styles.radarDot,
            {
              left: RADAR_SIZE / 2 + x - dotSize / 2,
              top: RADAR_SIZE / 2 + y - dotSize / 2,
              width: dotSize,
              height: dotSize,
              opacity: finalOpacity,
              backgroundColor: distance < 50 ? '#00ff88' : '#00ccff',
            },
          ]}
        />
      );
    });
  };

  // ─────────────────────────────────────────────────────────────────────────
  // UI VIEWS
  // ─────────────────────────────────────────────────────────────────────────

  const renderRadarView = () => {
    return (
      <View style={styles.radarContainer}>
        {/* Radar wrapper */}
        <View style={styles.radarWrapper}>
          {/* Radar circles and sweep (static - don't rotate) */}
          <View style={styles.radarStaticContent}>
            {/* Radar circles */}
            <View style={[styles.radarCircle, { width: RADAR_SIZE, height: RADAR_SIZE }]}>
              <View style={[styles.radarCircle, { width: RADAR_SIZE * 0.66, height: RADAR_SIZE * 0.66 }]}>
                <View style={[styles.radarCircle, { width: RADAR_SIZE * 0.33, height: RADAR_SIZE * 0.33 }]} />
              </View>
            </View>

            {/* Radar sweep - rotating */}
            <Animated.View
              style={[
                styles.radarSweep,
                {
                  width: RADAR_SIZE,
                  height: RADAR_SIZE,
                  transform: [{ rotate: radarRotationDegrees }],
                },
              ]}
            />

            {/* Nearby users as dots - positions calculated based on bearing */}
            {renderRadarDots()}
          </View>

          {/* V-shaped beam indicator - FIXED at top, doesn't rotate */}
          <View style={styles.beamContainer}>
            <View style={styles.beamLeft}>
              <View style={styles.beamTriangleLeft} />
            </View>
            <View style={styles.beamRight}>
              <View style={styles.beamTriangleRight} />
            </View>
          </View>

          {/* Center dot (user) - with long press - NOT rotated */}
          <TouchableOpacity
            activeOpacity={0.8}
            onLongPress={handleCenterDotLongPress}
            delayLongPress={500}
            style={styles.centerDotTouchable}
          >
            <Animated.View
              style={[
                styles.centerDot,
                {
                  transform: [{ scale: pulseAnim }],
                  backgroundColor: ghostMode ? '#999' : '#00ff88',
                  shadowColor: ghostMode ? '#999' : '#00ff88',
                },
              ]}
            />
          </TouchableOpacity>

          {/* Wave animation circles */}
          {showWave && (
            <>
              <Animated.View
                style={[
                  styles.waveCircle,
                  {
                    transform: [{ scale: waveAnim1 }],
                    opacity: waveAnim1.interpolate({
                      inputRange: [0.5, 1, 6],
                      outputRange: [0.8, 0.6, 0],
                    }),
                    borderColor: ghostMode ? '#00ff88' : '#999',
                  },
                ]}
              />
              <Animated.View
                style={[
                  styles.waveCircle,
                  {
                    transform: [{ scale: waveAnim2 }],
                    opacity: waveAnim2.interpolate({
                      inputRange: [0.5, 1, 6],
                      outputRange: [0.6, 0.4, 0],
                    }),
                    borderColor: ghostMode ? '#00ff88' : '#999',
                  },
                ]}
              />
              <Animated.View
                style={[
                  styles.waveCircle,
                  {
                    transform: [{ scale: waveAnim3 }],
                    opacity: waveAnim3.interpolate({
                      inputRange: [0.5, 1, 6],
                      outputRange: [0.4, 0.2, 0],
                    }),
                    borderColor: ghostMode ? '#00ff88' : '#999',
                  },
                ]}
              />
            </>
          )}
        </View>

        {/* Status text */}
        <Text style={styles.radarStatusText}>
          {ghostMode ? '○ Mode Invisible' : `${nearbyUsers.length} présence${nearbyUsers.length > 1 ? 's' : ''} détectée${nearbyUsers.length > 1 ? 's' : ''}`}
        </Text>
      </View>
    );
  };

  const renderCrossingsView = () => (
    <ScrollView style={styles.listContainer}>
      <Text style={styles.sectionTitle}>Croisements</Text>

      {crossings.length === 0 ? (
        <Text style={styles.emptyText}>Aucun croisement pour le moment</Text>
      ) : (
        crossings.map(crossing => (
          <TouchableOpacity
            key={crossing.id}
            style={styles.crossingItem}
            onPress={() => startChat(crossing.userId, crossing.userName)}
          >
            <View style={styles.crossingDot} />
            <View style={styles.crossingInfo}>
              <Text style={styles.crossingName}>{crossing.userName}</Text>
              <Text style={styles.crossingDetails}>
                {getTimeSinceCrossing(crossing.timestamp)} · {crossing.distance}m · {crossing.location}
              </Text>
            </View>
            <Text style={styles.crossingArrow}>→</Text>
          </TouchableOpacity>
        ))
      )}
    </ScrollView>
  );

  const renderChatView = () => {
    if (!activeChat) return null;

    const chatMessages = messages[activeChat.userId] || [];

    return (
      <View style={styles.chatContainer}>
        {/* Chat header */}
        <View style={styles.chatHeader}>
          <TouchableOpacity onPress={() => setCurrentView('crossings')}>
            <Text style={styles.backButton}>← Retour</Text>
          </TouchableOpacity>
          <Text style={styles.chatTitle}>{activeChat.userName}</Text>
          <TouchableOpacity onPress={() => {
            Alert.alert(
              'Supprimer la conversation',
              'Êtes-vous sûr ?',
              [
                { text: 'Annuler', style: 'cancel' },
                { text: 'Supprimer', onPress: () => deleteChat(activeChat.userId), style: 'destructive' },
              ]
            );
          }}>
            <Text style={styles.deleteButton}>✕</Text>
          </TouchableOpacity>
        </View>

        {/* Messages */}
        <ScrollView style={styles.messagesContainer}>
          {chatMessages.map(msg => (
            <View
              key={msg.id}
              style={[
                styles.messageBubble,
                msg.sender === 'me' ? styles.myMessage : styles.theirMessage,
              ]}
            >
              <Text style={styles.messageText}>{msg.text}</Text>
            </View>
          ))}
        </ScrollView>

        {/* Input */}
        <View style={styles.chatInputContainer}>
          <TextInput
            style={styles.chatInput}
            value={messageInput}
            onChangeText={setMessageInput}
            placeholder="Message..."
            placeholderTextColor="#666"
            multiline
          />
          <TouchableOpacity onPress={sendMessage} style={styles.sendButton}>
            <Text style={styles.sendButtonText}>↑</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  const renderFiltersView = () => (
    <ScrollView style={styles.filtersContainer}>
      <Text style={styles.sectionTitle}>Filtres de visibilité</Text>
      <Text style={styles.filtersDescription}>
        Ces filtres déterminent si vous apparaissez dans le radar des autres
      </Text>

      {/* Age Range */}
      <View style={styles.filterSection}>
        <Text style={styles.filterLabel}>Âge</Text>
        <View style={styles.ageRange}>
          <TextInput
            style={styles.ageInput}
            value={String(userProfile.ageMin)}
            onChangeText={(val) => setUserProfile(prev => ({ ...prev, ageMin: parseInt(val) || 18 }))}
            keyboardType="number-pad"
            placeholderTextColor="#666"
          />
          <Text style={styles.ageRangeSeparator}>–</Text>
          <TextInput
            style={styles.ageInput}
            value={String(userProfile.ageMax)}
            onChangeText={(val) => setUserProfile(prev => ({ ...prev, ageMax: parseInt(val) || 99 }))}
            keyboardType="number-pad"
            placeholderTextColor="#666"
          />
        </View>
      </View>

      {/* Role */}
      <View style={styles.filterSection}>
        <Text style={styles.filterLabel}>Rôle</Text>
        <View style={styles.roleButtons}>
          {['top', 'versatile', 'bottom'].map(role => (
            <TouchableOpacity
              key={role}
              style={[
                styles.roleButton,
                userProfile.role === role && styles.roleButtonActive,
              ]}
              onPress={() => {
                setUserProfile(prev => ({ ...prev, role }));
                Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
              }}
            >
              <Text style={[
                styles.roleButtonText,
                userProfile.role === role && styles.roleButtonTextActive,
              ]}>
                {role.charAt(0).toUpperCase() + role.slice(1)}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Visibility */}
      <View style={styles.filterSection}>
        <View style={styles.filterRow}>
          <Text style={styles.filterLabel}>Visible dans le radar</Text>
          <Switch
            value={userProfile.visible}
            onValueChange={(val) => {
              setUserProfile(prev => ({ ...prev, visible: val }));
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            }}
            trackColor={{ false: '#333', true: '#00ff88' }}
            thumbColor={userProfile.visible ? '#fff' : '#666'}
          />
        </View>
      </View>

      {/* Test Mode (temporary) */}
      <View style={styles.filterSection}>
        <View style={styles.filterRow}>
          <Text style={styles.filterLabel}>Mode Test (utilisateurs fictifs)</Text>
          <Switch
            value={testMode}
            onValueChange={(val) => {
              setTestMode(val);
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
            }}
            trackColor={{ false: '#333', true: '#ff6600' }}
            thumbColor={testMode ? '#fff' : '#666'}
          />
        </View>
        {testMode && (
          <Text style={styles.testModeWarning}>
            ⚠️ Les utilisateurs fictifs apparaissent autour de votre position GPS réelle
          </Text>
        )}
      </View>

      {/* Identity */}
      <View style={styles.filterSection}>
        <Text style={styles.filterLabel}>Identité éphémère</Text>
        <Text style={styles.identityText}>{userProfile.id}</Text>
      </View>
    </ScrollView>
  );

  // ─────────────────────────────────────────────────────────────────────────
  // MAIN RENDER
  // ─────────────────────────────────────────────────────────────────────────

  if (!locationPermission || locationPermission === 'denied') {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.permissionContainer}>
          <Text style={styles.permissionTitle}>📍 Localisation requise</Text>
          <Text style={styles.permissionText}>
            Gaydar a besoin de votre localisation pour détecter les présences à proximité.
          </Text>
          <TouchableOpacity
            style={styles.permissionButton}
            onPress={requestLocationPermissions}
          >
            <Text style={styles.permissionButtonText}>Autoriser</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  if (!location) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text style={styles.loadingText}>Localisation en cours...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" />

      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.logo}>Gaydar</Text>
        <Text style={[
          styles.headerStatus,
          { color: ghostMode ? '#999' : '#00ff88' }
        ]}>
          {ghostMode ? '○ Invisible' : '● Visible'}
        </Text>
      </View>

      {/* Main Content */}
      <View style={styles.content}>
        {currentView === 'radar' && renderRadarView()}
        {currentView === 'crossings' && renderCrossingsView()}
        {currentView === 'chat' && renderChatView()}
        {currentView === 'filters' && renderFiltersView()}
      </View>

      {/* Bottom Navigation */}
      {currentView !== 'chat' && (
        <View style={styles.bottomNav}>
          <TouchableOpacity
            style={styles.navButton}
            onPress={() => {
              setCurrentView('radar');
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            }}
          >
            <Text style={[styles.navIcon, currentView === 'radar' && styles.navIconActive]}>
              ◉
            </Text>
            <Text style={[styles.navLabel, currentView === 'radar' && styles.navLabelActive]}>
              Radar
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.navButton}
            onPress={() => {
              setCurrentView('crossings');
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            }}
          >
            <Text style={[styles.navIcon, currentView === 'crossings' && styles.navIconActive]}>
              ⋈
            </Text>
            <Text style={[styles.navLabel, currentView === 'crossings' && styles.navLabelActive]}>
              Croisements
            </Text>
            {crossings.length > 0 && (
              <View style={styles.badge}>
                <Text style={styles.badgeText}>{crossings.length}</Text>
              </View>
            )}
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.navButton}
            onPress={() => {
              setCurrentView('filters');
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
            }}
          >
            <Text style={[styles.navIcon, currentView === 'filters' && styles.navIconActive]}>
              ◐
            </Text>
            <Text style={[styles.navLabel, currentView === 'filters' && styles.navLabelActive]}>
              Filtres
            </Text>
          </TouchableOpacity>
        </View>
      )}
    </SafeAreaView>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// STYLES
// ═══════════════════════════════════════════════════════════════════════════

const styles = StyleSheet.create({
  // ─── Container ───
  container: {
    flex: 1,
    backgroundColor: '#0a0a0a',
  },

  // ─── Permission Screen ───
  permissionContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 30,
  },
  permissionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: '#fff',
    marginBottom: 15,
  },
  permissionText: {
    fontSize: 16,
    color: '#999',
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: 30,
  },
  permissionButton: {
    backgroundColor: '#00ff88',
    paddingHorizontal: 40,
    paddingVertical: 15,
    borderRadius: 25,
  },
  permissionButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#0a0a0a',
  },

  // ─── Loading ───
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    fontSize: 16,
    color: '#999',
  },

  // ─── Header ───
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#1a1a1a',
  },
  logo: {
    fontSize: 22,
    fontWeight: '700',
    color: '#fff',
    letterSpacing: 1,
  },
  headerStatus: {
    fontSize: 13,
    fontWeight: '600',
  },

  // ─── Content ───
  content: {
    flex: 1,
  },

  // ─── Radar ───
  radarContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  radarWrapper: {
    width: RADAR_SIZE,
    height: RADAR_SIZE,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  radarStaticContent: {
    width: RADAR_SIZE,
    height: RADAR_SIZE,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
  },
  radarCircle: {
    position: 'absolute',
    borderWidth: 1,
    borderColor: '#1a1a1a',
    borderRadius: 9999,
    justifyContent: 'center',
    alignItems: 'center',
  },
  radarSweep: {
    position: 'absolute',
    borderRadius: 9999,
    backgroundColor: 'transparent',
    borderWidth: 2,
    borderColor: 'transparent',
    borderTopColor: 'rgba(0, 255, 136, 0.3)',
  },
  radarDot: {
    position: 'absolute',
    borderRadius: 9999,
    shadowColor: '#00ff88',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.8,
    shadowRadius: 8,
    elevation: 5,
  },
  centerDotTouchable: {
    position: 'absolute',
    zIndex: 10,
  },
  centerDot: {
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#00ff88',
    shadowColor: '#00ff88',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 1,
    shadowRadius: 15,
    elevation: 10,
  },
  waveCircle: {
    position: 'absolute',
    width: 40,
    height: 40,
    borderRadius: 20,
    borderWidth: 3,
    backgroundColor: 'transparent',
  },
  // V-shaped beam - FIXED at top
beamContainer: {
  position: 'absolute',
  top: 0,
  width: RADAR_SIZE,
  height: RADAR_SIZE / 2,
  alignItems: 'center',
  justifyContent: 'flex-start',
  transform: [{ rotate: '180deg' }],
},
  beamLeft: {
    position: 'absolute',
    top: 0,
    left: RADAR_SIZE / 2 - RADAR_SIZE / 8,
    width: RADAR_SIZE / 8,
    height: RADAR_SIZE / 2,
    overflow: 'hidden',
  },
  beamTriangleLeft: {
    width: 0,
    height: 0,
    backgroundColor: 'transparent',
    borderStyle: 'solid',
    borderLeftWidth: RADAR_SIZE / 8,
    borderRightWidth: 0,
    borderTopWidth: RADAR_SIZE / 2,
    borderLeftColor: 'transparent',
    borderRightColor: 'transparent',
    borderTopColor: 'rgba(0, 255, 136, 0.2)',
  },
  beamRight: {
    position: 'absolute',
    top: 0,
    right: RADAR_SIZE / 2 - RADAR_SIZE / 8,
    width: RADAR_SIZE / 8,
    height: RADAR_SIZE / 2,
    overflow: 'hidden',
  },
  beamTriangleRight: {
    width: 0,
    height: 0,
    backgroundColor: 'transparent',
    borderStyle: 'solid',
    borderLeftWidth: 0,
    borderRightWidth: RADAR_SIZE / 8,
    borderTopWidth: RADAR_SIZE / 2,
    borderLeftColor: 'transparent',
    borderRightColor: 'transparent',
    borderTopColor: 'rgba(0, 255, 136, 0.2)',
  },
  radarStatusText: {
    position: 'absolute',
    bottom: 50,
    fontSize: 14,
    color: '#999',
    fontWeight: '500',
  },

  // ─── Lists ───
  listContainer: {
    flex: 1,
    padding: 20,
  },
  sectionTitle: {
    fontSize: 28,
    fontWeight: '700',
    color: '#fff',
    marginBottom: 20,
  },
  emptyText: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginTop: 50,
  },

  // ─── Crossings ───
  crossingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#151515',
    padding: 20,
    borderRadius: 15,
    marginBottom: 12,
  },
  crossingDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: '#00ff88',
    marginRight: 15,
  },
  crossingInfo: {
    flex: 1,
  },
  crossingName: {
    fontSize: 17,
    fontWeight: '600',
    color: '#fff',
    marginBottom: 5,
  },
  crossingDetails: {
    fontSize: 13,
    color: '#999',
  },
  crossingArrow: {
    fontSize: 20,
    color: '#666',
  },

  // ─── Chat ───
  chatContainer: {
    flex: 1,
  },
  chatHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#1a1a1a',
  },
  backButton: {
    fontSize: 16,
    color: '#00ff88',
    fontWeight: '600',
  },
  chatTitle: {
    fontSize: 17,
    fontWeight: '600',
    color: '#fff',
  },
  deleteButton: {
    fontSize: 24,
    color: '#ff3b30',
  },
  messagesContainer: {
    flex: 1,
    padding: 20,
  },
  messageBubble: {
    maxWidth: '75%',
    padding: 12,
    borderRadius: 18,
    marginBottom: 10,
  },
  myMessage: {
    alignSelf: 'flex-end',
    backgroundColor: '#00ff88',
  },
  theirMessage: {
    alignSelf: 'flex-start',
    backgroundColor: '#1a1a1a',
  },
  messageText: {
    fontSize: 16,
    color: '#fff',
  },
  chatInputContainer: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    padding: 15,
    borderTopWidth: 1,
    borderTopColor: '#1a1a1a',
  },
  chatInput: {
    flex: 1,
    backgroundColor: '#1a1a1a',
    borderRadius: 20,
    paddingHorizontal: 15,
    paddingVertical: 10,
    fontSize: 16,
    color: '#fff',
    maxHeight: 100,
  },
  sendButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: '#00ff88',
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: 10,
  },
  sendButtonText: {
    fontSize: 20,
    color: '#0a0a0a',
    fontWeight: '700',
  },

  // ─── Filters ───
  filtersContainer: {
    flex: 1,
    padding: 20,
  },
  filtersDescription: {
    fontSize: 14,
    color: '#999',
    marginBottom: 30,
    lineHeight: 20,
  },
  filterSection: {
    marginBottom: 30,
  },
  filterLabel: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
    marginBottom: 12,
  },
  filterRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  ageRange: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  ageInput: {
    backgroundColor: '#1a1a1a',
    borderRadius: 10,
    paddingHorizontal: 20,
    paddingVertical: 12,
    fontSize: 16,
    color: '#fff',
    width: 80,
    textAlign: 'center',
  },
  ageRangeSeparator: {
    fontSize: 20,
    color: '#666',
    marginHorizontal: 15,
  },
  roleButtons: {
    flexDirection: 'row',
    gap: 10,
  },
  roleButton: {
    flex: 1,
    backgroundColor: '#1a1a1a',
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: 'center',
  },
  roleButtonActive: {
    backgroundColor: '#00ff88',
  },
  roleButtonText: {
    fontSize: 15,
    fontWeight: '600',
    color: '#999',
  },
  roleButtonTextActive: {
    color: '#0a0a0a',
  },
  testModeWarning: {
    fontSize: 13,
    color: '#ff6600',
    marginTop: 10,
    lineHeight: 18,
  },
  identityText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#00ff88',
  },

  // ─── Bottom Navigation ───
  bottomNav: {
    flexDirection: 'row',
    borderTopWidth: 1,
    borderTopColor: '#1a1a1a',
    paddingVertical: 10,
    paddingHorizontal: 10,
  },
  navButton: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 8,
    position: 'relative',
  },
  navIcon: {
    fontSize: 24,
    color: '#666',
    marginBottom: 4,
  },
  navIconActive: {
    color: '#00ff88',
  },
  navLabel: {
    fontSize: 11,
    color: '#666',
    fontWeight: '600',
  },
  navLabelActive: {
    color: '#00ff88',
  },
  badge: {
    position: 'absolute',
    top: 5,
    right: '30%',
    backgroundColor: '#ff3b30',
    borderRadius: 10,
    minWidth: 20,
    height: 20,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 6,
  },
  badgeText: {
    fontSize: 11,
    fontWeight: '700',
    color: '#fff',
  },
});
