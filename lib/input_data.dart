import 'dart:io';

import 'package:crud_karyawan/KaryawanDB.dart';
import 'package:crud_karyawan/KaryawanModel.dart';
import 'package:crud_karyawan/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputDataPage extends StatefulWidget {
  const InputDataPage({Key? key}) : super(key: key);

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
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

  Future addData() async {
    var karyawan;
    karyawan = KaryawanModel(
        imagePath: imgPath, name: nameController.text, date: positionController.text);
    await KaryawanDatabase.instance.create(karyawan);
    Navigator.pop(context, "result");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Input Data"),
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
                height: 10,
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
              SizedBox(height: 10,),
              Container(
                height: 200,
                width: 200,
                child: pickedImage == null ? Center(child: Text("No Image Picked"),) : Image.file(File(pickedImage!.path)),
              ),
              SizedBox(height: 20,),
              Container(
                width: 350,
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    addData();
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
