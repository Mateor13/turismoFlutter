import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'turismo_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno PRIMERO
  await dotenv.load(fileName: ".env");
  
  // Verificar que las variables se cargaron
  print('API Key loaded: ${dotenv.env['FIREBASE_API_KEY']?.substring(0, 10)}...');
  print('Project ID: ${dotenv.env['FIREBASE_PROJECT_ID']}');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Turismo Firebase",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TurismoPage(),
    );
  }
}