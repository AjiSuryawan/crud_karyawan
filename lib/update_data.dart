import 'dart:io';

import 'package:crud_karyawan/KaryawanDB.dart';
import 'package:crud_karyawan/KaryawanModel.dart';
import 'package:crud_karyawan/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDataPage extends StatefulWidget {
  final int? id;
  const UpdateDataPage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  var imgPath;
  XFile? pickedImage;

  Future getImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        setState(() {
          imgPath = pickedImage!.path;
          print(imgPath);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image was selected"),
          ),
        );
      }
    } catch (e) {
      print(e);
      print("error");
    }
  }

  Future readItem() async{
    KaryawanModel model = await KaryawanDatabase.instance.read(widget.id);
    setState(() {
      nameController.text = model.name;
      positionController.text = model.date;
      imgPath = model.imagePath;
      print(imgPath);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readItem();
  }

  Future updateData() async {
    var karyawan;
    karyawan = KaryawanModel(
        id: widget.id,
        imagePath: imgPath,
        name: nameController.text,
        date: positionController.text);
    await KaryawanDatabase.instance.update(karyawan);
    Navigator.pop(context, "update");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Update Data"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              TextFormField(
                controller: nameController,
                style: TextStyle(fontSize: 19, color: Colors.black),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: positionController,
                style: TextStyle(fontSize: 19, color: Colors.black),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Position",
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: ElevatedButton(
                  child: Text("Choose Image"),
                  onPressed: () {
                    getImage();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: 200,
                child: imgPath == null
                    ? Center(
                        child: Text("No Image Picked"),
                      )
                    : Image.file(File(imgPath)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    updateData();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
