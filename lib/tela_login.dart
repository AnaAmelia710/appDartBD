import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Tela de Login")),
      body: FutureBuilder<QuerySnapshot>(
        future: db.collection('usuarios').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar usuários: ${snapshot.error}"));
          }

          // Lista de documentos
          final users = snapshot.data!.docs;

          // Verificar se existem usuários
          if (users.isEmpty) {
            print("Nenhum usuário encontrado na coleção 'usuarios'.");
            return Center(child: Text("Nenhum usuário encontrado."));
          } else {
            print("Usuários encontrados:");
            for (var user in users) {
              print(user.data()); // Imprime todos os dados do usuário
            }
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userName = userData['nome'] ?? 'Nome não encontrado'; // Altere 'nome' para o campo correto

              return ListTile(
                title: Text(userName),
              );
            },
          );
        },
      ),
    );
  }
}