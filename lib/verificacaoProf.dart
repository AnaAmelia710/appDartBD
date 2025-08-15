import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class VerificacaoProfessorPage extends StatefulWidget {
  final String userId;
  const VerificacaoProfessorPage({super.key, required this.userId});

  @override
  State<VerificacaoProfessorPage> createState() => _VerificacaoProfessorPageState();
}

class _VerificacaoProfessorPageState extends State<VerificacaoProfessorPage> {
  final codigoController = TextEditingController();

  Future<void> verificarCodigo() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.userId)
        .get();

    if (!doc.exists) return;

    final dados = doc.data()!;
    if (dados['codigoVerificacao'] == codigoController.text.trim()) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.userId)
          .update({'verificado': true});

   Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(
        userName: dados['nome'],
        isProfessor: true,
      ),
    ),
  );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Código incorreto, tente novamente."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Digite o código enviado no seu e-mail institucional"),
            const SizedBox(height: 20),
            TextField(controller: codigoController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarCodigo,
              child: const Text("Verificar"),
            ),
          ],
        ),
      ),
    );
  }
}
