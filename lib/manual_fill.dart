import 'dart:math';
import 'package:flutter/material.dart';

class ManualFillTable extends StatefulWidget {
  final int jumlah_N;
  ManualFillTable({required this.jumlah_N});

  @override
  _ManualFillTableState createState() => _ManualFillTableState();
}

class _ManualFillTableState extends State<ManualFillTable> {
  List<Map<String, TextEditingController>> inputList = [];
  List<double> x1_meanX1 = [];
  List<double> x2_meanX2 = [];
  List<double> x3_meanX3 = [];
  List<double> y1_meanY1 = [];
  List<double> x1_meanX1_2 = [];
  List<double> x2_meanX2_2 = [];
  List<double> x3_meanX3_2 = [];
  List<double> y1_meanY1_2 = [];
  List<double> ytopi = []; // y'
  List<double> error = [];
  double MSE = 0;
  double RMSE = 0;
  double MAE = 0;
  double Cor_y_x1 = 0;
  double Cor_y_x2 = 0;
  double Cor_y_x3 = 0;
  String label_Cor_y_x1 = "";
  String minplus_Cor_y_x1 = "";
  String label_Cor_y_x2 = "";
  String minplus_Cor_y_x2 = "";
  String label_Cor_y_x3 = "";
  String minplus_Cor_y_x3 = "";
  @override
  void initState() {
    super.initState();
    // Inisialisasi list inputan dan hasil kalkulasi
    for (int i = 0; i < widget.jumlah_N; i++) {
      inputList.add({
        'y': TextEditingController(),
        'x1': TextEditingController(),
        'x2': TextEditingController(),
        'x3': TextEditingController(),
      });
      x1_meanX1.add(0.0);
      x2_meanX2.add(0.0);
      x3_meanX3.add(0.0);
      y1_meanY1.add(0.0);
      x1_meanX1_2.add(0.0);
      x2_meanX2_2.add(0.0);
      x3_meanX3_2.add(0.0);
      y1_meanY1_2.add(0.0);
      ytopi.add(0.0);
      error.add(0.0);
    }
  }

  double calculateMean(List<double> data) {
    int n = data.length;
    if (n == 0) return 0.0;

    double sum = data.reduce((a, b) => a + b);
    return sum / n;
  }

