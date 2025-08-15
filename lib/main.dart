import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'tela_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Certifique-se de que este arquivo existe e está correto

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase inicializado com sucesso.");
  } catch (e) {
    print("Erro ao inicializar Firebase: $e");
    return; // Para evitar que o app rode sem inicialização
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

