import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Set the background color of Scaffold
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child:
            Text('Profile Page', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
