import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Expense {
  final String title;
  final double amount;
  final String category;

  const Expense({
    required this.title,
    required this.amount,
    required this.category,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LayarUtama(),
    );
  }
}

class LayarUtama extends StatelessWidget {
  const LayarUtama({super.key});

  @override
  Widget build(BuildContext context) {
    const myExpense = Expense(
      title: "Makan Siang",
      amount: 25000,
      category: "Makanan",
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Aplikasi Pencatatan Keuangan')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wallet, size: 40, color: Colors.indigo),
              const SizedBox(height: 8),
              Text(
                myExpense.title,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              Text(
                'Rp ${myExpense.amount}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Tombol Diklik");
                },
                child: const Text("Tambah Transaksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}