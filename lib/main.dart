import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Tela de Login")),
      body: Container(
        color: Colors.pink[100], // Fundo rosa
        child: FutureBuilder<QuerySnapshot>(
          future: db.collection('usuarios').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print("Erro ao carregar usuários: ${snapshot.error}");
              return Center(child: Text("Erro ao carregar usuários: ${snapshot.error}"));
            }

            final users = snapshot.data?.docs ?? [];

            if (users.isEmpty) {
              print("Nenhum usuário encontrado na coleção 'usuarios'.");
              return Center(child: Text("Nenhum usuário encontrado."));
            } else {
              print("Usuários encontrados:");
              for (var user in users) {
                print(user.data());
              }
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final userName = userData['nome'] ?? 'Nome não encontrado';

                return ListTile(
                  title: Text(userName),
                );
              },
            );
          },
        ),
      ),
    );
  }
}