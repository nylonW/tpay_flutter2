import 'package:flutter/material.dart';
import 'package:tpay_flutter2/tpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () async {
                final payment = TpayPayment(
                  id: '1010',
                  amount: '313.40',
                  crc: 'CRC',
                  description: 'Zakupy',
                  securityCode: 'demo',
                  clientEmail: 'email@email.com',
                  clientName: 'Jan Kowalski',
                );

                final TpayResult response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TpayScreen(
                      payment: payment,
                      title: const Text("Płatność"),
                    ),
                  ),
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Response: ${(response).name}'),
                  ),
                );
              },
              child: const Text('Start payment'),
            ),
          ],
        ),
      ),
    );
  }
}
