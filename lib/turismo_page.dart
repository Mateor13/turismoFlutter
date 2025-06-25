import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle_lugar.dart';

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
  bool _showForm = false; // Variable para controlar la visibilidad del formulario

  Future<void> _agregarLugar() async {
    if (_formKey.currentState!.validate() && valor > 0) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('turismo').add({
        'lugar': nombre,
        'descripcion': descripcion,
        'valor': valor,
        'imagenUrl': imagenUrl,
      });
      _formKey.currentState!.reset();
      setState(() {
        valor = 0;
        _showForm = false; // Ocultar formulario después de agregar
      });
    }
  }

  Widget _buildStarRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calificación',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  valor = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.star,
                  size: 35,
                  color: index < valor ? Colors.amber : Colors.grey[300],
                ),
              ),
            );
          }),
        ),
        if (valor == 0)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Seleccione una calificación',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFormOverlay() {
  return DraggableScrollableSheet(
    initialChildSize: 0.7, // Tamaño inicial del 70% de la pantalla
    minChildSize: 0.5,     // Tamaño mínimo del 50%
    maxChildSize: 0.9,     // Tamaño máximo del 90%
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador de arrastre
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Barra superior con título y botón cerrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Agregar lugar turístico',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showForm = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Campos del formulario
                  Column(
                    children: [
                      // Campo lugar (arriba)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Lugar',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese un nombre' : null,
                        onSaved: (value) => nombre = value!,
                      ),
                      const SizedBox(height: 12),
                      
                      // Campo URL imagen
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'URL de imagen',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese la URL' : null,
                        onSaved: (value) => imagenUrl = value!,
                      ),
                      const SizedBox(height: 12),
                      
                      // Campo descripción
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese una descripción' : null,
                        onSaved: (value) => descripcion = value!,
                      ),
                      const SizedBox(height: 16),
                      
                      // Calificación con estrellas
                      _buildStarRating(),
                      const SizedBox(height: 24),
                      
                      // Botón agregar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: valor > 0 ? _agregarLugar : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Agregar lugar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      
                      // Espacio adicional para el teclado
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 200 : 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        title: const Text('Lugares turísticos'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Stack(
        children: [
          // Lista de lugares
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('turismo')
                .orderBy('lugar')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay lugares aún',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Agrega tu primer lugar turístico',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final lugar = docs[index];
                  final data = lugar.data() as Map<String, dynamic>;
                  
                  // Convertir valor a int de forma segura
                  int rating = 0;
                  if (data.containsKey('valor') && data['valor'] != null) {
                    if (data['valor'] is String) {
                      rating = int.tryParse(data['valor']) ?? 0;
                    } else if (data['valor'] is int) {
                      rating = data['valor'];
                    }
                  }

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: data['imagenUrl'] != null &&
                                  data['imagenUrl'].isNotEmpty
                              ? Image.network(
                                  data['imagenUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.place,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                        ),
                      ),
                      title: Text(
                        data['lugar'] ?? 'Sin nombre',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            data['descripcion'] ?? 'Sin descripción',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < rating 
                                          ? Colors.amber 
                                          : Colors.grey[300],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '($rating)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleLugarPage(data: data),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          
          // Overlay del formulario
          if (_showForm) _buildFormOverlay(),
        ],
      ),
      
      // Botón flotante
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showForm 
            ? null 
            : FloatingActionButton(
                key: const ValueKey('add_button'),
                onPressed: () {
                  setState(() {
                    _showForm = true;
                  });
                },
                backgroundColor: Colors.blue[600],
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}