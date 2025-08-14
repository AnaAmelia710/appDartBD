import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final bool isProfessor;

  const HomePage({Key? key, required this.userName, this.isProfessor = false})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String userNameFromFirestore = ''; // Variável que vai guardar o nome do Firestore

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Busca o nome assim que a página é inicializada
  }

  Future<void> _fetchUserName() async {
    if (globals.userId != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios') // Sua coleção
            .doc(globals.userId) // Pega o documento pelo userId
            .get();

        if (snapshot.exists) {
          setState(() {
            userNameFromFirestore = snapshot.get('nome'); // Pega o campo "nome"
          });
        }
      } catch (e) {
        print('Erro ao buscar nome do usuário: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openCreationMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Nova Ideia'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Novo Evento'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Novo Conteúdo'),
                onTap: () => Navigator.pop(context),
              ),
              if (widget.isProfessor)
                ListTile(
                  leading: const Icon(Icons.build),
                  title: const Text('Nova Ferramenta'),
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      color: Colors.green.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O projeto Eu Empreendedor incentiva estudantes a tirarem suas ideias do papel, desenvolvendo soluções criativas com impacto social. Explore, crie e compartilhe sua jornada empreendedora com a comunidade!',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeasSection() {
    final List<String> ideiasRecentes = [
      'Aplicativo para reciclagem',
      'Plataforma de estudo colaborativo',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('💡 Ideias Recentes'),
        ...ideiasRecentes.map(
              (idea) => Card(
            color: Colors.green.shade50,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outline, color: Colors.green),
              title: Text(
                idea,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolsSection() {
    final List<String> ferramentas = [
      'Calculadora Financeira',
      'Gerador de Cronogramas',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🛠 Ferramentas Disponíveis'),
        ...ferramentas.map(
              (tool) => Card(
            color: Colors.blue.shade50,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.build, color: Colors.blue),
              title: Text(
                tool,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentsSection() {
    final List<String> conteudosRecomendados = [
      'Vídeo: Como criar um pitch de sucesso',
      'Artigo: 10 passos para empreender na escola',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📚 Conteúdos Recomendados'),
        ...conteudosRecomendados.map(
              (content) => Card(
            color: Colors.orange.shade50,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.orange),
              title: Text(
                content,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedPost(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['professor'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              post['titulo'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(post['descricao']),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(post['data'], style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.place, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(post['local'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
            if (post['imagem'] != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  post['imagem'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post['curtiu'] ? Icons.favorite : Icons.favorite_border,
                    color: post['curtiu'] ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      post['curtiu'] = !post['curtiu'];
                      post['curtidas'] += post['curtiu'] ? 1 : -1;
                    });
                  },
                ),
                Text('${post['curtidas']} curtidas'),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Ver mais')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: Image.asset('assets/menininho.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${userNameFromFirestore.isNotEmpty ? userNameFromFirestore : widget.userName}!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Compartilhe suas ideias hoje mesmo!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.green),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            _buildWelcomeCard(),
            _buildSectionTitle('Eventos Acadêmicos'),

            _buildIdeasSection(),
            _buildToolsSection(),
            _buildContentsSection(),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                tooltip: 'Home',
                icon: const Icon(Icons.home),
                color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                onPressed: () => _onNavTap(0),
              ),
              IconButton(
                tooltip: 'Ideias',
                icon: const Icon(Icons.lightbulb),
                color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                tooltip: 'Eventos',
                icon: const Icon(Icons.event),
                color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                onPressed: () => _onNavTap(2),
              ),
              IconButton(
                tooltip: 'Perfil',
                icon: const Icon(Icons.person),
                color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                onPressed: () => _onNavTap(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreationMenu,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}