import 'package:flutter/material.dart';
import 'package:flutter_application_1/manual_fill.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController jumlah_N = TextEditingController();
  double result = 0.0;

  void calculateResult() {
    double a = double.tryParse(jumlah_N.text) ?? 0.0;

    setState(() {
      result = a + a;
    });
  }

  void startManualFill() {
    int n = int.tryParse(jumlah_N.text) ?? 0;

    if (n >= 4) {
      // Only navigate to ManualFillTable if N is greater than or equal to 3
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManualFillTable(jumlah_N: n),
        ),
      );
    } else {
      // Show an alert or message indicating that N must be at least 3
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("N harus lebih dari 4."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MSE MAES PSNR",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text("Perhitungan"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Jumlah Data N  : "),
              TextField(
                controller: jumlah_N,
                decoration: InputDecoration(
                  hintText: "N",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Start the process only if N is at least 3
                  startManualFill();
                },
                child: Text("Mulai"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
