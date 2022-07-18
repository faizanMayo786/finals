import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyFireApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFireApp extends StatefulWidget {
  const MyFireApp({Key? key}) : super(key: key);

  @override
  State<MyFireApp> createState() => _MyFireAppState();
}

class _MyFireAppState extends State<MyFireApp> {
  String name = '';
  String cgpa = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add a Student Record'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person), hintText: 'Student Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    cgpa = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.score), hintText: 'Student CGPA'),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('student').add({
                    'name': name,
                    'cgpa': cgpa,
                  });
                },
                child: Text('Add Student'),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('student')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          var name = data['name'];
                          var cgpa = data['cgpa'];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('CGPA of $name is $cgpa'),
                          );
                        },
                      ),
                    );
                  }
                  return Expanded(child: SizedBox());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
