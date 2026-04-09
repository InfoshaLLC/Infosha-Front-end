import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/config/const.dart';

class TermsAndServices extends StatefulWidget {
  const TermsAndServices({super.key});

  @override
  State<TermsAndServices> createState() => TermsandServicesState();
}

class TermsandServicesState extends State<TermsAndServices> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* bottomSheet: BottomSheet(
        onClosing: () {},
        elevation: 30,
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val!;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Color(0xff1B2870),
                        hoverColor: Colors.green,
                        side: BorderSide(
                          color: Colors.grey, //your desire colour here
                          width: 1.5,
                        ),
                      ),
                    ),
                    Text('I agree with the '),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 156,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: Color(0xff1B2870),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 156,
                        height: 40,
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
                          child: Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          );
        },
      ), */
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Terms and Services',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  termscondition,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
