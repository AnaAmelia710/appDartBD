import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final emailController = TextEditingController();

  Future<void> enviarLinkRecuperacao() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      _mostrarMensagem("Informe o e-mail.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _mostrarMensagem(
          "Link de recuperação enviado! Verifique seu e-mail.");
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao enviar link de recuperação.";
      if (e.code == 'user-not-found') {
        msg = "E-mail não cadastrado.";
      }
      _mostrarMensagem(msg);
    }
  }

  void _mostrarMensagem(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Digite seu e-mail"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: enviarLinkRecuperacao,
              child: const Text("Enviar link de recuperação"),
            ),
          ],
        ),
      ),
    );
  }
}
