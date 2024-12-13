import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          authState != null
              ? ElevatedButton(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logout();
                  },
                  child: Text('Logout'),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: ValueKey('username'),
              decoration: InputDecoration(labelText: 'Username'),
              onSubmitted: (value) async {
                try {
                  await ref.read(authStateProvider.notifier).login(value);
                  Navigator.pushReplacementNamed(context, '/chat');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              authState == null
                  ? 'Please log in'
                  : 'Welcome, you are logged in!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
