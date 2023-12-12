import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printooh/printer_page.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'title': "lait cailler", "price": 15, "qty": 2},
    {'title': "Chocolat", "price": 5, "qty": 2},
    {'title': "manbo", "price": 15, "qty": 2},
    {'title': "Biscuit PG", "price": 15, "qty": 2},
    {'title': "Orange", "price": 5, "qty": 2},
    {'title': "Fraize", "price": 5, "qty": 2},
    {'title': "Cartouche", "price": 5, "qty": 2},
    {'title': "Eclaire", "price": 35, "qty": 2},
  ];
  final f = NumberFormat("\$###,###.00", "en_us");

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data
        .map((e) => e['price'] * e['qty'])
        .reduce((value, element) => value + element);

    return Scaffold(
      appBar: AppBar(
        title: Text("Printer"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      title: Text(
                        data[i]['title'].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "${f.format(data[i]['price'])} X ${data[i]['qty']}"),
                      trailing:
                          Text(f.format(data[i]['price'] * data[i]['qty'])),
                    );
                  })),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Total : ${f.format(_total)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BleutoohPage(data: data,)));
                  },
                  icon: Icon(Icons.print),
                  label: Text("Print"),
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
