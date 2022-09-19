import 'dart:io';

import 'package:crud_karyawan/KaryawanDB.dart';
import 'package:crud_karyawan/KaryawanModel.dart';
import 'package:crud_karyawan/input_data.dart';
import 'package:crud_karyawan/update_data.dart';
import 'package:flutter/material.dart';

class KaryawanPage extends StatefulWidget {
  const KaryawanPage({Key? key}) : super(key: key);

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  List<KaryawanModel> data = [];
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    data = await KaryawanDatabase.instance.readAll();
    print("Length List " + data.length.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  showDeleteDialog(BuildContext context, int? id) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await KaryawanDatabase.instance.delete(id);
        read();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Karyawan List"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => InputDataPage()));
          Future.delayed(Duration(seconds: 2));
          read();
        },
      ),
      body:
      isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.length == 0 ? Center(child: Text("no data available"),) :ListView.builder(
              itemCount: data.length,
              itemBuilder: (c, index) {
                final item = data[index];
                return Card(
                  child: ListTile(
                    onTap: () async{
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => UpdateDataPage(id: item.id)));
                      Future.delayed(Duration(seconds: 2));
                      read();
                    },
                    leading: Container(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(item.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.name, style: TextStyle(fontSize: 16),),
                    subtitle: Text(item.date),
                    trailing: IconButton(
                      onPressed: () {
                        showDeleteDialog(context, item.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    ));
  }
}
