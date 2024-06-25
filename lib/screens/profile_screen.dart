import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takoett/screens/user/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _logout(),
            child: const Text(
              'LOGOUT',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Simpan'),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}
