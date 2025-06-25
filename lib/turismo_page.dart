import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TurismoPage extends StatefulWidget {
  const TurismoPage({super.key});

  @override
  State<TurismoPage> createState() => _TurismoPageState();
}

class _TurismoPageState extends State<TurismoPage> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String descripcion = '';
  int valor = 0;
  String imagenUrl = '';

  Future<void> _agregarLugar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('turismo').add({
        'lugar': nombre,
        'descripcion': descripcion,
        'valor': valor,
        'imagenUrl': imagenUrl,
      });
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lugares turísticos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Lugar'),
                    validator: (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
                    onSaved: (value) => nombre = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
                    onSaved: (value) => descripcion = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Calificación (0-10)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final val = double.tryParse(value ?? '');
                      if (val == null || val < 0 || val > 10) {
                        return 'Ingrese una calificación válida';
                      }
                      return null;
                    },
                    onSaved: (value) => valor = int.parse(value!),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'URL de la imagen'),
                    validator: (value) => value!.isEmpty ? 'Ingrese la URL de la imagen' : null,
                    onSaved: (value) => imagenUrl = value!,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _agregarLugar,
                    child: const Text('Agregar lugar'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('turismo').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('No hay lugares aún.'));
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final lugar = docs[index];
                    final data = lugar.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: data['imagenUrl'] != null && data['imagenUrl'].isNotEmpty
                          ? Image.network(data['imagenUrl'], width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text(data['lugar'] ?? 'Sin nombre'),
                      subtitle: Text(data['descripcion'] ?? 'Sin descripción'),
                      trailing: Text(
                        '⭐ ${data.containsKey('valor') && data['valor'] != null ? data['valor'].toString() : 'N/A'}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
 ),
);
}
}