  // Fungsi untuk menghitung nilai y' berdasarkan input
  void hitungNilaiY() {
    // List untuk menampung nilai variabel
    List<double> yValues = [];
    List<double> x1Values = [];
    List<double> x2Values = [];
    List<double> x3Values = [];
    for (int i = 0; i < widget.jumlah_N; i++) {
      double y = double.tryParse(inputList[i]['y']!.text) ?? 0.0;
      double x1 = double.tryParse(inputList[i]['x1']!.text) ?? 0.0;
      double x2 = double.tryParse(inputList[i]['x2']!.text) ?? 0.0;
      double x3 = double.tryParse(inputList[i]['x3']!.text) ?? 0.0;

      // Tambahkan nilai ke list
      yValues.add(y);
      x1Values.add(x1);
      x2Values.add(x2);
      x3Values.add(x3);
    }
    // Hitung rata-rata
    double meanY = calculateMean(yValues);
    double meanX1 = calculateMean(x1Values);
    double meanX2 = calculateMean(x2Values);
    double meanX3 = calculateMean(x3Values);
    //xi - x mean & y - y mean
    List<double> x1_xmean =
        x1Values.map((element) => element - meanX1).toList();
    List<double> x2_xmean =
        x2Values.map((element) => element - meanX2).toList();
    List<double> x3_xmean =
        x3Values.map((element) => element - meanX3).toList();
    List<double> y_ymean = yValues.map((element) => element - meanY).toList();

    //xi - x mean ^2 & y - y mean^2
    List<double> x1_xmean2 =
        x1_xmean.map((element) => element * element).toList();
    List<double> x2_xmean2 =
        x2_xmean.map((element) => element * element).toList();
    List<double> x3_xmean2 =
        x3_xmean.map((element) => element * element).toList();
    List<double> y_ymean2 =
        y_ymean.map((element) => element * element).toList();
    //total
    double total_x1_xmean2 = x1_xmean2.reduce((a, b) => a + b);
    double total_x2_xmean2 = x2_xmean2.reduce((a, b) => a + b);
    double total_x3_xmean2 = x3_xmean2.reduce((a, b) => a + b);
    double total_y_ymean2 = y_ymean2.reduce((a, b) => a + b);

    //xi - x mean * y - y mean
    List<double> x1_mpy_y_ymean = List.generate(
        x1_xmean.length, (index) => x1_xmean[index] * y_ymean[index]);
    List<double> x2_mpy_y_ymean = List.generate(
        x1_xmean.length, (index) => x2_xmean[index] * y_ymean[index]);
    List<double> x3_mpy_y_ymean = List.generate(
        x1_xmean.length, (index) => x3_xmean[index] * y_ymean[index]);
    //total
    double total_x1_mpy_y_ymean = x1_mpy_y_ymean.reduce((a, b) => a + b);
    double total_x2_mpy_y_ymean = x2_mpy_y_ymean.reduce((a, b) => a + b);
    double total_x3_mpy_y_ymean = x3_mpy_y_ymean.reduce((a, b) => a + b);

    //b1 = ((x1-x1mean) * (y-ymean)) / (x1-x1mean)^2
    double b1_hasil = (total_x1_mpy_y_ymean) / (total_x1_xmean2);

    //b2 = ((x2-x2mean) * (y-ymean)) / (x2-x2mean)^2
    double b2_hasil = (total_x2_mpy_y_ymean) / (total_x2_xmean2);

    //b3 = ((x3-x3mean) * (y-ymean)) / (x3-x3mean)^2
    double b3_hasil = (total_x3_mpy_y_ymean) / (total_x3_xmean2);

    //b0 = ymean - b1 * x1mean - b2 * x2mean - b3 * x3mean
    double b0_hasil =
        meanY - b1_hasil * meanX1 - b2_hasil * meanX2 - b3_hasil * meanX3;

    //y'  =  b0 + b1 . x1 + b2 . x2 + b3 .x 3
    List<double> ytopi_hasil = List.generate(
        yValues.length,
        (index) =>
            b0_hasil +
            b1_hasil * x1Values[index] +
            b2_hasil * x2Values[index] +
            b3_hasil * x3Values[index]);

    //error
    List<double> error_hasil = List.generate(
        yValues.length, (index) => yValues[index] - ytopi_hasil[index]);

    //abs error
    List<double> error_hasil_positif =
        error_hasil.map((value) => value.abs()).toList();
    double total_error_hasil_positif =
        error_hasil_positif.reduce((a, b) => a + b);
    //abs error ^2
    List<double> error_hasil_positif_2 =
        error_hasil_positif.map((element) => element * element).toList();

    //MSE
    double MSE_hasil = error_hasil_positif_2.isNotEmpty
        ? error_hasil_positif_2.reduce((a, b) => a + b) /
            error_hasil_positif_2.length
        : 0.0;

    //RMSE
    double RMSE_hasil = sqrt(MSE);

    //MAE
    double MAE_hasil = error_hasil_positif.isNotEmpty
        ? error_hasil_positif.reduce((a, b) => a + b) /
            error_hasil_positif.length
        : 0.0;

    //COR(y, x1)
    double Cor_y_x1_hasil =
        total_x1_mpy_y_ymean / sqrt(total_x1_xmean2 * total_y_ymean2);

    //COR(y, x2)
    double Cor_y_x2_hasil =
        total_x2_mpy_y_ymean / sqrt(total_x2_xmean2 * total_y_ymean2);

    //COR(y, x3)
    double Cor_y_x3_hasil =
        total_x3_mpy_y_ymean / sqrt(total_x3_xmean2 * total_y_ymean2);

// update keterangan positif / negatif dan kuat / lemah Cor(y,xi)
    setState(() {
      label_Cor_y_x1 = interpretasiKorelasi(Cor_y_x1_hasil);
      minplus_Cor_y_x1 = Cor_y_x1_hasil >= 0 ? 'positif' : 'negatif';

      label_Cor_y_x2 = interpretasiKorelasi(Cor_y_x2_hasil);
      minplus_Cor_y_x2 = Cor_y_x2_hasil >= 0 ? 'positif' : 'negatif';

      label_Cor_y_x3 = interpretasiKorelasi(Cor_y_x3_hasil);
      minplus_Cor_y_x3 = Cor_y_x3_hasil >= 0 ? 'positif' : 'negatif';
    });

    //kirim hasil nya ke variabel global
    setState(() {
      x1_meanX1 = List.from(x1_xmean);
      x2_meanX2 = List.from(x2_xmean);
      x3_meanX3 = List.from(x3_xmean);
      y1_meanY1 = List.from(y_ymean);
      print(x1_meanX1);
      print(x2_meanX2);
      print(x3_meanX3);
      print(y1_meanY1);
      //print(x1Values);
      print("x1Values $x1Values");
      print("x2Values $x2Values");
      print("x3Values $x3Values");

      print("meanY $meanY");
      print("meanX1 $meanX1");
      print("meanX2 $meanX2");

      print("x1-xmean $x1_xmean");
      print("x2-xmean $x2_xmean");
      print("x3-xmean $x3_xmean");
      print("y-ymean $y_ymean");

      x1_meanX1_2 = List.from(x1_xmean2);
      x2_meanX2_2 = List.from(x2_xmean2);
      x3_meanX3_2 = List.from(x3_xmean2);
      y1_meanY1_2 = List.from(y_ymean2);

      print(b0_hasil.toStringAsFixed(5));
      print(b1_hasil.toStringAsFixed(5));
      print(b2_hasil.toStringAsFixed(5));
      print(b3_hasil.toStringAsFixed(5));
      ytopi = List.from(ytopi_hasil);
      print("ytopi $ytopi");
      error = List.from(error_hasil);
      print("Erorr $error");
      MSE = MSE_hasil;
      RMSE = RMSE_hasil;
      MAE = MAE_hasil;
      Cor_y_x1 = Cor_y_x1_hasil;
      Cor_y_x2 = Cor_y_x2_hasil;
      Cor_y_x3 = Cor_y_x3_hasil;
    });
  }

