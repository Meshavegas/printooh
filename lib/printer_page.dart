import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BleutoohPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const BleutoohPage({super.key, required this.data});

  @override
  State<BleutoohPage> createState() => _BleutoohPage();
}

class _BleutoohPage extends State<BleutoohPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _deviceMSg = "";
  final f = NumberFormat("\$###,###.00", "en_us");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));
    if (!mounted) return;
    bluetoothPrint.scanResults.listen((event) {
      if (!mounted) return;
      setState(() => _devices = event);
      if (_devices.isEmpty) {
        setState(() {
          _deviceMSg = "No Devices";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select Printer'),
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_deviceMSg ?? ""),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name ?? ""),
                  subtitle: Text(_devices[i].address ?? ""),
                  onTap: () {
                    _startPrinting(_devices[i]);
                  },
                );
              }),
    );
  }

  Future<void> _startPrinting(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint
          .connect(device)
          .then((value) => Fluttertoast.showToast(
              msg: " ${value.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0))
          .catchError((value) => Fluttertoast.showToast(
              msg: value.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0));

      Map<String, dynamic> config = Map();
      List<LineText> list = [];

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "Tiket de Caisse Rond point",
        weight: 2,
        width: 2,
        height: 2,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));

      for (var i = 0; i < widget.data.length; i++) {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: widget.data[i]['title'],
            width: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "${f.format(this.widget.data[i]['price'])} X ${this.widget.data[i]['qty']}",
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
      }
      await bluetoothPrint
          .printReceipt(config, list)
          .then((value) => Fluttertoast.showToast(
              msg: " ${value.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0))
          .catchError((value) => Fluttertoast.showToast(
              msg: value.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0));
    }
  }
}
