import 'package:flutter/material.dart';
import 'pages/heatmap_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Heatmap Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/heatmap': (context) => const HeatMapExample(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter heatmap example')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
          
            ListTile(
              title: const Text('Heatmap'),
              onTap: () => Navigator.of(context).pushNamed('/heatmap'),
            ),
          ],
        ),
      ),
    );
  }
}
