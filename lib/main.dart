import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Views/login_view.dart';
import 'package:notesapp/Views/register_view.dart';
import 'package:notesapp/Views/verify_email.dart';
import 'dart:developer' as dev show log;
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/login/': (context) => const LoginView(),
          '/register/': (context) => const Regester(),
        },
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            dev.log(user.toString());
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Text('loading');
        }
      },
    );
  }
}

enum ActionT { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<ActionT>(
            onSelected: (value) async {
              final shouldlogout = await showalertdialog(context);
              if (shouldlogout) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (routes) => false);
              }
              dev.log(shouldlogout.toString());
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<ActionT>(
                    value: ActionT.logout, child: Text('logout')),
              ];
            },
          )
        ],
      ),
      body: const Text("This is main screen"),
    );
  }
}

Future<bool> showalertdialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout ..."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout")),
        ],
      );
    },
  ).then((value) => value ?? false);
}
