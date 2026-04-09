import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:provider/provider.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  TextEditingController Email = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController instagram = TextEditingController();
  bool _valid = true;
  Future _validateInput(String input) async {
    // Define a regular expression for validating social links
    RegExp regExp = RegExp(
      r'^https?:\/\/(www\.)?(facebook|twitter|instagram)\.com\/.+',
      caseSensitive: false,
    );
    if (regExp.hasMatch(input)) {
      setState(() {
        _valid = true;
      });
    } else {
      setState(() {
        _valid = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // UserViewModel provider = Provider.of<UserViewModel>(context, listen: false);
    // setState(() {
    //   Email.text = provider.userModel!.data.profile.email;
    //   facebook.text = provider.userModel!.data.profile.facebookId;
    //   instagram.text = provider.userModel!.data.profile.instagramId;
    // });
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
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Social Media',
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Social Media',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: Email,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.link),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(05),
                  ),
                ),
                onChanged: _validateInput,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ),
                ],
              ),
            ),
            if (!_valid)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Please enter a valid social account link',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: facebook,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.link),
                  hintText: 'Facebook ID',
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: 'Facebook ID',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(05),
                  ),
                ),
                onChanged: _validateInput,
                keyboardType: TextInputType.url,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ),
                ],
              ),
            ),
            if (!_valid)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Please enter a valid social account link',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: instagram,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.link),
                  hintText: 'Instagram ID',
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: 'Instagram ID',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(05),
                  ),
                ),
                onChanged: _validateInput,
                keyboardType: TextInputType.url,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ),
                ],
              ),
            ),
            if (!_valid)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Please enter a valid social account link',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
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
                    child: Text(
                      'Save Changes',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
