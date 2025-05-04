import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parcial02/views/home_view.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'views/login_view.dart';
import 'views/message_list_view.dart';
import 'views/register_view.dart';
import 'views/user_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//Inicializar las notificaciones y obtener el token FCM
  await FirebaseService().initializeNotifications();
//Iniciar aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parcial Final',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/users': (context) => const UsersListView(),
        '/messages': (context) => const MessagesListView(),
      },
    );
  }
}
