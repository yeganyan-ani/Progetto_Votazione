import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:votazione/schermate/splashscreen.dart';

// Punto di inizio dell'applicazione
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializzazione Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDVD0j5Fmg81Gi0OGZQPZ4pSf3LV8BSSIQ",
          authDomain: "votazione-13720.firebaseapp.com",
          projectId: "votazione-13720",
          storageBucket: "votazione-13720.appspot.com",
          messagingSenderId: "928295063756",
          appId: "1:928295063756:web:f8297416b747a313bdb269",
          measurementId: "G-FF9ZLVGDPS"),
    );
  } catch (e) {
    Scaffold(
      body: Text('$e'),
    );
  }

  // Inizializzazione schermata iniziale dell'app
  runApp(const MyApp());
}
