import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 80, color: Colors.pink),
              SizedBox(height: 20),
              Text(
                'Vibe',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text('Social Media & Matching App'),
              SizedBox(height: 20),
              Text('✅ Backend: Setup Complete'),
              Text('✅ Frontend: Setup Complete'),
              Text('⏳ Phase 2: Authentication incoming...'),
            ],
          ),
        ),
      ),
    );
  }
}