  //mengecek kekuatan Cor y tehadap xi
  String interpretasiKorelasi(double r) {
    if (r >= 0.8) {
      return 'sangat kuat';
    } else if (r >= 0.6) {
      return 'kuat';
    } else if (r >= 0.4) {
      return 'sedang';
    } else if (r >= 0.2) {
      return 'lemah';
    } else {
      return 'sangat lemah atau tidak ada korelasi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Fill Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('N')),
                  DataColumn(label: Text('y')),
                  DataColumn(label: Text('x1')),
                  DataColumn(label: Text('x2')),
                  DataColumn(label: Text('x3')),
                  DataColumn(label: Text("x1-x1'")),
                  DataColumn(label: Text("x2-x2'")),
                  DataColumn(label: Text("x3-x3'")),
                  DataColumn(label: Text("y1-y1'")),
                  DataColumn(label: Text("x1-x1'^2")),
                  DataColumn(label: Text("x2-x2'^2")),
                  DataColumn(label: Text("x3-x3'^2")),
                  DataColumn(label: Text("y1-y1'^2")),
                  DataColumn(label: Text("y'")),
                  DataColumn(label: Text("error")),
                ],
                rows: List.generate(
                  widget.jumlah_N,
                  (index) => DataRow(cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(
                      TextField(
                        controller: inputList[index]['y'],
                        decoration: InputDecoration(
                          hintText: '?',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: inputList[index]['x1'],
                        decoration: InputDecoration(
                          hintText: '?',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: inputList[index]['x2'],
                        decoration: InputDecoration(
                          hintText: '?',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: inputList[index]['x3'],
                        decoration: InputDecoration(
                          hintText: '?',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DataCell(Text(x1_meanX1[index].toStringAsFixed(3))),
                    DataCell(Text(x2_meanX2[index].toStringAsFixed(3))),
                    DataCell(Text(x3_meanX3[index].toStringAsFixed(3))),
                    DataCell(Text(y1_meanY1[index].toStringAsFixed(3))),
                    DataCell(Text(x1_meanX1_2[index].toStringAsFixed(3))),
                    DataCell(Text(x2_meanX2_2[index].toStringAsFixed(3))),
                    DataCell(Text(x3_meanX3_2[index].toStringAsFixed(3))),
                    DataCell(Text(y1_meanY1_2[index].toStringAsFixed(3))),
                    DataCell(Text(ytopi[index].toStringAsFixed(5))),
                    DataCell(Text(error[index].toStringAsFixed(5))),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("MSE : $MSE"),
                    Text("RMSE : $RMSE"),
                    Text("MAE : $MAE"),
                    SizedBox(height: 10),
                    Text(
                        "Cor(y,x1) : $Cor_y_x1 $minplus_Cor_y_x1 $label_Cor_y_x1 "),
                    Text(
                        "Cor(y,x2) : $Cor_y_x2 $minplus_Cor_y_x2 $label_Cor_y_x2"),
                    Text(
                        "Cor(y,x3) : $Cor_y_x3 $minplus_Cor_y_x3 $label_Cor_y_x3"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Hitung nilai y' ketika tombol ditekan
                        hitungNilaiY();
                      },
                      child: Text("Hitung"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
