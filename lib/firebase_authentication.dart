import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  String email = '';
  String passwrod = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                onChanged: (value) {
                  passwrod = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // if you want create a user or signup
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: passwrod);
                    // if you want to login
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: passwrod);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          email: email,
                        ),
                      ),
                    );
                  },
                  child: Text('Login'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.email}) : super(key: key);
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I am Loggedd In with $email'),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
