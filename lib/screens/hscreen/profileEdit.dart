import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
// ignore_for_file: prefer_const_constructors

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

SingleValueDropDownController _countrycontroller = SingleValueDropDownController();
SingleValueDropDownController _citycontroller = SingleValueDropDownController();
TextEditingController _dateController = TextEditingController();
DateTime? selectedDate;
DateTime? picked;
File? _profileImage;

class _ProfileEditState extends State<ProfileEdit> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        print(_dateController.text + "     humail date");
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
//                                     Get.back();
                  _pickImageFromCamera();
                  //   profilerController.uploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  // Get.back();
                  _pickImageFromGallery();
                  //  profilerController
                  //      .uploadImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(
        () {
          _profileImage = File(pickedImage.path);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Edit Bio',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Center(
              //   child: CircleAvatar(
              //     backgroundImage: AssetImage('images/picture.jpg'),
              //     radius: 50.0,
              //   ),
              // ),
              Container(
                color: Colors.transparent,
                height: 120,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(195, 222, 222, 224),
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null ? Icon(Icons.person) : null,
                      //Icon(Icons.person,color: AppTheme.whiteColor, size: 30,) : null
                    ),
                    Positioned(
                        bottom: -7,
                        right: 120,
                        child: RawMaterialButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          elevation: 0.0,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0XFFAADEFF),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          //   padding: EdgeInsets.only(top: 10),
                          shape: CircleBorder(),
                        )),
                  ],
                ),
              ),
              // CircleAvatar(
              //   radius: 15,
              //   backgroundColor: Color(0XFFAADEFF),
              //   child: IconButton(
              //     color: Colors.grey[700],
              //     onPressed: () {},
              //     icon: Icon(
              //       Icons.camera_alt_outlined,
              //       size: 19,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Nickname',
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: 'Nickname',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(05),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 370,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(05),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Profession',
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: 'Profession',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(05),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Gender',
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(05),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 370,
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        child: Icon(Icons.calendar_month_outlined),
                        onTap: () {
                          _selectDate(context);
                          // setState(() {
                          //   _dateController.text =
                          //       DateFormat('yyyy-MM-dd').format(picked!);
                          // });
                        },
                      ),
                      hintText: 'Date of Birth',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(05),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Place',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropDownTextField(
                  controller: _countrycontroller,
                  clearOption: true,
                  textFieldDecoration:
                      InputDecoration(hintText: "Select Country", labelText: "Select Country", border: OutlineInputBorder(borderSide: BorderSide())),
                  searchDecoration: InputDecoration(),
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please Select Any Country";
                    }
                  },
                  dropDownItemCount: 6,
                  dropDownList: const [
                    DropDownValueModel(name: 'Pakistan', value: "value1"),
                    DropDownValueModel(name: 'USA', value: "value2"),
                    DropDownValueModel(name: 'UK', value: "value3"),
                    DropDownValueModel(name: 'India', value: "value4"),
                    DropDownValueModel(name: 'Canada', value: "value5"),
                    DropDownValueModel(name: 'Bangladesh', value: "value6"),
                    DropDownValueModel(name: 'Nepal', value: "value7"),
                    DropDownValueModel(name: 'Macedonia', value: "value8"),
                  ],
                  onChanged: (val) {
                    setState(
                      () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropDownTextField(
                  controller: _citycontroller,
                  clearOption: true,
                  textFieldDecoration:
                      InputDecoration(hintText: "Select City", labelText: "Select City", border: OutlineInputBorder(borderSide: BorderSide())),
                  searchDecoration: InputDecoration(hintText: "enter your custom hint text here"),
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please Select City";
                    }
                  },
                  dropDownItemCount: 6,
                  dropDownList: const [
                    DropDownValueModel(name: 'Lahore', value: "value1"),
                    DropDownValueModel(name: 'Islamabad', value: "value2"),
                    DropDownValueModel(name: 'Karachi', value: "value3"),
                    DropDownValueModel(name: 'Faisalabad', value: "value4"),
                    DropDownValueModel(name: 'Quetta', value: "value5"),
                    DropDownValueModel(name: 'Sialkot', value: "value6"),
                    DropDownValueModel(name: 'Gujranwala', value: "value7"),
                    DropDownValueModel(name: 'Rawalpindi', value: "value8"),
                  ],
                  onChanged: (val) {
                    setState(
                      () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 370,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Adress',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Adress',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(05),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 45.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color(0xff1B2870),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
